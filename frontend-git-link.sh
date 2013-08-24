#!/bin/bash

rm -rf /usr/lib/python2.6/site-packages/glideinwms
cd /usr/lib/python2.6/site-packages
git clone http://cdcvs.fnal.gov/projects/glideinwms
cd glideinwms
git checkout v3_2_rc1

sbinfiles="glidecondor_addDN glidecondor_createSecCol glidecondor_createSecSched \
           checkFrontend glidecondor_addDN glidecondor_createSecCol \
           glidecondor_createSecSched glideinFrontendElement.py \
           reconfig_frontend stopFrontend"

binfiles="glidein_cat glidein_gdb glidein_interactive glidein_ls glidein_ps glidein_status \
          glidein_top wmsTxtView wmsXMLView"

rm -f /usr/sbin/glideinFrontend
real_loc=`find /usr/lib/python2.6/site-packages/glideinwms -type f -name glideinFrontend.py`
ln -s ${real_loc} /usr/sbin/glideinFrontend

for x in $sbinfiles
  do
    real_loc=`find /usr/lib/python2.6/site-packages/glideinwms -type f -name $x\*`
    rm -f /usr/sbin/${x}
    ln -s ${real_loc} /usr/sbin/${x}
done

for x in $binfiles
  do
    real_loc=`find /usr/lib/python2.6/site-packages/glideinwms -type f -name $x\*`
    rm -f /usr/bin/${x}
    ln -s ${real_loc} /usr/bin/${x}
done
