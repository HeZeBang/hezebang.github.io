---
draft: false
date: 2024-02-06
categories:
  - Others
  - tmux
---

# tmux 指南

> [!note]
>
> 本人经常忘记 tmux 怎么用，特写此文，望周知

<!-- more -->

## `Ctrl` + `b` 前缀键！

相当于 VSCode 某些二段快捷键的 `Ctrl` + `K`

## 常用快捷键

- `C-b /` Describe key binding
- `C-b t` Show a clock

**分屏**

- `C-b %` Split window horizontally
- `C-b "` Split window vertically

**编辑**

- `C-b \[` Enter copy mode
- `C-b \]` Paste the most recent paste buffer

**窗口管理**

- `C-b i` Display window information
- `C-b c` Create a new window
- `C-b f` Search for a pane
- `C-b w` Choose a window from a list
- `C-b s` Choose a session from a list
- `C-b d` Detach the current client
- `C-b x` Kill the active pane

**窗口操作**

- `C-b Up/Down/Right/Left` Select the pane
- `C-b C-Up/Down/Right/Left` Resize the pane