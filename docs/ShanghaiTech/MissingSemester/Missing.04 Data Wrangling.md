---
share: true
---

# 数据整理

## Intro

现在，让我们研究一下系统日志，看看哪些用户曾经尝试过登录我们的服务器：

```bash
ssh myserver journalctl
```

内容太多了。现在让我们把涉及 sshd 的信息过滤出来：

```bash
ssh myserver journalctl | grep sshd
```

注意，这里我们使用管道将一个远程服务器上的文件**传递给本机的 `grep` 程序**！此时我们打印出的内容，仍然比我们需要的要多得多，读起来也非常费劲。我们来改进一下：

```bash
ssh myserver 'journalctl | grep sshd | grep "Disconnected from"' | less
```

- 先在远端机器上过滤文本内容，然后再将结果传输到本机。
- `less` 为我们创建来一个文件分页器，使我们可以通过翻页的方式浏览较长的文本。为了进一步节省流量，我们甚至可以将当前过滤出的日志保存到文件中，这样后续就不需要再次通过网络访问该文件了
- 单引号：告诉 SSH 将整个字符串作为一个单独命令传送给服务器，而不会在本地进行解释或处理。

1. 通过SSH连接到远程服务器 `myserver`，并将单引号包裹的 command string 一并发给服务器运行：
	1. 在远程服务器上运行 `journalctl` 命令，显示系统日志。
	2. 使用 `grep sshd` 过滤出含有 `sshd` 关键词的日志条目。
	3. 在上一步的结果中继续使用 `grep "Disconnected from"` 过滤出含有 "Disconnected from" 的日志条目。
2. 最后将经过筛选的日志内容通过管道 `|` 传递给 `less` 命令，以便进行分页查看。

为了进一步节省流量，我们甚至可以将当前过滤出的日志保存到文件中，这样后续就不需要再次通过网络访问该文件了：

```bash
$ ssh myserver 'journalctl | grep sshd | grep "Disconnected from"' > ssh.log
$ less ssh.log
```

### `sed`

`sed` 是一个基于文本编辑器`ed`构建的”流编辑器” 。在 `sed` 中，您基本上是利用一些简短的命令来修改文件，而不是直接操作文件的内容（尽管您也可以选择这样做）。相关的命令行非常多，但是最常用的是 `s`，即 *替换* 命令，例如我们可以这样写：

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed 's/.*Disconnected from //'
```

`s/.*Disconnected from //` 为正则表达式

#### `sed` 替换、正则表达式

正则表达式替换语法：

`s/REGEX/SUBSTITUTION/`

常见正则表达式语法：

- `.` 除换行符之外的”任意单个字符”
- `*` 匹配前面字符零次或多次
- `+` 匹配前面字符一次或多次
- `[abc]` 匹配 `a`, `b` 和 `c` 中的任意一个
- `(RX1|RX2)` 任何能够匹配`RX1` 或 `RX2`的结果
- `^` 行首
- `$` 行尾

