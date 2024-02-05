---
share: true
---

# Shell

## 输入输出流重定向

- `< file` 输入流重定向
- `> file` 输出流重定向
- `>> file` 追加内容

```shell
missing:~$ echo hello > hello.txt
missing:~$ cat hello.txt
hello
missing:~$ cat < hello.txt
hello
missing:~$ cat < hello.txt > hello2.txt
missing:~$ cat hello2.txt
hello
```

- **管道**（pipe） `|` 将一个程序的**输出**和另外一个程序的**输入**连接起来

```shell
missing:~$ ls -l / | tail -n1
drwxr-xr-x 1 root  root  4096 Jun 20  2019 var
missing:~$ curl --head --silent google.com | grep --ignore-case content-length | cut --delimiter=' ' -f2
219
```

## su 和 `sudo`

在某些场合内必须以 su 身份运行，如
- 向 `sysfs` 文件写入内容

例如，您笔记本电脑的屏幕亮度写在 `brightness` 文件中，它位于

```shell
/sys/class/backlight
```

通过将数值写入该文件，我们可以改变屏幕的亮度。现在，蹦到您脑袋里的第一个想法可能是：

```shell
$ sudo find -L /sys/class/backlight -maxdepth 2 -name '*brightness*'
/sys/class/backlight/thinkpad_screen/brightness
$ cd /sys/class/backlight/thinkpad_screen
$ sudo echo 3 > brightness
An error occurred while redirecting file 'brightness'
open: Permission denied
```

**报错原因：**`|`、`>`、和 `<` 是**通过 shell 执行的**，而不是被各个程序单独执行。
`echo` 等程序并不知道 `|` 的存在，它们只知道从自己的**输入输出流**中进行读写。 对于上面这种情况， **_shell_** (权限为您的当前用户) 在设置 `sudo echo` 前**尝试打开** brightness 文件并写入，但是系统拒绝了 shell 的操作因为此时 shell 不是根用户。

明白这一点后，我们可以这样操作：

```shell
$ echo 3 | sudo tee brightness
```

> [!quote] 关于 `tee`
> 
> 上文介绍了简单的使用 `tee` 提权 `echo` 的方式
> 
> `tee` 命令基于**标准输入**读取数据，**标准输出或文件**写入数据。
> 
> P.S. 这个命令的名字由来就是 `T` 字形（"tee"）的管道接头，一入二出
> 
> Eg.
> 
> ```shell
> ping google.com | tee output.txt
> ```
> 
> 此时这个输出内容不仅被写入 `output.txt` 文件，也被显示在标准输出中。
> 
> - 追加：`-a`
> - 多文件：`[command] | tee [file1] [file2] [file3]`
> - 管道支持：下面的命令不仅会将文件名存入 `output.txt` 文件中，还会通过 `wc` 命令让你知道输入到 `output.txt` 中的文件数目：`ls file* | tee output.txt | wc -l`
> - **==在 Vim 中使用 tee 提权==**：`:w !sudo tee %`
> - 忽视终端：`-i` 此时可用 `Ctrl`+`C` 优雅退出了

## 课后习题

### Quote

