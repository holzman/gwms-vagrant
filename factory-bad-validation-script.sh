#!/bin/bash

glidein_config="$1"

# find error reporting helper script
error_gen=`grep '^ERROR_GEN_PATH ' $glidein_config | awk '{print $2}'`

if [ ! -f "/usr/lib/libLibraryWeReallyWant.3.0" ]; then
  "$error_gen" -error "libtest.sh" "WN_Resource" "Crypto library not found." "file" "/usr/lib/libLibraryWeReallyWant.3.0"
  exit 1
fi
echo "Crypto library found"
"$error_gen" -ok  "libtest.sh" "file" "/usr/lib/libcrypto.so.0.9.8"
exit 0