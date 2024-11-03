#!/bin/bash

function indeux.printUsage () {
    printf "indeux v${INDEUX_VERSION}"\\n;
    printf "Copyright (C) 2024 Tarikko-ScetayhChan"\\n;
    printf \\n;
    printf "usage: indeux <option>"\\n;
    printf \\n;
    printf "options:"\\n;
    printf "  -i    init this directory for indeux"\\n;
    printf "  -u    uninit this directory for indeux"\\n;
    printf "  -g    generate index"\\n;
    printf "  -r    remove index"\\n;
    printf "  -h    print this message"\\n;
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
        if [ -f /usr/local/share/doc/indeux/index.conf ]; then {
            if cp /usr/local/share/doc/indeux/index.conf .indeux &> /dev/null; then {
                printf "copied file \`index.conf'"\\n;
                printf "succeeded to initialize this directory for indeux"\\n;
            }
            else {
                printf "$0: failed to copy file \`index.conf'"\\n;
                exit 1;
            }
            fi;
        }
        else {
            printf "$0: cannot find file \`/usr/local/share/doc/indeux/index.conf'"\\n;
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
    printf "removing index:"\\n;
    printf \\n;
    find . -name 'index.html' -type f -print -exec rm -rf {} \;
}

function indeux.genIndex () {
    # define function Indeux.interateForDirectory
    function Indeux.interateForDirectory() {
        echo "$1/";

        for i in $(ls "$1"); do {
            [[ -d $1"/"$i ]] && Indeux.interateForDirectory "$1""/""$i";
        }
        done;
    }

    # interate for directories
    Indeux.interateForDirectory . > .indeux/directories.txt;

    # print found directories and the number
    printf "$(wc -l < .indeux/directories.txt) directories found in total:"\\n;
    printf \\n;
    cat .indeux/directories.txt;
    sed -i 's/..//' .indeux/directories.txt; # remove the first character of each line
    cp .indeux/directories.txt .indeux/directories-$(date +%Y%m%dT%H%M%SZ).txt;
    printf \\n;

    # create index
    printf "creating index:"\\n;
    printf \\n;

    if [ "$(wc -l <.indeux/directories.txt)" -gt 0 ]; then {
        for ((i = 1; i <= $(wc -l <.indeux/directories.txt); i++)); do {
            printf "./$(eval sed -n '${i}p' .indeux/directories.txt)index.html"\\n;
            # write index
            {
                echo "<html lang=\"${indeux_htmlLang}\">";
                echo "    <head>";
                echo "        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">";
                echo "<link rel=\"apple-touch-icon\" sizes=\"180x180\" href=\"${indeux_appleTouchIcon}\">";
                echo "<link rel=\"icon\" type=\"image/ico\" sizes=\"32x32\" href=\"${indeux_icon}\">";
                echo "        <title>${indeux_titlePrefix}$(eval sed -n ${i}p .indeux/directories.txt)</title>";
                echo "    </head>";
                echo "    <body style=\"background-color: ${indeux_backgroundColor}\">";
                #echo "    <link rel=\"stylesheet\" href=\"//fonts.googleapis.com/css?family=Mulish:300,300italic,400,400italic,700,700italic%7CFredericka%20the%20Great:300,300italic,400,400italic,700,700italic%7CNoto%20Serif%20JP:300,300italic,400,400italic,700,700italic%7CNoto%20Serif%20SC:300,300italic,400,400italic,700,700italic%7CInconsolata:300,300italic,400,400italic,700,700italic&amp;display=swap&amp;subset=latin,latin-ext\">";
                echo "        <style type=\"text/css\">";
                echo "        body{";
                echo "            background: url("${indeux_background}") no-repeat center center fixed;";
                echo "            -webkit-background-size: cover;";
                echo "            -o-background-size: cover;  ";
                echo "            background-size: cover;";
                echo "        }";
                echo "        </style>";
                echo "        <h1><font color="#af7ac5">☆</font> Index of /$(eval sed -n ${i}p .indeux/directories.txt)</h1>";
                echo "        <HR style=\"FILTER: alpha(opacity=100,finishopacity=0,style=1)\" width="100%" color=#987cb9 SIZE=3>";
                echo "        <pre>";
                echo "<a href=\"../\">../</a>";
            } >> "./$(eval sed -n '${i}p' .indeux/directories.txt)/index.html";

            ls -1F "$(pwd)"/"$(eval sed -n '${i}p' .indeux/directories.txt)" >"./$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt";

            sed -i 's/\*//' "./$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt"; # remove asterisks

            if [ $(wc -l <"./$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt") -gt 0 ]; then {
                for ((j = 1; j <= $(wc -l <"./$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt"); j++)); do {
                    {
                        echo -n "<a href=\"";
                        echo -n $(eval sed -n '${j}p' "./$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt");
                        echo -n "\">";
                        echo -n $(eval sed -n '${j}p' "./$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt");
                        echo "</a>";
                    } >> "./$(eval sed -n '${i}p' .indeux/directories.txt)/index.html";
                }
                done;
            }
            fi;
            
            rm -f "./$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt";

            {
                echo "        </pre>";
                echo "    </body>";
                echo "</html>";
            } >> "./$(eval sed -n '${i}p' .indeux/directories.txt)/index.html";
        } & \
        done;
    }
    fi;
}

source /etc/indeux.conf;

while getopts "ghilru" OPT; do {
    case "$OPT" in
        g)
            indeux.checkInited;
            source /etc/indeux.conf;
            indeux.checkPermission;
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