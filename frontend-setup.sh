#!/bin/bash

hostname vagrant-frontend
yum -y install --enablerepo=osg-upcoming-development glideinwms-vofrontend
cp /vagrant/clientcerts/frontend.pem /etc/grid-security/hostcert.pem
cp /vagrant/clientcerts/frontend.key /etc/grid-security/hostkey.pem
cp /vagrant/condor_mapfile /etc/condor/certs/condor_mapfile
chmod 600 /etc/grid-security/hostkey.pem
cp /vagrant/clientcerts/ca.pem /etc/grid-security/certificates
mv /etc/gwms-frontend/frontend.xml /etc/gwms-frontend/frontend.xml.orig
cp -f /vagrant/frontend.xml /etc/gwms-frontend/frontend.xml

# pilot cert
cp /vagrant/clientcerts/pilot.* ~frontend
chown frontend ~frontend/pilot.*
chmod 600 ~frontend/pilot.key
su frontend -s /bin/bash -c 'grid-proxy-init -valid 9999:0 -key ~frontend/pilot.key -cert ~frontend/pilot.pem -out /tmp/vo_proxy'

# user cert
cp /vagrant/clientcerts/user.* /home/vagrant
chown vagrant /home/vagrant/user.*
chmod 600 /home/vagrant/user.key
su vagrant -c 'grid-proxy-init -valid 9999:0 -key user.key -cert user.pem -out /tmp/user_proxy'

cp -a /vagrant/jobs /home/vagrant
rm -f /etc/condor/config.d/00personal_condor.config

/sbin/service condor start
/sbin/service httpd start
/sbin/service gwms-frontend reconfig
/sbin/service gwms-frontend start

