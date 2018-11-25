#!/bin/sh
certpath=/etc/ssl/certs/ca-certificates.crt
set -e
./build-setup.sh $certpath 
if [ $? != 0 ]; then
	echo errors occurred during setup, fix and retry.
	exit 1
fi
./build-build.sh
