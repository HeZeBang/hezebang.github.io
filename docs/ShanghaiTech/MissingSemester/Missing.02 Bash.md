---
share: true
---

# Bash

> [!question] Shell? sh? bash?
> 
> - **Shell**是通用术语，泛指命令行解释器，而 **bash** 和 **sh** 是具体的Shell实现。
> 	- 在Unix和Linux系统中，常见的Shell包括Bourne Shell（sh）、Bourne-Again Shell（bash）、C Shell（csh）、Korn Shell（ksh）等。
> - **sh是最基本的Shell**，是Unix系统的原始Shell，兼容性较好，但功能相对有限。
> 	- **sh是Unix原始的标准Shell解释器**，也被称为Bourne Shell，最早由史蒂芬·伯恩斯（Stephen Bourne）开发。
> 	- 在许多Unix系统中，`/bin/sh`通常是Bourne Shell或其兼容的链接。
> 	- 在一些Linux发行版中，`/bin/sh`可能是指向bash的符号链接，因此在这些系统中，`sh`与`bash`之间的差异可能不那么明显。
> - **bash是对sh的扩展**，提供了更多功能和便利的特性，是许多Linux系统的默认Shell。
> 	- **bash是Bourne-Again Shell**的缩写，是GNU项目的一部分，在许多现代Unix和Linux系统中默认的Shell。
> 	- bash是对Bourne Shell的增强和扩展版本，提供了更多功能，例如命令补全、多行命令编辑、作业控制等。
> 	- 在许多脚本中，`#!/bin/bash`用于指定脚本应该由bash解释器来执行。（参见[[Missing.01 Shell#shebang ` !`|shebang]]）
> 
> 在现代系统中，一般将`/bin/sh`符号链接到bash，因此可以在脚本中使用`#!/bin/sh`或`#!/bin/bash`来执行脚本，两者通常是等效的。

## Shell 脚本

shell 脚本针对 shell 所从事的相关工作进行来优化。因此，创建命令流程（pipelines）、将结果保存到文件、从标准输入中读取输入，这些都是 shell 脚本中的原生操作，这让它比通用的脚本语言更易用。

### 赋值与访问变量

- **赋值**
	- ==`foo = bar` 不能工作！==解释器会调用程序`foo` 并将 `=` 和 `bar`作为参数
	- 正确写法：`foo=bar`
- **访问**
	- `$foo`

### 字符串
- 字符串通过`'` 和 `"`分隔符来定义
	- `'` 原义字符串，变量不会被转义
	- `"` 会将变量值进行替换

```sh
foo=bar
echo "$foo"
# 打印 bar
echo '$foo'
# 打印 $foo
```

### 条件、循环

bash 支持 `if`, `else`, `while`, `for` 等

```sh
#!/bin/bash

# if...then...else...fi 语法示例
read -p "Enter a number: " num
if [[ $num -gt 0 ]]; then
    echo "The number is positive."
else
    echo "The number is not positive."
fi

# while...do...done 循环语法示例
counter=1
while [[ $counter -le 5 ]]; do
    echo "Iteration: $counter"
    ((counter++))
done

# for..do...done 循环语法示例
for fruit in apple banana orange; do
    echo "I like $fruit"
done
```

> [!quote] 一些注解
> 
> 在Bash脚本中，双圆括号 `((...))` 是用来执行算术运算的。在Shell中，通常使用 `((...))` 来进行整数运算和表达式求值，而不需要使用 `$` 符号获取变量的值。
> 
> 在 `((counter++))` 中，`counter++` 是一个自增操作，`((...))` 让Shell知道需要执行的是一个数学运算，而不是简单的字符串操作或命令替换。这样做可以确保 `counter` 变量按预期递增。
> 
> ---
> 
> 在Bash脚本中，条件判断通常使用方括号 `[ ]` 或 `[[ ]]` 来包裹条件表达式。在这个上下文中，`-gt` 是一个用于数值比较的运算符，表示“greater than”（大于）。因此， `[ $num -gt 0 ]` 表示当 `num` 的值大于0时条件成立。
> 
> Bash中没有提供 `>` 运算符用于比较大小，因此不能直接写成 `$num > 0`。
> 
> 类似的有：`-eq`, `-neq`, `-lt`, `-le`, `-gt`, `-ge`
> 
> Bash实现了许多类似的比较操作，您可以查看 [`test 手册`](https://man7.org/linux/man-pages/man1/test.1.html)。
> 
> 在bash中进行比较时，==尽量使用双方括号 `[[ ]]` 而不是单方括号 `[ ]`==，这样会降低犯错的几率，尽管这样**并不能兼容 `sh`**。 更详细的说明参见[这里](http://mywiki.wooledge.org/BashFAQ/031)。

### 函数

下面这个函数是一个例子，它会创建一个文件夹并使用`cd`进入该文件夹。

```sh
mcd () {
    mkdir -p "$1"
    cd "$1"
}
```

这里 `$1` 是脚本的第一个参数。

### 特殊的参数

- `$0` - 脚本名
- `$1` 到 `$9` - 脚本的参数。 `$1` 是第一个参数，依此类推。
- `$@` - 所有参数
- `$#` - 参数个数
- `$?` - 前一个命令的返回值（AKA 退出码 / 返回码）
- `$$` - 当前脚本的进程识别码
- `!!` - 完整的上一条命令，包括参数。==常见应用：当你因为权限不足执行命令失败时，可以使用 `sudo !!`再尝试一次。==
- `$_` - 上一条命令的最后一个参数。如果你正在使用的是交互式 shell，你可以通过按下 `Esc` 之后键入 . 来获取这个值。

更完整的列表可以参考 [这里](https://www.tldp.org/LDP/abs/html/special-chars.html)。

### 返回

命令通常使用 `STDOUT`来返回输出值，使用`STDERR` 来返回错误及错误码。
返回码或退出状态是脚本/命令之间交流执行状态的方式。
返回值 0 表示正常执行，其他所有非0的返回值都表示有错误发生。

退出码可以搭配 `&&`（与操作符）和 `||`（或操作符）使用，用来进行条件判断，决定是否执行其他程序。
它们都属于**短路[运算符](https://en.wikipedia.org/wiki/Short-circuit_evaluation)**（short-circuiting） 同一行的多个命令可以用 `;` 分隔。

```sh
false || echo "Oops, fail" # 未短路
# Oops, fail

true || echo "Will not be printed" # 短路
#

true && echo "Things went well" # 未短路
# Things went well

false && echo "Will not be printed" # 短路
#

false ; echo "This will always run"
# This will always run
```

| 返回码 | 含义 |
| ---- | ---- |
| 0 | 操作成功完成 |
| 1 | 一般性错误 |
| 2 | 参数错误，通常指无效或不正确的输入参数 |
| 126 | 不能执行 |
| 127 | 命令未找到 |
| 128 | exit 参数错误，exit 只能用整数作为参数 |
| 128 + n | 信号 n 的致命错误<br>如 kill -9 脚本的 PID，则返回137（128+9） |
| 130 | `Ctrl` + `C` 结束脚本（信号 2） |
| 255 | 程序退出状态，通常表示异常终止或错误退出 |
| -1 | 通用错误码，有时表示未指定的错误或未知错误 |

**程序 `true` 的返回码永远是`0` （代表正常完成），`false` 的返回码永远是`1`。**

```sh
$ false
$ echo $?
1
$ true
$ echo $?
0
```

### 命令替换 / 进程替换

以变量的形式获取一个命令的输出

**命令替换**（_command substitution_）

通过 `$( CMD )` 这样的方式来执行`CMD` 这个命令时，它的输出结果会替换掉 `$( CMD )` 。

例如，如果执行 `for file in $(ls)` ，shell首先将调用`ls` ，然后遍历通过 `ls` 得到的这些返回值。

**进程替换**（_process substitution_）

`<( CMD )` 会执行 `CMD` 并将结果输出到一个**临时文件**中，并将 `<( CMD )` 替换成临时**文件名**，这在我们希望返回值通过文件而不是STDIN传递时很有用

例如，由于 `diff` 接受文件形式的比较，我们可以使用 `diff <(ls foo) <(ls bar)` 会显示文件夹 `foo` 和 `bar` 中文件的区别。

```sh
#!/bin/bash

echo "Starting program at $(date)" # date会被替换成日期和时间

echo "Running program $0 with $# arguments with pid $$"

for file in "$@"; do
    grep foobar "$file" > /dev/null 2> /dev/null
    # 如果模式没有找到，则grep退出状态为 1
    # 我们将标准输出流和标准错误流重定向到Null，因为我们并不关心这些信息
    if [[ $? -ne 0 ]]; then
        echo "File $file does not have any foobar, adding one"
        echo "# foobar" >> "$file"
    fi
done
```

### 通配

当执行脚本时，我们经常需要提供形式类似的参数。bash使我们可以轻松的实现这一操作，它可以基于文件扩展名展开表达式。这一技术被称为shell的 _通配_（_globbing_）

- 通配符 - 当你想要利用通配符进行匹配时，你可以分别使用 `?` 和 `*` 来匹配一个或任意个字符。
	- `?` 匹配 1 次任意字符
	- `*` 匹配多次任意字符
	- 例如，对于文件`foo`, `foo1`, `foo2`, `foo10` 和 `bar`, `rm foo?`这条命令会删除`foo1` 和 `foo2` ，而`rm foo*` 则会删除除了`bar`之外的所有文件。
- 花括号`{}` - 当你有一系列的指令，其中包含一段**公共子串**时，可以用花括号来自动展开这些命令。这在批量移动或转换文件时非常方便。
	- `{a,c}` 表示 `a`, `c`
	- `{a..c}` 表示 `a`, `b`, `c` （按照数字、字母顺序）

> [!warning] 混用的`{?..?}`
> 
> 如果数字和字母混用，不会进行任何操作，返回的仍然是 `{?..?}`

```bash
convert image.{png,jpg}
# 会展开为
convert image.png image.jpg
# 学到了！！！非常方便！！！

cp /path/to/project/{foo,bar,baz}.sh /newpath
# 会展开为
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# 也可以结合通配使用
mv *{.py,.sh} folder
# 会移动所有 *.py 和 *.sh 文件

mkdir foo bar

# 下面命令会创建foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h这些文件
touch {foo,bar}/{a..h}
touch foo/x bar/y
# 比较文件夹 foo 和 bar 中包含文件的不同
diff <(ls foo) <(ls bar)
# 输出
# < x
# ---
# > y
```

编写 `bash` 脚本有时候会很别扭和反直觉。例如 [shellcheck](https://github.com/koalaman/shellcheck) 这样的工具可以帮助你定位sh/bash脚本中的错误。

> 这里的 shebang 部分请参见 [[Missing.01 Shell#shebang ` !`]]

shell函数和脚本有如下一些不同点：

- 函数只能与shell使用相同的语言，脚本可以使用任意语言。因此在脚本中包含 `shebang` 是很重要的。
- 函数仅在定义时被加载，脚本会在每次被执行时加载。这让函数的加载比脚本略快一些，但每次修改函数定义，都要重新加载一次。
- 函数会在当前的shell环境中执行，脚本会在单独的进程中执行。因此，函数可以对环境变量进行更改，比如改变当前工作目录，脚本则不行。脚本需要使用 [`export`](https://man7.org/linux/man-pages/man1/export.1p.html) 将环境变量导出，并将值传递给环境变量。
- 与其他程序语言一样，函数可以提高代码模块性、代码复用性并创建清晰性的结构。shell脚本中往往也会包含它们自己的函数定义。

## Shell 工具

### 查看帮助

- 命令行添加`-h` 或 `--help` 标记
- `man`
- `tldr` / [tldr Pages](https://tldr.sh/)
- 某些交互式窗口：`:help` 命令或键入 `?` / `h`
- ~~StackOverflow~~
- ~~ChatGPT~~

#### `man`

```bash
man [command]
```

#### `tldr`

```sh
npm install -g tldr # 笔者在 Ubuntu 直接 apt install tldr
tldr [command]
```
### 查找文件

#### `find`

```bash
$ find [dir] -[options] [args]
```

常见选项
- `-name` 名称为（可用通配符）
- `-path` 路径（完整路径） <br>Eg. `*/test/*.py`
- `-mtime` 修改时间 <br>Eg. `find /path/to/directory -mtime -7  # 查找最近7天内被修改过的文件`
- `-atime` 访问时间 <br>Eg. `find /path/to/directory -atime +30  # 查找超过30天未被访问过的文件`
- `-exec` 查找后操作 <br> Eg. `find . -name '*.tmp' -exec rm {} \; # 删除全部扩展名为.tmp 的文件` <br> `find . -name '*.png' -exec convert {} {}.jpg \; # 查找全部的 PNG 文件并将其转换为 JPG`

尽管 `find` 用途广泛，它的语法却比较难以记忆。例如，为了查找满足包含 `PATTERN` 的文件，您需要执行 `find -name '*PATTERN*'` (如果您希望模式匹配时是不区分大小写，可以使用`-iname`选项）

#### `fd`

```
fd [keyword]
```

- 更简单、更快速、更友好
- 很多不错的默认设置，例如输出着色、默认支持正则匹配、支持unicode
- 语法符合直觉

#### `locate`

```
locate [keyword]
```

- 通过建立数据库的方式来实现更加快速地搜索
- 在大多数系统中 `updatedb` 都会通过 [`cron`](https://man7.org/linux/man-pages/man8/cron.8.html) 每日更新
- **只能通过文件名**
- 基于数据库的搜索工具，可能**无法实时**反映文件系统中的最新更改

手动更新数据库

```bash
sudo updatedb
```

### 查找代码

#### `grep`

见 [[Missing.01 Shell#管道 ` ` 输出的最后更改日期，grep]]

#### `rg` (ripgrep)

```bash
# 查找所有使用了 requests 库的文件
rg -t py 'import requests'
# 查找所有没有写 shebang 的文件（包含隐藏文件）
rg -u --files-without-match "^#!"
# 查找所有的foo字符串，并打印其之后的5行
rg foo -A 5
# 打印匹配的统计信息（匹配的行和文件的数量）
rg --stats PATTERN
```

### 查找 shell 命令

#### `history`

`history` 会输出一系列 序号+命令的列表，可以配合 `gerp`

#### `Ctrl` + `R`

可以输入历史子串匹配

#### `Ctrl` + `R` with `fzf`

`fzf` 是一个通用对模糊查找工具

#### 使用 `zsh`

另外一个和历史命令相关的技巧我喜欢称之为**基于历史的自动补全**。 这一特性最初是由 [fish](https://fishshell.com/) shell 创建的，它可以根据您最近使用过的开头相同的命令，动态地对当前对shell命令进行补全。这一功能在 [zsh](https://github.com/zsh-users/zsh-autosuggestions) 中也可以使用，它可以极大的提高用户体验。

你可以修改 shell history 的行为，例如，如果在命令的开头加上一个空格，它就不会被加进shell记录中。当你输入包含密码或是其他敏感信息的命令时会用到这一特性。 为此你需要在`.bashrc`中添加`HISTCONTROL=ignorespace`或者向`.zshrc` 添加 `setopt HIST_IGNORE_SPACE`。 如果你不小心忘了在前面加空格，可以通过编辑。`bash_history`或 `.zhistory` 来手动地从历史记录中移除那一项。

### 文件夹导航

- alias
- `ln -s` “快捷方式”
- `fasd`
- `autojump`

#### `fasd` / `autojump`

Fasd 基于 [_frecency_](https://developer.mozilla.org/en-US/docs/Mozilla/Tech/Places/Frecency_algorithm) 对文件和文件排序，也就是说它会同时针对频率（_frequency_）和时效（_recency_）进行排序。默认情况下，`fasd`使用命令 `z` 帮助我们快速切换到最常访问的目录。例如， 如果您经常访问`/home/user/files/cool_project` 目录，那么可以直接使用 `z cool` 跳转到该目录。对于 autojump，则使用`j cool`代替即可。

## 课后练习

### `man ls`

- **-a**, **--all** do not ignore entries starting with .
- **-h**, **--human-readable** with **-l** and **-s**, print sizes like 1K 234M 2G etc.
- **-c**     with **-lt**: sort by, and show, ctime (time of last change of file status information); with **-l**: show ctime and sort by name; **otherwise**: sort by ctime, newest first
- **--color**\[=\_WHEN\_\]color the output WHEN; more info below

### 编写 bash 函数

**macro.sh**

```bash
#!/bin/bash
echo $(pwd) > /tmp/pwd.tmp
```

**polo.sh**

```bash
#!/bin/bash
cd $(cat /tmp/pwd.tmp)
```

> 你可以把代码写在单独的文件 `marco.sh` 中，并通过 `source marco.sh`命令，（重新）加载函数。

### 编写 bash 脚本

编写一段bash脚本，运行如下的脚本直到它出错，将它的标准输出和标准错误流记录到文件，并在最后输出所有内容。 加分项：报告脚本在失败前共运行了多少次。

```bash
#!/usr/bin/env bash

n=$(( RANDOM % 100 ))

if [[ n -eq 42 ]]; then
echo "Something went wrong"
>&2 echo "The error was using magic numbers"
exit 1
fi

echo "Everything went according to plan"
```

> [!quote] 重定向与赋值
> 
> **重定向**
> 
> - `command > output.txt`：将命令的标准输出流重定向到文件 `output.txt`。
> - `command 2> error.txt`：将命令的标准错误流重定向到文件 `error.txt`。
> - `command > output.txt 2>&1`：将标准输出流和标准错误流均重定向到文件 `output.txt`。
>   
> **赋值**
> 
> ```bash
> output_var=$(command)
> error_var=$(command 2>&1 >/dev/null)
> ```
> 
> 在这个示例中，`2>&1` 将标准错误输出流重定向到标准输出流，并且 `>/dev/null` 将标准输出流重定向到 `/dev/null`，这样标准输出就不会被捕获，只有标准错误被赋值给错误变量。

### `xarg` - 使用标准输入中的内容作为参数

例如，`ls | xargs rm` 会删除当前目录中的所有文件。

- -d, --delimiter=CHARACTER items in input stream are separated by CHARACTER, not by **whitespace**; disables quote and backslash processing and logical EOF processing

**I.** `-print 0` 使用空字符分割+`-0` 识别空字符

```bash
find . -type f -name "*.html" -print0 | xargs -0 zip output.zip
```

**II.** `-d '\n'`