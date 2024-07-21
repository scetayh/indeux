#!/bin/bash

set -e

if [ "$(whoami)" != "root" ]; then
    echo "This script must be runned as root."
    exit 1
fi

echo -e "* Removing index:\n"
#find . -name 'index.txt' -type f -print -exec rm -rf {} \;
find . -name 'index.html' -type f -print -exec rm -rf {} \;