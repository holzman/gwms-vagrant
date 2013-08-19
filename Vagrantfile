# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
yum -y install man wget emacs-nox
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
yum -y install yum-priorities
rpm -Uvh http://repo.grid.iu.edu/osg-el6-release-latest.rpm
yum -y install osg-ca-certs
cd /etc/yum.repos.d &&  wget http://research.cs.wisc.edu/htcondor/yum/repo.d/htcondor-stable-rhel6.repo
yum -y install condor.x86_64
rm -f /etc/condor/config.d/00personal_condor.config 
SCRIPT

$factory_script = <<SCRIPT
yum -y install --enablerepo=osg-upcoming-development glideinwms-factory
cp /vagrant/clientcerts/factory.* /etc/grid-security
cp /vagrant/clientcerts/ca.pem /etc/grid-security/certificates
cp -f /vagrant/factory-glideinWMS.xml /etc/gwms-factory/glideinWMS.xml
/sbin/service condor start
/sbin/service gwms-factory reconfig
/sbin/service gwms-factory start
SCRIPT

$frontend_script = <<SCRIPT
yum -y install --enablerepo=osg-upcoming-development glideinwms-vofrontend
cp /vagrant/clientcerts/frontend.* /etc/grid-security
cp /vagrant/clientcerts/ca.pem /etc/grid-security/certificates
chmod 755 /home/vagrant
cp /vagrant/clientcerts/pilot.* /home/vagrant
chown vagrant:vagrant /home/vagrant/pilot.*
chmod 600 /home/vagrant/pilot.key
su vagrant -c 'grid-proxy-init -key pilot.key -cert pilot.pem -out vo_proxy'
cp -f /vagrant/frontend.xml /etc/gwms-frontend/frontend.xml
/sbin/service condor start
/sbin/service gwms-frontend reconfig
/sbin/service gwms-frontend start
SCRIPT

$usercondor_script = <<SCRIPT
cp /vagrant/clientcerts/factory.* /etc/grid-security
cp /vagrant/clientcerts/ca.pem /etc/grid-security/certificates
/sbin/service condor start
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

  config.vm.define :usercondor do |usercondor|
    usercondor.vm.network :private_network, ip: "192.168.60.4"
    usercondor.vm.provision :shell, :inline => $usercondor_script
  end

end
