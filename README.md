# indeux - Indeux's Not DEUX, undeux's just UN DEUX

## 简介

`indeux`是一个纯Shell实现的资源共享静态页面索引创建工具。它可以帮助你为GitHub Pages等的静态页面创建各级索引（类似于各大镜像站），以达到文件查看和下载的目的。

## 原理

`indeux`依靠Shell脚本和`coreutils`各核心工具来实现，基本操作是输入输出流、字符串处理和文件操作。

`indeux`遍历所在目录下的所有子目录和文件，并用Shell变量相关来实现，最后添加至各级文件夹的索引`index.html`。

使用`indeux`，你需要有类UNIX操作系统环境（GNU/Linux、Darwin、macOS、BSD、UNIX、WSL、WSL2）、类`coreutils`或`busybox`核心实用工具和一个shell（如`bash`和`zsh`）。

## 安装

克隆并进入本仓库：

```
git clone https://github.com/Tarikko-ScetayhChan/indeux.git
cd ./indeux/
```

编译安装：

```
make && sudo make install
```

## 使用

执行`sudo indeux help`以获取帮助：

```
Usage: indeux [ init | remove | version | gen ]
```

直接在你想要建立索引的目录下执行`sudo indeux init && sudo index gen`命令。`indeux`在创建索引的同时会在`./.indeux/`目录下记录每次创建的索引。

创建完成后，更新页面即可。在GitHub Pages中，你只需要执行`git commit -a && git push`。[示例页面戳此](https://commons.tarikko-scetayhchan.top)。

如果想要删除索引，执行`sudo indeux remove`命令。

如果想要删除记录，执行`sudo rm -rf ./.indeux/`命令。

## 问题

不能按文件类型（目录、文件）排序。~~我太懒了~~

## 许可证

本程序自豪地采用GNU通用公共许可证第3版（GPLv3.0）。

```
 _______________________________________________________________
|                            indeux                             |
|            <github.com/Tarikko-ScetayhChan/indeux>            |
|                                                               |
|              Copyright 2024 Tarikko-ScetayhChan               |
|                  <weychon_lyon@outlook.com>                   |
|                <blog.tarikko-scetayhchan.top>                 |
|===============================================================|
|                                                               |
| This program is free software: you can redistribute it and/or |
| modify it under the terms of the GNU General Public License   |
| as published by the Free Software Foundation, either version  |
| 3 of the License, or (at your option) any later version.      |
|                                                               |
| This program is distributed in the hope that it will be       |
| useful, but WITHOUT ANY WARRANTY; without even the implied    |
| warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR       |
| PURPOSE. See the GNU General Public License for more details. |
| You should have received a copy of the GNU General Public     |
| License along with this program. If not, see                  |
| <https://www.gnu.org/licenses/>.                              |
|                                                               |
|_______________________________________________________________|
```