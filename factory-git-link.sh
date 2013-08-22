#!/bin/bash 

rm -rf /usr/lib/python2.6/site-packages/glideinwms
cd /usr/lib/python2.6/site-packages
git clone http://cdcvs.fnal.gov/projects/glideinwms
cd glideinwms
git checkout v3_2_rc1

binfiles="analyze_entries analyze_frontends analyze_queues cat_MasterLog cat_StartdLog \
          cat_StarterLog cat_XMLResult cat_logs configGUI convert_factory_2to3.sh \
          convert_factory_2to3.xslt convert_factory_rrds_2to3.sh create_condor_tarball \
          entry_ls entry_q entry_rm extract_EC2_Address find_StartdLogs find_ids_not_published \
          find_logs find_matching_ids find_missing_ids find_new_entries find_partial_matching_ids \
          glidein_cat glidein_gdb glidein_interactive glidein_ls glidein_ps glidein_status glidein_top \
          infosys_lib manual_glidein_submit proxy_info wmsTxtView wmsXMLView"

sbinfiles="checkFactory.py glideFactory.py glideFactoryEntry.py glideFactoryEntryGroup.py \
           glidecondor_addDN glidecondor_createSecCol glidecondor_createSecSched info_glidein \
           manageFactoryDowntimes.py reconfig_glidein stopFactory.py"

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
