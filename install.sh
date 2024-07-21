#!/bin/bash

set -e

if [ "$(whoami)" != "root" ]; then
    echo "This script must be runned as root."
    exit 1
fi

mkdir -pv /opt/

cp -rv . /opt/

rm -rfv /opt/indeux/install.sh
rm -rfv /opt/indeux/LICENSE
mv -v /opt/indeux/scripts/*{.sh,}

echo "chmod -w +x /opt/indeux/scripts/*"
chmod -w +x /opt/indeux/scripts/*

echo "/opt/indeux/scripts >> /etc/paths"
echo "/opt/indeux/scripts" >> /etc/paths

echo "Succeeded to install indeux."