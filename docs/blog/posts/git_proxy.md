---
draft: false
date: 2024-01-04
categories:
  - Git
  - SI100B
  - ShanghaiTech
---

# 让 Git 走系统代理

### Background

学校校园网又不稳定了，这下是 HTTPS 和 SSH 的 22 和 ssh.github.com 都不能访问了

网上发现的，就不附上踩坑过程了（如果你是用 SSH 连接的话）

<!-- more -->

### Steps

1. 查看你系统代理的地址，比如我是小猫猫，那就默认是 `7890` 的端口，代理就是 `127.0.0.1:7890`
2. 打开 `C:\Windows\Users\[你的用户名]\.ssh\config` 文件**（没有就新建）**
3. 新增/修改以下内容：

```
Host github.com
    Hostname ssh.github.com
    Port 443
    User git
    ProxyCommand "C:\Program Files\Git\mingw64\bin\connect.exe" -S 127.0.0.1:7890 -a none %h %p
```

4. 测试是否连接：命令行敲入 `ssh -T git@github.com` 若有正常响应即可

> ***PS.*** 具体 `connect.exe` 的文件位置（一定要用绝对路径）可能不同
> 
> ***PPS.*** 如果不知道怎么打开 `.ssh` 文件夹的话，请同时按下 `Windows` + `R` ，并在弹出的 `运行` 窗口中输入 `.ssh` 并点 `确定`