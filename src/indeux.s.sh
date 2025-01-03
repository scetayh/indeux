#!/bin/bash

function indeux.printUsage () {
    printf "indeux v${INDEUX_SYSTEM_VERSION}"\\n;
    printf "Copyright (C) 2024 幸草_Tarikko-ScetayhChan"\\n;
    printf \\n;
    cat /usr/local/share/doc/indeux/usage.txt;
}

function indeux.checkPermission () {
    [ "$(whoami)" != "root" ] && \
        printf "$0: permission denied"\\n && \
            exit 125;
}

function indeux.throwExceptionInvalidOption () {
    printf "$0: invalid option \`-$OPTARG'. Operate \`indeux -h' for help"\\n && \
        exit 2;
}

function indeux.initDirectory () {
    if mkdir .indeux &> /dev/null; then {
        printf "created directory \`.indeux'"\\n;
        if [ -d /usr/local/share/doc/indeux ]; then {
            if cp -r /usr/local/share/doc/indeux/* .indeux &> /dev/null; then {
                printf "copied necessary files"\\n;
                printf "succeeded to initialize this directory for indeux"\\n;
            }
            else {
                printf "$0: failed to copy necessary files"\\n;
                exit 1;
            }
            fi;
        }
        else {
            printf "$0: cannot find directory \`/usr/local/share/doc/indeux'"\\n;
            exit 1;
        }
        fi;
    }
    else {
        printf "$0: failed to create directory \`.indeux'"\\n;
        exit 1;
    }
    fi;
}

function indeux.uninitDirectory () {
    if rm -rf .indeux &> /dev/null; then {
        printf "removed directory \`.indeux'"\\n;
        printf "succeeded to uninitialize this directory for indeux"\\n;
    }
    else {
        printf "failed to remove directory \`.indeux'\\n"
        exit 1;
    }
    fi;
}

function indeux.checkInited () {
    [ ! -d ".indeux" ] && \
        printf "$0: this directory hasn't been initialized for indeux yet"\\n && \
            exit 1;
}

function indeux.checkUninited () {
    [ -d ".indeux" ] && \
        printf "$0: this directory has already been initialized for indeux"\\n && \
            exit 1;
}

function indeux.removeIndex () {
    printf "removing indexes:"\\n;
    printf \\n;
    find -name 'index.html' -type f -print -exec rm -rf {} \;
    find -name 'index.md' -type f -print -exec rm -rf {} \;
    find -name '.indeux.items.txt' -type f -exec rm -rf {} \;
}

function indeux.openConfig () {
    indeux.checkInited;
    printf "Opening configuration file of this directory..."\\n;
    if ! vim ./indeux/local.conf; then {
        printf "$0: cannot find file \`indeux/local.conf'"\\n && \
            exit 1;
    }
    fi;
}

# function Indeux.interateForDirectory() {
#     echo "$1/";

#     for i in $(ls "$1"); do {
#         [[ -d "$1/$i" ]] && eval Indeux.interateForDirectory \'$1/$i\';
#     }
#     done;
# }

function indeux.genIndex () {
    if source .indeux/local.conf; then {
        if [ -d .indeux/theme/${INDEUX_LOCAL_THEME} ]; then {

            # interate for directories
            find . -type d -not -path "*/.*" > .indeux/directories.txt;
            sed -i "s/$/&\//g" .indeux/directories.txt;

            # print found directories and the number
            printf "$(wc -l < .indeux/directories.txt) directories found in total:"\\n;
            printf \\n;
            cat .indeux/directories.txt;
            cp .indeux/directories.txt .indeux/directories-"$(date +%Y%m%dT%H%M%SZ)".txt;
            printf \\n;

            # write items in each directory
            for ((i = 1; i <= $(wc -l <.indeux/directories.txt); i++)); do {
                ls -1F "$(pwd)"/"$(eval sed -n '${i}p' .indeux/directories.txt)" >"$(eval sed -n '${i}p' .indeux/directories.txt)/.indeux.items.txt";
                sed -i 's/\*//' "$(eval sed -n '${i}p' .indeux/directories.txt)/.indeux.items.txt"; # remove asterisks
            }
            done;
            
            # create index
            printf "creating indexes:"\\n;
            printf \\n;

            if [ "$(wc -l <.indeux/directories.txt)" -gt 0 ]; then {
                bash .indeux/theme/${INDEUX_LOCAL_THEME}/main.sh;
            }
            fi;

            printf \\n;
            printf "succeeded in creating indexes"\\n;
        }
        else {
            printf "$0: cannot find theme \`${INDEUX_LOCAL_THEME}'"\\n;
            exit 1;
        }
        fi;
    }
    else {
        printf "$0: cannot find file \`.indeux/local.conf'"\\n;
        exit 1;
    }
    fi;
}

source /etc/indeux.system.conf;

while getopts "ghilru" OPT; do {
    case "$OPT" in
        g)
            indeux.checkInited;
            indeux.checkPermission;
            indeux.removeIndex;
            printf \\n;
            indeux.genIndex;
            exit 0;
            ;;
        h)
            indeux.printUsage;
            exit 0;
            ;;
        i)
            indeux.checkUninited;
            indeux.checkPermission;
            indeux.initDirectory;
            exit 0;
            ;;
        r)
            indeux.checkInited;
            indeux.checkPermission;
            indeux.removeIndex;
            exit 0;
            ;;
        c)
            indeux.openConfig;
            exit 0;
            ;;
        u)
            indeux.checkInited;
            indeux.uninitDirectory;
            exit 0;
            ;;
        *)
            indeux.printUsage;
            exit 1;
            ;;
        ?)
            indeux.throwExceptionInvalidOption;
            exit 1;
            ;;
    esac;
}
done;
