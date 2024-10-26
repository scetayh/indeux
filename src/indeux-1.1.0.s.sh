#!/bin/bash

#.soras 0

#.include {
source ../lib/indeux/functions.l.sh;
source /usr/local/lib/slibsh/printmessage.h.sh;
#.}

if [ "$1" = "init" ]; then {
    Indeux_CheckPermission;

    if [ ! -d "./.indeux" ]; then {
        Indeux_Init;

        exit 0;
    }
    else {
        Slibsh_PrintMessage_Fafal "$0" "This directory is already inited for indeux. If necessary, operate \`sudo rm -rf ./.indeux/'.";

        exit 1;
    }
    fi;
}
elif [ "$1" = "version" ]; then {
    Indeux_PrintBrand;

    exit 0;
}
elif [ "$1" = "remove" ]; then {
    Indeux_CheckPermission;

    Indeux_RemoveIndex;

    exit 0;
}
elif [ "$1" = "gen" ]; then {
    Indeux_CheckPermission;

    if [ ! -f "./.indeux/indeux.conf" ]; then {
        Induex_DirectoryNotInited;

        exit 1;
    }
    fi;

    source ./.indeux/indeux.conf;

    Indeux_RemoveIndex;

    Indeux_InterateForDirectories . > ./.indeux/directories.txt
    echo -e "* Looking for directories:";
    cp ./.indeux/directories.txt "./.indeux/directories-$(date +%Y%m%dT%H%M%SZ).txt";
    cat ./.indeux/directories.txt;
    sed -i 's/..//' ./.indeux/directories.txt; # 删除每一行的前1个字符
    echo -e "* $(wc -l <./.indeux/directories.txt) directories in total.\n";

    echo "* Creating index:";
    if [ "$(wc -l <./.indeux/directories.txt)" -gt 0 ]; then {
        for ((i = 1; i <= $(wc -l <./.indeux/directories.txt); i++)); do {
            echo "./$(eval sed -n '${i}p' ./.indeux/directories.txt)index.html";
            # 写入各子目录.html索引
            {
                echo "<html lang=\"${indeux_htmlLang}\">"
                echo "    <head>"
                echo "        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"
                echo "<link rel=\"apple-touch-icon\" sizes=\"180x180\" href=\"${indeux_appleTouchIcon}\">"
                echo "<link rel=\"icon\" type=\"image/ico\" sizes=\"32x32\" href=\"${indeux_icon}\">"
                echo "        <title>${indeux_titlePrefix}$(eval sed -n ${i}p ./.indeux/directories.txt)</title>"
                echo "    </head>"
                echo "    <body style=\"background-color: ${indeux_backgroundColor}\">"
                #echo "    <link rel=\"stylesheet\" href=\"//fonts.googleapis.com/css?family=Mulish:300,300italic,400,400italic,700,700italic%7CFredericka%20the%20Great:300,300italic,400,400italic,700,700italic%7CNoto%20Serif%20JP:300,300italic,400,400italic,700,700italic%7CNoto%20Serif%20SC:300,300italic,400,400italic,700,700italic%7CInconsolata:300,300italic,400,400italic,700,700italic&amp;display=swap&amp;subset=latin,latin-ext\">"
                echo "        <style type=\"text/css\">"
                echo "        body{"
                echo "            background: url("${indeux_background}") no-repeat center center fixed;"
                echo "            -webkit-background-size: cover;"
                echo "            -o-background-size: cover;  "
                echo "            background-size: cover;"
                echo "        }"
                echo "        </style>"
                echo "        <h1><font color="#af7ac5">☆</font> Index of /$(eval sed -n ${i}p ./.indeux/directories.txt)</h1>"
                echo "        <HR style=\"FILTER: alpha(opacity=100,finishopacity=0,style=1)\" width="100%" color=#987cb9 SIZE=3>"
                echo "        <pre>"
                echo "<a href=\"../\">../</a>"
            } >> "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/index.html";

            ls -1F "$(pwd)"/"$(eval sed -n '${i}p' ./.indeux/directories.txt)" >"./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt";

            sed -i 's/\*//' "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt"; # 去除星号

            if [ $(wc -l <"./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt") -gt 0 ]; then {
                for ((j = 1; j <= $(wc -l <"./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt"); j++)); do {
                    {
                        echo -n "<a href=\""
                        echo -n $(eval sed -n '${j}p' "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt")
                        echo -n "\">"
                        echo -n $(eval sed -n '${j}p' "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt")
                        echo "</a>"
                    } >> "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/index.html";
                }
                done;
            }
            fi;
            
            rm -f "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt"

            {
                echo "        </pre>"
                echo "    </body>"
                echo "</html>"
            } >> "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/index.html";
        } & \
        done
    }
    fi;
}
elif [ "$1" = "uninit" ]; then {
    rm -rf ./.indeux;
    echo "* Succeeded to uninitalize this directory.";
}
elif [ "$1" = "uninit" ]; then {
    Indeux_List;
}
else {
    Indeux_PrintUsage;

    exit 1;
}
fi;