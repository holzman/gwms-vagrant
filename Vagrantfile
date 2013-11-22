# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
echo "192.168.60.2 vagrant-factory vagrant-factory.local" >> /etc/hosts
echo "192.168.60.3 vagrant-frontend vagrant-frontend.local" >> /etc/hosts
echo "192.168.60.4 vagrant-frontend-2 vagrant-frontend-2.local" >> /etc/hosts
echo "192.168.60.5 vagrant-osgce vagrant-osgce.local" >> /etc/hosts
hostname vagrant-osgce

echo "192.168.60.6 vagrant-frontend-v2 vagrant-frontend-v2.local" >> /etc/hosts

/sbin/service iptables stop
yum -y install man wget emacs-nox diffutils strace bind-utils git lsof patch libvirt policycoreutils policycoreutils-python
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

su vagrant -c 'cp /vagrant/gitignore_global /home/vagrant/.gitignore_global'
su vagrant -c 'cp /vagrant/gitconfig /home/vagrant/.gitconfig'
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
    factory.vm.provision :shell, :path => "factory-setup.sh"
    factory.vm.provision :shell, :path => "factory-git-link.sh"
  end

  config.vm.define :frontend do |frontend|
    frontend.vm.network :private_network, ip: "192.168.60.3"
    frontend.vm.provision :shell, :path => "frontend-setup.sh"
    frontend.vm.provision :shell, :path => "frontend-git-link.sh"
  end

  config.vm.define :frontend2 do |frontend2|
    frontend2.vm.network :private_network, ip: "192.168.60.4"
    frontend2.vm.provision :shell, :path => "frontend-setup.sh"
#    frontend2.vm.provision :shell, :path => "frontend-setup-2b.sh"
    frontend2.vm.provision :shell, :path => "frontend-git-link.sh"
  end

  config.vm.define :frontend_v2 do |frontend_v2|
    frontend_v2.vm.network :private_network, ip: "192.168.60.6"
    frontend_v2.vm.provision :shell, :path => "frontend-v2-setup.sh"
    frontend_v2.vm.provision :shell, :path => "frontend-v2-git-link.sh"
  end


  config.vm.define :osgce do |osgce|
    osgce.vm.network :private_network, ip: "192.168.60.5"
    osgce.vm.provision :shell, :path => "osgce-setup.sh"
  end

end
