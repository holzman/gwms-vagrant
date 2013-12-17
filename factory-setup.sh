#!/bin/bash

# work around openssl 1.0.1e issues
echo 'EXCLUDE="${EXCLUDE} openssl*"' >> /etc/sysconfig/yum-autoupdate

yum -y install --enablerepo=osg-upcoming-development glideinwms-factory
cp /vagrant/clientcerts/factory.pem /etc/grid-security/hostcert.pem
cp /vagrant/clientcerts/factory.key /etc/grid-security/hostkey.pem
chmod 600 /etc/grid-security/hostkey.pem
cp -f /vagrant/factory-glideinWMS.xml /etc/gwms-factory/glideinWMS.xml
cp /vagrant/condor_mapfile /etc/condor/certs/condor_mapfile

hostname vagrant-factory

rm -f /etc/condor/config.d/00personal_condor.config

useradd -M -c "VO Frontend User 2" -d /var/lib/gwms-factory -s /sbin/nologin frontend-2
sed -i 's/valid-target-uids = frontend/valid-target-uids = frontend : frontend-2/' /etc/condor/privsep_config
sed -i 's/valid-target-gids = frontend/valid-target-gids = frontend : frontend-2/' /etc/condor/privsep_config

/sbin/service condor start
/sbin/service httpd start
/sbin/service gwms-factory upgrade
/sbin/service gwms-factory start