`sed` 的正则表达式有些时候是比较奇怪的，它需要你在这些模式前添加`\`才能使其具有特殊含义。或者，您也可以添加`-E`选项来支持这些匹配。

回过头我们再看`/.*Disconnected from /`，我们会发现这个正则表达式可以匹配任何以若干任意字符开头，并接着包含”Disconnected from “的字符串。这也正式我们所希望的。但是请注意，正则表达式并不容易写对。如果有人将 “Disconnected from” 作为自己的用户名会怎样呢？

```
Jan 17 03:13:00 thesquareplanet.com sshd[2631]: Disconnected from invalid user Disconnected from 46.97.239.16 port 55920 [preauth]
```

正则表达式会如何匹配？`*` 和 `+` 在默认情况下是**贪婪模式**，也就是说，它们会尽可能多的匹配文本。因此对上述字符串的匹配结果如下：

```
46.97.239.16 port 55920 [preauth]
```

您可以给 `*` 或 `+` 增加一个`?` 后缀使其变成**非贪婪模式**，但是很可惜 `sed` **并不支持该后缀**。不过，我们可以切换到 **perl 的命令行模式**，该模式支持编写这样的正则表达式：

```bash
perl -pe 's/.*?Disconnected from //'
```

> [!quote]- `perl` 简介
> 
> Perl 是 Practical Extraction and Report Language 的缩写，可翻译为 "实用报表提取语言"。
> 
> Perl 是高级、通用、直译式、动态的程序语言。
> 
> Perl 最重要的特性是Perl内部集成了正则表达式的功能，以及巨大的第三方代码库CPAN。
> 
> Perl的正则表达式的三种形式，分别是匹配，替换和转化:
> 
> - 匹配：m//（还可以简写为//，略去m）
>     
> - 替换：s/
>     
> - 转化：tr/
>     
> 
> 这三种形式一般都和 **=~** 或 **!~** 搭配使用， =~ 表示相匹配，!~ 表示不匹配。

想要匹配用户名后面的文本，尤其是当这里的用户名可以包含空格时，这个问题变得非常棘手！这里我们需要做的是匹配*一整行*：

```bash
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user .* [^ ]+ port [0-9]+( \[preauth\])?$//'
```

让我们借助正则表达式在线调试工具[regex debugger](https://regex101.com/r/qqbZqh/2) 来理解这段表达式。

OK，开始的部分和以前是一样的，随后，我们匹配两种类型的“user”（在日志中基于两种前缀区分）。再然后我们匹配属于用户名的所有字符。接着，再匹配任意一个单词（`[^ ]+` 会匹配任意非空且不包含空格的序列）。紧接着后面匹配单“port”和它后面的一串数字，以及可能存在的后缀`[preauth]`，最后再匹配行尾。

注意，这样做的话，即使用户名是“Disconnected from”，对匹配结果也不会有任何影响，您知道这是为什么吗？

问题还没有完全解决，日志的内容全部被替换成了空字符串，整个日志的内容因此都被删除了。我们实际上希望能够将用户名_保留_下来。对此，我们可以使用“**捕获组**（capture groups）”来完成。被圆括号内的正则表达式匹配到的文本，都会被存入一系列以编号区分的捕获组中。捕获组的内容可以在替换字符串时使用（有些正则表达式的引擎甚至支持**替换表达式本身**），例如`\1`、 `\2`、`\3`等等，因此可以使用如下命令：

```bash
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
```

想必您已经意识到了，为了完成某种匹配，我们最终可能会写出非常复杂的正则表达式。例如，这里有一篇关于如何匹配电子邮箱地址的文章[e-mail address](https://www.regular-expressions.info/email.html)，匹配电子邮箱可一点[也不简单](https://emailregex.com/)。网络上还有很多关于如何匹配电子邮箱地址的[讨论](https://stackoverflow.com/questions/201323/how-to-validate-an-email-address-using-a-regular-expression/1917982)。人们还为其编写了[测试用例](https://fightingforalostcause.net/content/misc/2006/compare-email-regex.php)及 [测试矩阵](https://mathiasbynens.be/demo/url-regex)。您甚至可以编写一个用于判断一个数[是否为质数](https://www.noulakaz.net/2007/03/18/a-regular-expression-to-check-for-prime-numbers/)的正则表达式。

正则表达式是==出了名的难以写对==，但是它仍然会是您强大的常备工具之一。

### 过滤、排序

OK，现在我们有如下表达式：

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
```

`sed` 还可以做很多各种各样有趣的事情，例如文本注入：(使用 `i` 命令)，打印特定的行 (使用 `p`命令)，基于索引选择特定行等等。详情请见 `man sed`!

现在，我们已经得到了一个包含用户名的列表，列表中的用户都曾经尝试过登录我们的系统。但这还不够，让我们**过滤出那些最常出现的用户**：

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
```

`sort` 会对其输入数据进行**排序**。`uniq -c` 会**把连续出现的行折叠为一行并使用出现次数作为前缀**。我们希望按照出现次数排序，过滤出最常出现的用户名：

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
```

模拟输出：

```bash
3 user1
3 user2
2 user3
```

- `sort`中
	- `-n` 会按照数字顺序（***n***umeric）对输入进行排序（默认情况下是按照字典序排序）
	- `-k1,1` 则表示“**仅基于(以空格分割的)第一列进行排序**”。
		- `,n` 部分表示“**仅排序到第n个部分**”，默认情况是到*行尾*。就本例来说，针对整个行进行排序也没有任何问题，我们这里主要是为了学习这一用法！
		- 如果想要实现第一列相同、比较第二列，可以使用 `-k1,2`，以此类推
