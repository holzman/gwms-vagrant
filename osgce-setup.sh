#!/bin/bash

# work around openssl 1.0.1e issues
echo 'EXCLUDE="${EXCLUDE} openssl*"' >> /etc/sysconfig/yum-autoupdate

cp /vagrant/clientcerts/osgce.pem /etc/grid-security/hostcert.pem
cp /vagrant/clientcerts/osgce.key /etc/grid-security/hostkey.pem
chmod 600 /etc/grid-security/hostkey.pem
yum -y install osg-ce-condor
cp -av /vagrant/osgce.ini/* /etc/osg/config.d
mkdir -p /osg/app/etc
mkdir -p /osg/data
mkdir -p /osg/wn_tmp
chmod 1777 /osg/app /osg/data /osg/wn_tmp /osg/app/etc
useradd user01
useradd user02
echo "/CN=vagrant-pilot user01" > /etc/grid-security/grid-mapfile
echo "/CN=vagrant-user user02" >> /etc/grid-security/grid-mapfile
yum -y install osg-wn-client-glexec
cp -f /vagrant/lcmaps.db /etc/lcmaps.db
/sbin/service condor start
osg-configure -c
/sbin/service globus-gatekeeper start
/sbin/service globus-gridftp-server start
