#!/bin/bash

set -e

if [ "$(whoami)" != "root" ]; then
    echo "This script must be runned as root."
    exit 1
fi

echo "rm -rfv /opt/indeux/"
rm -rfv /opt/indeux/

echo "Succeeded to uninstall indeux."