- `tail`中
	- `-n10` 即最后10行

如果我们希望得到登录次数最少的用户，我们可以使用 `head` 来代替`tail`。或者使用`sort -r`来进行倒序排序。

相当不错。但我们只想获取用户名，而且不要一行一个地显示。

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
 | awk '{print $2}' | paste -sd,
```

模拟输出：

```bash
user2,user1,user3
```

如果您使用的是 MacOS：注意这个命令并不能配合 MacOS 系统默认的 BSD `paste`使用。参考[课程概览与 shell](https://missing-semester-cn.github.io/2020/course-shell/)的习题内容获取更多相关信息。

我们可以利用 `paste`命令来合并行(`-s`)，并指定一个分隔符进行分割 (`-d`，这里分隔符为`,`)，那`awk`的作用又是什么呢？

### awk – 另外一种编辑器

`awk` 其实是一种编程语言，只不过它碰巧非常善于处理文本。关于 `awk` 可以介绍的内容太多了，限于篇幅，这里我们仅介绍一些基础知识。

首先， `{print $2}` 的作用是什么？ `awk` 程序接受一个模式串（可选），以及一个代码块，指定当模式匹配时应该做何种操作。默认当模式串即匹配所有行（上面命令中当用法）。 在代码块中，`$0` 表示整行的内容，`$1` 到 `$n` 为一行中的 n 个区域，区域的分割基于 `awk` 的域分隔符（默认是空格，可以通过`-F`来修改）。在这个例子中，我们的代码意思是：对于每一行文本，打印其第二个部分（就是第二列），也就是用户名。

让我们康康，还有什么炫酷的操作可以做。让我们统计一下所有以`c` 开头，以 `e` 结尾，并且仅尝试过一次登录的用户。

```bash
 | awk '$1 == 1 && $2 ~ /^c[^ ]*e$/ { print $2 }' | wc -l
```

让我们好好分析一下。首先，注意这次我们为 `awk`指定了一个匹配模式串（也就是`{...}`前面的那部分内容）。`$1 == 1` 要求文本的第一部分需要等于1（这部分刚好是`uniq -c`得到的计数值），然后 `$2 ~ /^c[^ ]*e$/` 要求其第二部分必须满足给定的一个正则表达式。代码块中的内容则表示打印用户名。然后我们使用 `wc -l` 统计输出结果的行数。

关于该正则：

- `^c`: 字符串的开头匹配字母 "c"。
- `[^ ]*`: 匹配零个或多个**非**空格字符。（`^` 在方括号内表示“非”的含义）
- `e`: 匹配字母 "e"。
- `$`: 匹配字符串的结尾。

不过，既然 `awk` 是一种编程语言，那么则可以这样：

```awk
BEGIN { rows = 0 }
$1 == 1 && $2 ~ /^c[^ ]*e$/ { rows += $1 }
END { print rows }
```

`BEGIN` 也是一种模式，它会匹配输入的开头（ `END` 则匹配结尾）。然后，对每一行第一个部分进行累加，最后将结果输出。事实上，我们完全可以抛弃 `grep` 和 `sed` ，因为 `awk` 就可以[解决所有问题](https://backreference.org/2010/02/10/idiomatic-awk)。至于怎么做，就留给读者们做课后练习吧。

### 分析数据

#### `bc`

想做数学计算也是可以的！例如这样，您可以将每行的数字加起来：

```bash
 | paste -sd+ | bc -l
