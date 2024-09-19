---
share: true
---


# Homework 1

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

## [IOC](https://www.seas.upenn.edu/~cis3410/current/_static/files/ocaml-book.pdf) 学习手记

### Tuples 与 Polymorphism

OCaml 的 Tuples 支持 2 个及以上元素，且支持**多态**。

```ocaml
# let identity x = x;;
val identity : 'a -> 'a = <fun>
# identity 1;;
- : int = 1
# identity "Hello";;
- : string = "Hello"

# let succ i = i + 1;;
val succ : int -> int = <fun>
# identity succ;;
- : int -> int = <fun>
# (identity succ) 2;;
- : int = 3
```

例如上图的例子中定义了一个支持多态的函数，其中 _类型变量_ 有着小写且由 `'` 开头的变量名。`identity : 'a -> 'a` 说明 `identity` 函数接受任意类型的参数 `'a` 并返回相同类型的 `'a` 的值。甚至可以返回函数 ~~（这不是我们 Everything in Python is Object 吗？下次记得标明出处）~~  
得益于强大的类型推断，我们可以用函数链组合起来，将它们组合成一个 `int -> int` 的函数，就是这么简单！

当然我们也可以手动指定类型（与 Python 不同，这个类型是强制的）：

```ocaml
# let identity_int (i : int) = i;;
val identity_int : int -> int = <fun>

```

在所有参数后面指定的类型为函数返回值的类型

```ocaml
# let do_if b i j = if b then i else j;;
val do_if : bool -> ’a -> ’a -> ’a = <fun>
# let do_if_int b i j : int = if b then i else j;;
val do_if_int : bool -> int -> int -> int = <fun>
```

### Value restriction 与 immutable

非常精彩的演示，建议读原书。

要使表达式真正具有多态性，它必须是一个 immutable 的值，这意味着：  
1. 它已经被完全求值
2. 它不能被赋值修改

因此，`identity identity` 这样的 function applications 并不是 value，因为可以被简化为 `identity`，因此是 mutable 的，而 "mutable values are not polymorphic"，因此 `arrays` 和  `reference cells` 这类 mutable 的也不会支持多态。