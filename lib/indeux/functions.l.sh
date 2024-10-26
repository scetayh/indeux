#!/bin/bash

# 遍历“函数的第1个参数”这个目录及其下的所有目录
function Indeux_InterateForDirectories() {
    echo "$1"/
    for i in $(ls "$1"); do
        if [[ -d $1"/"$i ]]; then
            Indeux_InterateForDirectories "$1""/""$i"
        fi
    done
}

function Indeux_PrintBrand() {
    echo "_______________________________________________________________"
    echo "|                            indeux                             |"
    echo "|            <github.com/Tarikko-ScetayhChan/indeux>            |"
    echo "|                                                               |"
    echo "|              Copyright 2024 Tarikko-ScetayhChan               |"
    echo "|                  <weychon_lyon@outlook.com>                   |"
    echo "|                <blog.tarikko-scetayhchan.top>                 |"
    echo "|===============================================================|"
    echo "|                                                               |"
    echo "| This program is free software: you can redistribute it and/or |"
    echo "| modify it under the terms of the GNU General Public License   |"
    echo "| as published by the Free Software Foundation, either version  |"
    echo "| 3 of the License, or (at your option) any later version.      |"
    echo "|                                                               |"
    echo "| This program is distributed in the hope that it will be       |"
    echo "| useful, but WITHOUT ANY WARRANTY; without even the implied    |"
    echo "| warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR       |"
    echo "| PURPOSE. See the GNU General Public License for more details. |"
    echo "| You should have received a copy of the GNU General Public     |"
    echo "| License along with this program. If not, see                  |"
    echo "| <https://www.gnu.org/licenses/>.                              |"
    echo "|                                                               |"
    echo "|_______________________________________________________________|"
}

function Indeux_RemoveIndex() {
    echo -e "* Removing index:"
    find . -name 'index.html' -type f -print -exec rm -rf {} \;
    echo
}

function Indeux_CheckPermission() {
    if [ "$(whoami)" != "root" ]; then
        echo "indeux must be runned as root."
        exit 1
    fi
}

function Induex_DirectoryNotInited () {
    Slibsh_PrintMessage_Fafal "$0" "./.indeux/indeux.conf not found. Have you inited this directory for indeux?";
}

function Indeux_Init() {
    echo "* Copying necessary files..."
    mkdir -p ./.indeux/
    cp /usr/local/share/doc/indeux/indeux.conf.example ./.indeux/indeux.conf
    echo "* Directory inited for indeux."
}

function Indeux_List () {
    if [ ! -f "./.indeux/indeux.conf" ]; then {
        Induex_DirectoryNotInited;

        exit 1;
    }
    fi;

    ls -1 ./.indeux | grep directories- | sed 's/directories-//g' | sed 's/.txt//g' | cat -n
}

function Indeux_PrintUsage() {
    echo "Usage: indeux [ init | uninit | remove | version | gen | list ]"
}