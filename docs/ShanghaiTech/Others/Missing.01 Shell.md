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

