#!/bin/sh
certpath=$1
help="build-setup <certificate-path>"
if [ ! -f $certpath ]; then
	echo no certs found at certpath: $certpath, correct and retry.
	echo "$help"
	exit 2
fi

## grab nuget dependencies
set -e
##/usr/local/bin/mozroots --import --sync --ask-remove
## replaces mozroot
## /usr/local/bin/cert-sync
cert-sync $certpath
serr=$?
if [ -f /home/tc/bin/vererr ]; then
	/home/tc/bin/vererr $? cert-install-failed
else
	if [ $serr != 0 ]; then
		echo cert sync failed
		exit 1
	fi
fi
if [ ! -f nuget.exe ]; then
  nugeturl=https://dist.nuget.org/win-x86-commandline/v4.7.0/nuget.exe
  wget $nugeturl
else
  echo nuget.exe was present.
fi
