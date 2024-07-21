#!/bin/bash

set -e

source ./functions

Indeux_CheckPermission

mkdir -pv /opt/indeux/

cp -rv ./* /opt/indeux/

mv -v /opt/indeux/indeux{.sh,}

echo "chmod -w /opt/indeux/indeux"
chmod -w /opt/indeux/indeux
echo "chmod +x /opt/indeux/sindeux"
chmod +x /opt/indeux/indeux

echo "echo /opt/indeux/ >> /etc/paths"
echo /opt/indeux/ >> /etc/paths
echo "source /etc/paths"
source /etc/paths

echo "Succeeded to install indeux."