```

- `paste -sd+` 用来输出一个加法字符串表达式
    - `paste` 命令用于将多个文件的内容按行粘贴在一起。
    - `-s` 选项表示将每个输入文件以列的形式拼接到一起，而不是按行。
    - `-d+` 选项表示在拼接时使用"+"作为分隔符，即将所有输入连接起来，并使用"+"分隔每个输入。
    - 因此，`paste -sd+` 将所有的输入内容连接在一起，使用"+"作为分隔符连接它们。
- `bc -l` 用于进行计算
	- `-l` 选项告诉 `bc` 使用标准数学库。这样，它可以处理浮点数（小数）。

下面这种更加复杂的表达式也可以：

```bash
echo "2*($(data | paste -sd+))" | bc -l
```

- `$(data | paste -sd+)` 是一个[命令替换](./Missing.02%20Bash.md)，其中执行了 `data` 命令获取数据，并使用 `paste -sd+` 命令将数据以加号连接起来。整体上，这将计算出一系列数的总和。

#### R 语言

您可以通过多种方式获取统计数据。如果已经安装了R语言，[`st`](https://github.com/nferraz/st)是个不错的选择：

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | awk '{print $1}' | R --slave -e 'x <- scan(file="stdin", quiet=TRUE); summary(x)'
```

- `R` 调用了 R 解释器
	- `--slave` 批处理模式，执行完毕后退出
	- `-e '...'` 指定脚本
	- `x <- ...` 将 `...` 储存至 变量`x`
	- `scan(file="stdin", quiet=TRUE)` 从标准输入中读取，并且禁止显示输入的消息
	- `summary(x)` 对刚刚读取的数据进行一个简单的统计摘要，返回数据的描述性统计信息，如最小值、最大值、中位数等

