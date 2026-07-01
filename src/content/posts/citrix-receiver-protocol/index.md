---
title: 给 Linux 上的 Citrix Workspace 补上 receiver:// 协议处理器
published: 2026-07-01
pinned: false
description: "记录一次 Citrix Workspace 能打开 .ica，却无法被浏览器通过 receiver:// 拉起的问题，以及如何用 xdg-mime 和 desktop entry 修好它。"
tags: ["Linux", "Citrix", "Workspace", "xdg", "桌面环境"]
image: ./145495424_p0.jpg
category: Linux
---

公司的远程桌面希望回家用，自己的 Manjaro 上装 Citrix Workspace 的时候遇到一个很微妙的问题：`.ica` 文件本身已经能正常打开，但是浏览器在检测本机客户端时跳不过去，控制台里会报：

```text
Prevented navigation to “receiver://mycomp.cloud.com/Citrix/Store/clientAssistant/reportDetectionStatus/...” due to an unknown protocol.
```

也就是说，Citrix 网页想通过 `receiver://...` 这个自定义协议拉起本地客户端，但桌面环境并不知道这个 scheme 应该交给谁处理。

## Citrix 装在哪里

我的系统里装的是 Arch 系的 `icaclient(AUR)` 包：

```bash
pacman -Qs 'citrix|icaclient|receiver|workspace'
```

结果里能看到：

```text
local/icaclient 26.04.0.105-3
    Citrix Workspace App (a.k.a. ICAClient, Citrix Receiver)
```

包文件可以这样查：

```bash
pacman -Ql icaclient
```

关键路径是：

```text
/opt/Citrix/ICAClient/
/opt/Citrix/ICAClient/wfica
/opt/Citrix/ICAClient/wfica.sh
/opt/Citrix/ICAClient/selfservice
/opt/Citrix/ICAClient/util/ctxwebhelper
```

其中 `.ica` 文件默认走 `wfica.sh`，而 `receiver://` 这种浏览器回调更应该走 `ctxwebhelper`。

## `.ica` 文件为什么已经能打开

先看 `.ica` 的 MIME 默认程序：

```bash
xdg-mime query default application/x-ica
gio mime application/x-ica
```

我这里已经是：

```text
Default application for “application/x-ica”: citrix-wfica.desktop
```

对应的 desktop 文件在：

```text
/usr/share/applications/citrix-wfica.desktop
```

关键内容是：

```ini
[Desktop Entry]
Name=Citrix Receiver Engine
MimeType=application/x-ica;
TryExec=/opt/Citrix/ICAClient/wfica.sh
Exec=/opt/Citrix/ICAClient/wfica.sh
```

所以下载下来的 `.ica` 文件能打开并不奇怪。问题不在 ICA 文件本身，而在 `receiver://` scheme 没注册。

## 查一下 receiver:// 有没有处理器

```bash
xdg-mime query default x-scheme-handler/receiver
gio mime x-scheme-handler/receiver
```

当时的状态是没有默认程序：

```text
No default applications for “x-scheme-handler/receiver”
```

这就解释了浏览器的报错：它不是 Citrix 登录失败，而是系统层面根本不知道 `receiver://` 应该怎么打开。

## Citrix 自己其实预期有这个 handler

我在 Citrix 安装脚本里找到了相关逻辑：

```text
/opt/Citrix/ICAClient/util/hinst
```

里面会注册：

```sh
Do_MIME_default receiver.desktop x-scheme-handler/receiver
```

并且生成 `receiver.desktop` 时，`receiver` 这类 handler 会走：

```text
/opt/Citrix/ICAClient/util/ctxwebhelper %u
```

也就是说，正确关系应该是：

```text
x-scheme-handler/receiver
  -> receiver.desktop
  -> /opt/Citrix/ICAClient/util/ctxwebhelper %u
```

但我的系统上实际只有这些 Citrix desktop 文件：

```text
/usr/share/applications/citrix-configmgr.desktop
/usr/share/applications/citrix-conncenter.desktop
/usr/share/applications/citrix-wfica.desktop
/usr/share/applications/citrix-workspace.desktop
```

没有 `receiver.desktop`，所以需要手动补一个。

## 补一个用户级 receiver.desktop

不改 `/usr/share/applications`，直接放到用户目录：

```bash
mkdir -p ~/.local/share/applications
```

创建：

```text
~/.local/share/applications/receiver.desktop
```

内容：

```ini
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Name=Citrix Workspace Launcher
StartupWMClass=Wfica
NoDisplay=true
Categories=Application;Network;
MimeType=x-scheme-handler/receiver;
Icon=/opt/Citrix/ICAClient/icons/receiver.png
TryExec=/opt/Citrix/ICAClient/util/ctxwebhelper
Exec=/opt/Citrix/ICAClient/util/ctxwebhelper %u
```

然后更新 desktop 数据库并设为默认：

```bash
update-desktop-database ~/.local/share/applications
xdg-mime default receiver.desktop x-scheme-handler/receiver
```

再确认：

```bash
xdg-mime query default x-scheme-handler/receiver
gio mime x-scheme-handler/receiver
```

应该能看到：

```text
receiver.desktop
Default application for “x-scheme-handler/receiver”: receiver.desktop
```

## 测试

可以直接用 `xdg-open` 测一下 scheme 是否会被系统接住：

```bash
xdg-open 'receiver://mycomp.cloud.com/Citrix/Store/clientAssistant/reportDetectionStatus/test'
```

这里不要求这个测试 URL 真的完成 Citrix 业务流程，重点是浏览器和桌面环境不应该再报 unknown protocol。真正从 Citrix 网页点启动时，浏览器应该弹出是否允许打开 Citrix Workspace 的提示，确认后交给 `ctxwebhelper`。

如果 Chrome 之前已经缓存了失败状态，最简单是完整退出后重开：

```bash
pkill chrome
google-chrome
```

## 总结

这次问题的关键点是：

- `.ica` 文件关联正常，只说明 `application/x-ica` 配好了；
- Citrix 网页检测客户端用的是 `receiver://`，这是另一个 `x-scheme-handler/receiver`；
- Linux 桌面环境靠 `.desktop` 文件和 `xdg-mime` 建立 scheme 到程序的映射；
- `receiver://` 应该交给 `/opt/Citrix/ICAClient/util/ctxwebhelper %u`，而不是直接交给 `wfica.sh`。

修完之后，`.ica` 下载打开和浏览器 `receiver://` 拉起客户端就是两条独立但都完整的路径了。

> 封面来自 [画师 kieed](https://www.pixiv.net/users/11525066) 的 [儿童节](https://www.pixiv.net/artworks/145495424)。
>
> ![儿童节](./145495424_p0.jpg)
