#!/bin/bash

yum -y install --enablerepo=osg-upcoming-development glideinwms-factory
cp /vagrant/clientcerts/factory.pem /etc/grid-security/hostcert.pem
cp /vagrant/clientcerts/factory.key /etc/grid-security/hostkey.pem
chmod 600 /etc/grid-security/hostkey.pem
cp -f /vagrant/factory-glideinWMS.xml /etc/gwms-factory/glideinWMS.xml
cp /vagrant/condor_mapfile /etc/condor/certs/condor_mapfile

hostname vagrant-factory

rm -f /etc/condor/config.d/00personal_condor.config

/sbin/service condor start
/sbin/service httpd start
/sbin/service gwms-factory upgrade
/sbin/service gwms-factory start