---
share: true
---


# 编译原理 - Homework 1

> 本笔记适用于
> 
> - UPENN CIS 3410/7000
> - ShanghaiTech CS 131 2024+
> - Havard CS 153

## Tips - 在开始之前

在使用 upenn 的 dev container 的时候，第一次运行需要构建，笔者的 Manjaro 曾出现如下报错

```
[1136 ms] docker: 'buildx' is not a docker command.
See 'docker --help'
```

安装 `docker-buildx` 软件包即可

初次启动需要构建许多，笔者的电脑构建了大约 20 min，大家可以酌情参考。

### 关于构建项目

和 PintOS 的逻辑非常像，也是通过 Makefile 来确定任务流。例如 `make test`

```
make       --  builds oatc using dune
make dev   --  runs dune build in "watch" mode for more interactive errors
make test  --  runs the test suite
make clean --  cleans your project directory
make utop  --  starts a utop for the project
make zip   --  creates a zip file with the code you need to submit
```

运行 `make` 后，会生成唯一的入口点并复制为项目根目录的 `oatc` 可执行文件

### 报错

通常遇到的报错可以通过 `dune build` 解决，笔者曾尝试通过更新 lsp 等方式，最后还是被网速折服了……

## 作业内容简析

这次的作业主要是熟悉 OCaml 的编写流程。可能是妮可唯一一门教函数式的课了吧（x

- Problem 1 主要在熟悉基本的函数和断言。
	- 注意，由于 Problem 1-3 是让你自己手动更改评测的断言，无法验证正确性，所以会用 ？ 提示分数，修改了即能算分，正误另有判断。
- Problem 2 对应 [IOC](https://www.seas.upenn.edu/~cis3410/current/_static/files/ocaml-book.pdf) 的 5.2，主要熟悉 `Tuples` 类型
	- 当然，首先就是上来一个模式匹配，最好先看 Chap.4
	- 虽然个人认为这个模式匹配的几个例子和下面的列表非常的 tricky，写出来的代码很有防御式编程的味道
- Problem 3 列表的神奇应用
	- 其实列表不是 pure 的，我也不知道为什么想说这个，语言洁癖？
	- 还是蛮好玩的，根据上面 tricky 的例子琢磨琢磨
- Problem 4 更多匹配
	- 可以参考 Lec1.zip 的内容
	- 注意小细节即可
- Problem 5 虽然是 Hidden Point，但是也很重要
	- 这里主要是 `@` 和 `append` 实测 `@` 的代码更简洁，但是笔者先入为主用的 `append`
	- 本质就是加了个 stack 换皮，没有什么含金量
- 最后
	- 注意 OCaml 语法格式规范