#!/bin/bash

glidein_config="$1"

# find error reporting helper script
error_gen=`grep '^ERROR_GEN_PATH ' $glidein_config | awk '{print $2}'`

echo "Crypto library found"
"$error_gen" -ok  "libtest.sh" "file" "/usr/lib/libcrypto.so.0.9.8"
exit 0