1. 转义字符 `\`
2. 单引号 `'` 保留其中的 literal value
3. 双引号 `"` 保留除了 ‘$’, ‘\`’, ‘\’, ’!‘（当 history expansion 启用时）

## 权限

### `ls -l` 的长表示

此时我们 WSL 中的权限为

```shell
$ ls -l
total 4
-rw-r--r-- 1 root root 61 Feb  5 16:07 semester
```

其中第一列的字符表示文件或目录的**类型和UGO权限**

$$
\underbrace{ \textcolor{Red}{\text{-}} }_{ \text{ 文件类型 } }
\underbrace{ \textcolor{Green}{\text{rw-}} }_{ \text{ U.文件属主权限 } }
\underbrace{ \textcolor{Orange}{\text{r--}} }_{ \text{ G.用户组权限 } }
\underbrace{ \textcolor{Black}{\text{r--}} }_{ \text{ O.其他用户权限 } }
$$
- 文件类型
	- - 表示普通文件
	- d 表示目录
	- l 表示符号链接
	- c 表示字符设备文件
	- b 表示块设备文件
	- s 表示套接字文件
	- p 表示管道文件
- 权限
	- `r` 读
	- `w` 写
	- `x` 执行
	- `-` 无权限

第二列的 `1` 是硬链接数

第三列的 `root` 是所有者名称

第四列的 `root` 是所属组名称

第五列的 `61` 是文件大小，以字节(1B) / Linux 数据块(512B) 为单位

第六列的是创建 / 最近一次修改时间

第七列为文件名
### `chown` 修改所属用户或用户组

```shell
chown [UserName] [File]/[Directory]
```

将 `[File]/[Directory]` 的所属用户改为 `UserName`

```shell
chown -R [UserName].[UserGroup] [File]/[Directory]
```

同上
### `chgrp` 修改所属组

```shell
chgrp [UserName] [File]/[Directory]
```

### `chmod` 修改权限

```shell
chmod [-cfvR] [--help] [--version] [Mode] [File]...
```

![[../res/rwx-standard-unix-permission-bits.png]]

- Mode 格式：`[ugoa...][[+-=][rwxX]...][,...]`
	- u 表示该文件的拥有者，g 表示与该文件的拥有者属于同一个群体(group)者，o 表示其他以外的人，a 表示这三者皆是。
	- + 表示增加权限、- 表示取消权限
	- r 表示可读取，w 表示可写入，x 表示可执行
- 参数
	- `-R` : **递归**变更

参见 [Runnoob - chmod](https://www.runoob.com/linux/linux-comm-chmod.html)

> [!example]
> 将文件 file1.txt 与 file2.txt 设为该文件的拥有者和与其所属同一个群体者可写入，但其他以外的人则不可写入
> 
> ```shell
> chmod ug+w,o-w file1.txt file2.txt
> ```

执行完后：
```sh
$ chmod +x semester
$ ls -l
total 4
-rwxr-xr-x 1 root root 61 Feb  5 16:07 semester
```

## shebang `#!`

```sh
#!interpreter [optional-arg]
```

带有 shebang 的文本文件中的其余部分会在 Unix 类系统下被 program loader 当作解释器指令

- `#!/bin/sh` – Execute the file using the [Bourne shell](https://en.wikipedia.org/wiki/Bourne_shell "Bourne shell"), or a compatible shell, assumed to be in the /bin directory
- `#!/bin/bash` – Execute the file using the [Bash shell](https://en.wikipedia.org/wiki/Bash_shell "Bash shell")
- `#!/usr/bin/pwsh` – Execute the file using [PowerShell](https://en.wikipedia.org/wiki/PowerShell "PowerShell")
- `#!/usr/bin/env python3` – Execute with a [Python](https://en.wikipedia.org/wiki/Python_(programming_language) "Python (programming language)") interpreter, using the [env](https://en.wikipedia.org/wiki/Env "Env") program search path to find it
- `#!/bin/false` – Do nothing, but return a non-zero [exit status](https://en.wikipedia.org/wiki/Exit_status "Exit status"), indicating failure. Used to prevent stand-alone execution of a script file intended for execution in a specific context, such as by the `.` command from sh/bash, `source` from csh/tcsh, or as a .profile, .cshrc, or .login file.

## 管道 `|` 输出的最后更改日期，grep

1. `stat -c %y semester` 没有用管道
2. `stat semester | grep Modify > /home/last-modified.txt`
   输出内容为：`Modify: 2024-02-05 16:07:02.751721116 +0800`

> [!quote] `grep` 简明使用方法
> 
> 默认情况下，`| grep TEXT` 会输出 输入流中含有 `TEXT` 的行
> 
> 也可以指定文件名，使用 `grep TEXT file.txt`
> 
> 常用选项：
> - `-i`：忽略大小写进行匹配。
> - `-v`：反向查找，只打印不匹配的行。
> - `-n`：显示匹配行的行号。
> - `-r`：递归查找子目录中的文件。
> - `-l`：只打印匹配的文件名。
> - `-c`：只打印匹配的行数。
> - `-E`：使用（扩展）正则表达式

## /sys

