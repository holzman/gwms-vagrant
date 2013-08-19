#!/bin/bash

cat > ssl.cnf <<"EOF"
[ ca ]
default_ca = personalca

[ personalca ]
dir = ./selfca
certs = $dir/certs
database = $dir/index.txt
new_certs_dir = $dir/certs
certificate = $dir/certs/ca.pem
serial = $dir/serial
private_key = $dir/private/ca.key
default_days = 3650
default_md = sha1
policy = mypolicy

[ mypolicy ]
commonName = supplied

[ req ]
prompt = no
distinguished_name = root_ca_distinguished_name

[ root_ca_distinguished_name ]
CN = vagrant-gwms-self-ca
EOF

cat > client.cnf <<"EOF"
[ req ]
prompt = no
distinguished_name = distinguished_name

[ distinguished_name ]
CN = $ENV::dn
EOF

# setup dirs
rm -rf selfca clientcerts
mkdir -p selfca/certs selfca/crl selfca/private clientcerts
touch selfca/index.txt
chmod 700 selfca/private
echo "01" > selfca/serial
mv *.cnf selfca

# create CA cert
openssl req -x509 -nodes -days 3650 -newkey rsa:512 -out selfca/certs/ca.pem -keyout selfca/private/ca.key -config selfca/ssl.cnf

for name in factory frontend submitter
  do
  export dn=vagrant-${name}
  openssl req -newkey rsa:512 -nodes -keyout selfca/${name}.key -out selfca/${name}.req -config selfca/client.cnf
  openssl ca -batch -notext -in selfca/${name}.req -out selfca/${name}.pem -config selfca/ssl.cnf
  mv selfca/${name}.key clientcerts
  mv selfca/${name}.pem clientcerts
done

cp selfca/certs/ca.pem clientcerts
