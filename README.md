# indeux - Indeux's Not DEUX, undeux's just UN DEUX

## 简介

Indeux是一个Shell实现的资源共享静态页面索引创建工具。

Indeux为GitHub Pages等的静态页面创建各级索引，便于访问者浏览目录、下载文件。

## 原理

Indeux依靠GNU Bash和GNU Coreutils各核心工具实现。基本操作是输入输出流、字符串处理和文件操作。

`indeux`遍历所在目录下的所有子目录和文件，将其写入各级文件夹的索引`index.html`。

## 环境

- GNU/Linux发行版、WSL、macOS、Darwin、BSD或UNIX
- GNU Bash
- GNU Coreutils
- GNU Sed

必须使用GNU Sed而非BSD工具集的Sed。

macOS、Darwin、BSD或UNIX用户应当从GNU FTP服务器上下载并编译安装GNU Sed。

## 安装

克隆并进入本仓库：

```
git clone https://github.com/Tarikko-ScetayhChan/indeux.git
cd indeux
```

安装已编译的文件：

```
sudo make install
```

编译安装：

```
make strap
# 或`make clean && make && sudo make install`
```

## 使用

执行`indeux -h`命令以获取帮助：

```
usage: indeux <option>

options:
  -i    init this directory for indeux
  -u    uninit this directory for indeux
  -g    generate index
  -r    remove index
  -h    print this message
```

在用户欲建立索引的目录下执行`sudo indeux -i`命令以初始化目录。

执行`sudo indeux -g`命令生成索引。`indeux`在创建索引的同时会在`.indeux`目录下记录每次创建的索引。

创建完成后，更新页面即可。[示例页面戳此](https://commons.tarikkochan.top)。

欲删除索引，执行`sudo indeux -r`命令。

欲删除记录，执行`sudo indeux -u`命令。