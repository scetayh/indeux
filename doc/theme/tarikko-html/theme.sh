#!/bin/bash

source .indeux/theme/tarikko-html/theme.conf

for ((i = 1; i <= $(wc -l <.indeux/directories.txt); i++)); do {
    #printf "$(eval sed -n '${i}p' .indeux/directories.txt)index.html"\\n;
    # write index
    {
        echo "<html lang=\"${indeux_htmlLang}\">";
        echo "    <head>";
        echo "        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">";
        echo "<link rel=\"apple-touch-icon\" sizes=\"180x180\" href=\"${indeux_appleTouchIcon}\">";
        echo "<link rel=\"icon\" type=\"image/ico\" sizes=\"32x32\" href=\"${indeux_icon}\">";
        echo "        <title>${indeux_titlePrefix}$(declare currentDirectory=$(sed -n ${i}p .indeux/directories.txt); echo ${currentDirectory:1})</title>";
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
        echo "        <h1><font color="#af7ac5">☆</font> Index of $(declare currentDirectory=$(sed -n ${i}p .indeux/directories.txt); echo ${currentDirectory:1})</h1>";
        echo "        <HR style=\"FILTER: alpha(opacity=100,finishopacity=0,style=1)\" width="100%" color=#987cb9 SIZE=3>";
        echo "        <pre>";
        echo "<a href=\"../\">../</a>";
    } >> "$(eval sed -n '${i}p' .indeux/directories.txt)/index.html";

    ls -1F "$(pwd)"/"$(eval sed -n '${i}p' .indeux/directories.txt)" >"$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt";

    sed -i 's/\*//' "$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt"; # remove asterisks

    if [ $(wc -l <"$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt") -gt 0 ]; then {
        for ((j = 1; j <= $(wc -l <"$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt"); j++)); do {
            {
                echo -n "<a href=\"";
                echo -n $(eval sed -n '${j}p' "$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt");
                echo -n "\">";
                echo -n $(eval sed -n '${j}p' "$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt");
                echo "</a>";
            } >> "$(eval sed -n '${i}p' .indeux/directories.txt)/index.html";
        }
        done;
    }
    fi;
    
    rm -f "$(eval sed -n '${i}p' .indeux/directories.txt)/.items.txt";

    {
        echo "        </pre>";
        echo "    </body>";
        echo "</html>";
    } >> "$(eval sed -n '${i}p' .indeux/directories.txt)/index.html";

    printf "$(eval sed -n '${i}p' .indeux/directories.txt)index.html"\\n;

    # export j=$((j + 1));
    # echo j=$j;

    # wc -l <.indeux/directories.txt;
    # if [ $j -ge $(wc -l <.indeux/directories.txt) ]; then {
    #     mkdir -p ~/.indeux_cache;
    #     echo INDEUX_GENERATION_STATUS=yes > ~/.indeux_cache/status;
    # }
    # fi;
} # & \
done;