R 也是一种编程语言，它非常适合被用来进行数据分析和[绘制图表](https://ggplot2.tidyverse.org/)。这里我们不会讲的特别详细， 您只需要知道`summary` 可以打印某个向量的统计结果。我们将输入的一系列数据存放在一个向量后，利用R语言就可以得到我们想要的统计数据。

#### `gnuplot`

如果您希望绘制一些简单的图表， `gnuplot` 可以帮助到您：

```bash
ssh myserver journalctl
 | grep sshd
 | grep "Disconnected from"
 | sed -E 's/.*Disconnected from (invalid |authenticating )?user (.*) [^ ]+ port [0-9]+( \[preauth\])?$/\2/'
 | sort | uniq -c
 | sort -nk1,1 | tail -n10
 | gnuplot -p -e 'set boxwidth 0.5; plot "-" using 1:xtic(2) with boxes'
```

- 用 GNUplot 绘制宽度 0.5 的箱型图
	- `gnuplot`: 这是 GNUplot 绘图工具的可执行文件，用于绘制各种类型的图形。
    - `-p`: 这是一个选项，表示在绘制图形后暂停，以便用户有机会查看生成的图形。
	- `-e 'set boxwidth 0.5; plot "-" using 1:xtic(2) with boxes'`:
	    - `-e '...'`: 这部分指定了要在 GNUplot 中执行的命令或脚本。
	    - `set boxwidth 0.5`: 这个命令设置图中箱形图的箱子宽度为 0.5，指定箱形图中箱子的宽度。
	    - `plot "-" using 1:xtic(2) with boxes`: 这是一个绘图命令，它告诉 GNUplot 从标准输入中读取数据，并绘制箱形图。`using 1:xtic(2)` 表示使用数据中的第一列作为 x 值，使用数据中的第二列作为 x 轴的刻度标签，`with boxes` 表示绘制箱形图。通过使用 "-"，它会将通过管道传递给 GNUplot 的数据作为输入数据。

### 利用数据整理来确定参数

#### `xargs`

有时候您要利用数据整理技术从一长串列表里找出你所需要安装或移除的东西。我们之前讨论的相关技术配合 `xargs` 即可实现：

```bash
rustup toolchain list | grep nightly | grep -vE "nightly-x86" | sed 's/-x86.*//' | xargs rustup toolchain uninstall
```

- 列出已安装的 Rust 工具链
- grep 滤出含 "nightly" 的行
- 去除包含 "nightly-x86" 的行
	- -v 反转
	- -E 正则
- 去掉每个工具链版本号末尾的 "-x86" 字符串
- `xargs rustup toolchain uninstall`: `xargs` 命令将前一个操作的结果作为参数传递给 `rustup toolchain uninstall` 命令，以卸载由之前筛选出来的 Rust 工具链

### 整理二进制数据

虽然到目前为止我们的讨论都是基于文本数据，但对于二进制文件其实同样有用。例如我们可以用 ffmpeg 从相机中捕获一张图片，将其转换成灰度图后通过SSH将压缩后的文件发送到远端服务器，并在那里解压、存档并显示。

```bash
ffmpeg -loglevel panic -i /dev/video0 -frames 1 -f image2 -
 | convert - -colorspace gray -
 | gzip
 | ssh mymachine 'gzip -d | tee copy.jpg | env DISPLAY=:0 feh -'
```

- `ffmpeg` 从 `/dev/video0` 读取视频流的*第一帧*，并将其输出为图像。
	- `-loglevel panic` 设定了日志级别为 panic，以尽量减少输出日志的数量。
	- `-f image2 -` 表示将输出格式设置为 image2，并且 `-` 表示输出将通过**标准输出**展示，而不是保存到文件中
- 使用 `convert` 命令（通常与 ImageMagick 图像处理软件包一起使用），将前一个命令（`ffmpeg` 的输出）从标准输入中读取，并将图像转换为灰度图像。
	- 这里的两个单独出现的 `-` 分别代表 `convert` 会从标准输入中读取输入图像，并将输出发送到标准输出。
- `gzip` 压缩
- 通过 SSH 将数据传输到远程计算机 `mymachine` 的命令
	- 远程机器上的命令首先解压缩收到的数据，然后将其写入 `copy.jpg` 文件，并在显示器上显示图像（使用 `feh` 命令并设置 `DISPLAY=:0` 环境变量来指定显示器）。

> [!note]
> 
> 在这种情况下，`gzip -d` 命令所解压缩的数据是通过 SSH 从本地计算机传输到远程计算机上的压缩数据。

## 课后练习

	1. 学习一下这篇简短 的 [交互式正则表达式教程](https://regexone.com/).
1. 统计words文件 (`/usr/share/dict/words`) 中包含至少三个`a` 且不以`'s` 结尾的单词个数。这些单词中，出现频率前三的末尾两个字母是什么？ `sed`的 `y`命令，或者 `tr` 程序也许可以帮你解决大小写的问题。共存在多少种词尾两字母组合？还有一个很 有挑战性的问题：哪个组合从未出现过？
2. 进行原地替换听上去很有诱惑力，例如： `sed s/REGEX/SUBSTITUTION/ input.txt > input.txt`。但是这并不是一个明智的做法，为什么呢？还是说只有 `sed`是这样的? 查看 `man sed` 来完成这个问题
    
4. 找出您最近十次开机的开机时间平均数、中位数和最长时间。在Linux上需要用到 `journalctl` ，而在 macOS 上使用 `log show`。找到每次起到开始和结束时的时间戳。在Linux上类似这样操作：
    
    ```
    Logs begin at ...
    ```
    
    和
    
    ```
    systemd[577]: Startup finished in ...
    ```
    
	在 macOS 上, [查找](https://eclecticlight.co/2018/03/21/macos-unified-log-3-finding-your-way/):
    
    ```
    === system boot:
    ```
    
    和
    
    ```
    Previous shutdown cause: 5
    ```
    
5. 查看之前三次重启启动信息中不同的部分(参见 `journalctl`的`-b` 选项)。将这一任务分为几个步骤，首先获取之前三次启动的启动日志，也许获取启动日志的命令就有合适的选项可以帮助您提取前三次启动的日志，亦或者您可以使用`sed '0,/STRING/d'` 来删除`STRING`匹配到的字符串前面的全部内容。然后，过滤掉每次都不相同的部分，例如时间戳。下一步，重复记录输入行并对其计数(可以使用`uniq` )。最后，删除所有出现过3次的内容（因为这些内容是三次启动日志中的重复部分）。
6. 在网上找一个类似 [这个](https://stats.wikimedia.org/EN/TablesWikipediaZZ.htm) 或者[这个](https://ucr.fbi.gov/crime-in-the-u.s/2016/crime-in-the-u.s.-2016/topic-pages/tables/table-1)的数据集。或者从[这里](https://www.springboard.com/blog/free-public-data-sets-data-science-project/)找一些。使用 `curl` 获取数据集并提取其中两列数据，如果您想要获取的是HTML数据，那么[`pup`](https://github.com/EricChiang/pup)可能会更有帮助。对于JSON类型的数据，可以试试[`jq`](https://stedolan.github.io/jq/)。请使用一条指令来找出其中一列的最大值和最小值，用另外一条指令计算两列之间差的总和。