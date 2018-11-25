#!/bin/sh

## prepare to build
set -e
pkg=lean
tdir=$(pwd)
## grab nuget
if [ ! -f nuget.exe ]; then
  echo nuget.exe download failed
  exit 1
fi
## sync nuget packages
sln=QuantConnect.Lean.sln 
SSL_CERT_DIR=/usr/local/etc/ssl/certs mono ./nuget.exe restore $sln
nerr=$?
if [ -f /home/tc/bin/vererr ]; then
	/home/tc/bin/vererr $nerr nuget-restore-$pkg
else
	if [ $nerr != 0 ]; then
		echo "errors restoring nuget depends."
		exit $nerr
	fi
fi
## attempt patch for .net 4.0
if [ ! -f net4patch ]; then
   ##git apply < /home/tc/bin/.patches/lean-2401-conway.patch
   ##touch net4patch
  sleep 0
fi

## attempt build on .net 4.0
XBUILD_FRAMEWORK_FOLDERS_PATH=".NETFramework,Version=v4.0" xbuild $sln /p:Configuration=Release /p:DebugType=Full /tv:4.0
berr=$?
if [ -f /home/tc/bin/vererr ]; then
	/home/tc/bin/vererr $berr lean-compile
else
	exit $berr
fi
