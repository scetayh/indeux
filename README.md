# indeux - Indeux's Not DEUX, undeux's just UN DEUX

## 简介

`indeux`是一个纯Shell实现的资源共享静态页面索引创建工具。它可以帮助你为GitHub Pages等的静态页面创建各级索引（类似于各大镜像站），以达到文件查看和下载的目的。

## 原理

`indeux`依靠Shell脚本和`coreutils`各核心工具来实现，基本操作是输入输出流、字符串处理和文件操作。

`indeux`遍历所在目录下的所有子目录和文件，并用Shell变量相关来实现，最后添加至各级文件夹的索引`index.html`。

使用`indeux`，你需要有类UNIX操作系统环境（GNU/Linux、Darwin、macOS、BSD、UNIX、WSL、WSL2）、类`coreutils`或`busybox`核心实用工具(**必须使用GNU Sed，不允许使用Darwin和macOS的sed，否则可能会引发出乎意料的结果**)和一个shell（如`bash`和`zsh`）。

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
make clean && make && sudo make install
```

## 使用

执行`indeux -h`以获取帮助：

```
usage: indeux <option>

options:
  -i    init this directory for indeux
  -u    uninit this directory for indeux
  -g    generate index
  -r    remove index
  -h    print this message
```

直接在你想要建立索引的目录下执行`sudo indeux -i && sudo index -g`命令。`indeux`在创建索引的同时会在`.indeux`目录下记录每次创建的索引。

创建完成后，更新页面即可。在GitHub Pages中，你只需要执行`git add . && git commit -a && git push --set-upstream origin main`。[示例页面戳此](https://commons.tarikkochan.top)。

如果想要删除索引，执行`sudo indeux -r`命令。

如果想要删除记录，执行`sudo indeux -u`命令。

## 问题

不能按文件类型（目录、文件）排序。~~我太懒了~~