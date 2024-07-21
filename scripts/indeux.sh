#!/bin/bash

set -e

# 遍历“函数的第1个参数”这个目录下的所有目录
function Indeux_InterateForDirectories() {
    echo "$1"/
    for i in $(ls "$1"); do
        if [[ -d $1"/"$i ]]; then
            Indeux_InterateForDirectories "$1""/""$i"
        fi
        #echo $1"/"$i
    done
}

if [ "$(whoami)" != "root" ]; then
    echo "This script must be runned as root."
    exit 1
fi

mkdir -p ./.indeux/

echo -e "* Removing index:"
#find . -name '.index.txt' -type f -print -exec rm -rf {} \;
find . -name 'index.html' -type f -print -exec rm -rf {} \;
echo

Indeux_InterateForDirectories . > ./.indeux/directories.txt
echo -e "* Looking for directories:"
cp ./.indeux/directories.txt "./.indeux/directories-$(date +%Y%m%dT%H%M%SZ).txt"
cat ./.indeux/directories.txt
sed -i '' 's/..//' ./.indeux/directories.txt # 删除每一行的前1个字符
echo -e "* $(wc -l < ./.indeux/directories.txt) directories in total.\n"

echo "* Creating index:"
if [ "$(wc -l < ./.indeux/directories.txt )" -gt 0 ]; then
    for ((i=1; i<=$(wc -l < ./.indeux/directories.txt); i++)); do
        echo "./$(eval sed -n '${i}p' ./.indeux/directories.txt)index.html"
        # `$(eval sed -n '${i}p' ./.indeux/directories.txt)'即为第i行的内容
        # `./$(eval sed -n '${i}p' ./.indeux/directories.txt)'即为第i行的内容的绝对路径
        # `ls ./$(eval sed -n '${i}p' ./.indeux/directories.txt)'即为第i行这个目录下的内容

        # 写入根目录.txt索引的标题
        #{
        #    echo "Index of /"
        #    echo
        #} > .index.txt
        #ls -1F >> .index.txt

        # 写入各子目录.txt索引的标题
        #{
        #    echo -n "Index of /"
        #    eval sed -n '${i}p' ./.indeux/directories.txt
        #    echo
        #} > "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.index.txt"
        #ls -1F "$(pwd)"/"$(eval sed -n '${i}p' ./.indeux/directories.txt)" >> "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.index.txt"
        #sed -i '' 's/\*//' "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.index.txt" # 去除星号

        # 写入各子目录.html索引
        {
            echo "<html>"
            echo "    <head>"
            echo "        <title>Index of /$(eval sed -n ${i}p ./.indeux/directories.txt)</title>"
            echo "    </head>"
            echo "    <body>"
            echo "        <h1>Index of /$(eval sed -n ${i}p ./.indeux/directories.txt)</h1>"
            echo "        <hr>"
            echo "        <pre>"
            echo "<a href=\"../\">../</a>"
        } >> "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/index.html"
        ls -1F "$(pwd)"/"$(eval sed -n '${i}p' ./.indeux/directories.txt)" > "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt"
        sed -i '' 's/\*//' "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt" # 去除星号
        if [ $(wc -l < "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt" ) -gt 0 ]; then
            for ((j=1; j<=$(wc -l < "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt"); j++)); do # 创建每一行项目
                {
                    echo -n "<a href=\""
                    echo -n $(eval sed -n '${j}p' "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt")
                    echo -n "\">"
                    echo -n $(eval sed -n '${j}p' "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt")
                    echo "</a>"
                } >> "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/index.html"
            done
        fi
        rm -f "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/.items.txt"
        {
            echo "        </pre>"
            echo "        <hr>"
            echo "    </body>"
            echo "</html>"
        } >> "./$(eval sed -n '${i}p' ./.indeux/directories.txt)/index.html"
    done
fi

find . -name '.items.txt' -type f -print -exec rm -rf {} \;