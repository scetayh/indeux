#!/bin/bash

set -e

# 遍历“函数的第1个参数”这个目录下的所有目录
function Indeux_InterateForDirectories() {
    echo "$1"
    for i in `ls $1`; do
        if [[ -d $1"/"$i ]]; then
            Indeux_InterateForDirectories $1"/"$i
        fi
        #echo $1"/"$i
    done
}

# 遍历“函数的第1个参数”这个目录下的所有目录和文件
function Indeux_InterateForDirectoriesAndFiles() {
    echo "$1"
    for i in `ls $1`; do
        if [[ -d $1"/"$i ]]; then
            Indeux_InterateForDirectoriesAndFiles $1"/"$i
        fi
        #echo $1"/"$i
    done
}

# 检查权限
if [ "$(whoami)" != "root" ]; then
    echo "This script must be runned as root."
    exit 1
fi

# 创建`./.indeux/'目录
mkdir -p ./.indeux/

# 删除当前目录及其所有子目录下的所有`index.htmls'文件
find . -name 'index.html' -type f -print -exec rm -rf {} \; > /dev/null

Indeux_InterateForDirectories . > ./.indeux/directories.txt
#sed -i '' '1d' ./.indeux/directories.txt # 删除第1行
sed -i '' 's/.//' ./.indeux/directories.txt # 删除每一行的前1个字符
sed -i '' 's/.//' ./.indeux/directories.txt # 删除每一行的前1个字符
#sed -i '' '/^[[:space:]]*$/d' ./.indeux/directories.txt # 删除空行

cat ./.indeux/directories.txt | wc -l
if [ "$(cat ./.indeux/directories.txt | wc -l)" -gt 0 ]; then
    for ((i=1; i<=$(cat ./.indeux/directories.txt | wc -l); i++)); do
        echo -n "Index of /" >> "$(pwd)/$(eval sed -n '${i}p' ./.indeux/directories.txt)/index.html"
        echo -n "$(eval sed -n '${i}p' ./.indeux/directories.txt)" >> "$(pwd)/$(eval sed -n '${i}p' ./.indeux/directories.txt)/index.html"
        echo "/" >> "$(pwd)/$(eval sed -n '${i}p' ./.indeux/directories.txt)/index.html"
        echo "Index of /" > index.html
        # `$(eval sed -n '${i}p' ./.indeux/directories.txt)'即为第i行的内容
        # `$(pwd)/$(eval sed -n '${i}p' ./.indeux/directories.txt)'即为第i行的内容的绝对路径
        # `$(pwd)/$(eval sed -n '${i}p' ./.indeux/directories.txt)'即为第i行的内容的绝对路径(末尾带“/”)
        #echo $(pwd)/$(eval sed -n '${i}p' ./.indeux/directories.txt)/
    done
fi