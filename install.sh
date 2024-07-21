#!/bin/bash

set -e

if [ "$(whoami)" != "root" ]; then
    echo "This script must be runned as root."
    exit 1
fi

mkdir -pv /opt/indeux/

cp -rv ./* /opt/indeux/

rm -rfv /opt/indeux/install.sh
rm -rfv /opt/indeux/LICENSE
mv -v /opt/indeux/scripts/indeux{.sh,}
mv -v /opt/indeux/scripts/undeux{.sh,}

echo "chmod -w /opt/indeux/scripts/*"
chmod -w /opt/indeux/scripts/*
echo "chmod +x /opt/indeux/scripts/*"
chmod +x /opt/indeux/scripts/*

echo "echo /opt/indeux/scripts >> /etc/paths"
echo /opt/indeux/scripts >> /etc/paths
echo "source /etc/paths"
source /etc/paths

echo "Succeeded to install indeux."