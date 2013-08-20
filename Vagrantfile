# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
echo "192.168.60.2 vagrant-factory vagrant-factory.local" >> /etc/hosts
echo "192.168.60.3 vagrant-frontend vagrant-frontend.local" >> /etc/hosts
echo "192.168.60.4 vagrant-osgce vagrant-osgce.local" >> /etc/hosts
hostname vagrant-osgce

/sbin/service iptables stop
yum -y install man wget emacs-nox diffutils strace
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
yum -y install yum-priorities
rpm -Uvh http://repo.grid.iu.edu/osg-el6-release-latest.rpm
yum -y install osg-ca-certs
cd /etc/yum.repos.d &&  wget http://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel6.repo
yum -y install condor.x86_64
#
cp /vagrant/clientcerts/ca.pem /etc/grid-security/certificates
cp /vagrant/clientcerts/ca.signing_policy /etc/grid-security/certificates
hash=`openssl x509 -in /etc/grid-security/certificates/ca.pem -noout -hash`
ln -s /etc/grid-security/certificates/ca.pem /etc/grid-security/certificates/${hash}.0
ln -s /etc/grid-security/certificates/ca.signing_policy /etc/grid-security/certificates/${hash}.signing_policy
SCRIPT

$factory_script = <<SCRIPT
yum -y install --enablerepo=osg-upcoming-development glideinwms-factory
cp /vagrant/clientcerts/factory.pem /etc/grid-security/hostcert.pem
cp /vagrant/clientcerts/factory.key /etc/grid-security/hostkey.pem
chmod 600 /etc/grid-security/hostkey.pem
cp -f /vagrant/factory-glideinWMS.xml /etc/gwms-factory/glideinWMS.xml
cp /vagrant/condor_mapfile /etc/condor/certs/condor_mapfile
#
hostname vagrant-factory
#
rm -f /etc/condor/config.d/00personal_condor.config
/sbin/service condor start
/sbin/service gwms-factory reconfig
/sbin/service gwms-factory start
SCRIPT

$frontend_script = <<SCRIPT
yum -y install --enablerepo=osg-upcoming-development glideinwms-vofrontend
cp /vagrant/clientcerts/frontend.pem /etc/grid-security/hostcert.pem
cp /vagrant/clientcerts/frontend.key /etc/grid-security/hostkey.pem
cp /vagrant/condor_mapfile /etc/condor/certs/condor_mapfile
chmod 600 /etc/grid-security/hostkey.pem
cp /vagrant/clientcerts/ca.pem /etc/grid-security/certificates
chmod 755 /home/vagrant
cp /vagrant/clientcerts/pilot.* /home/vagrant
chown vagrant:vagrant /home/vagrant/pilot.*
chmod 600 /home/vagrant/pilot.key
su vagrant -c 'grid-proxy-init -key pilot.key -cert pilot.pem -out /tmp/vo_proxy'
chown frontend /tmp/vo_proxy
cp -f /vagrant/frontend.xml /etc/gwms-frontend/frontend.xml
#
hostname vagrant-frontend

rm -f /etc/condor/config.d/00personal_condor.config
#
/sbin/service condor start
/sbin/service gwms-frontend reconfig
/sbin/service gwms-frontend start
SCRIPT

$osgce_script = <<SCRIPT
cp /vagrant/clientcerts/osgce.pem /etc/grid-security/hostcert.pem
cp /vagrant/clientcerts/osgce.key /etc/grid-security/hostkey.pem
chmod 600 /etc/grid-security/hostkey.pem
yum -y install osg-ce-condor
cp -av /vagrant/osgce.ini/* /etc/osg/config.d
mkdir -p /osg/app/etc
mkdir -p /osg/data
mkdir -p /osg/wn_client
chmod 1777 /osg/app /osg/data /osg/wn_client /osg/app/etc
osg-configure -c
useradd user01
echo "/CN=vagrant-pilot user01" > /etc/grid-security/grid-mapfile
/sbin/service condor start
/sbin/service globus-gatekeeper start
/sbin/service globus-gridftp-server start
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "sl6-64-lyte"
  config.vm.box_url = "http://lyte.id.au/vagrant/sl6-64-lyte.box"
  config.vm.provision :shell, :inline => $script
  config.vm.provider :virtualbox do |vb|
     vb.customize ["modifyvm", :id, "--cpus", "1"]
  end

  config.vm.define :factory do |factory|
    factory.vm.network :private_network, ip: "192.168.60.2"
    factory.vm.provision :shell, :inline => $factory_script
  end

  config.vm.define :frontend do |frontend|
    frontend.vm.network :private_network, ip: "192.168.60.3"
    frontend.vm.provision :shell, :inline => $frontend_script
  end

  config.vm.define :osgce do |osgce|
    osgce.vm.network :private_network, ip: "192.168.60.4"
    osgce.vm.provision :shell, :inline => $osgce_script
  end

end
