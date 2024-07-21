#!/bin/bash

set -e

source ./functions

Indeux_CheckPermission

echo "rm -rfv /opt/indeux/"
rm -rfv /opt/indeux/

sed -i '' 's/\/opt\/indeux//g' /etc/paths

echo "Succeeded to uninstall indeux."