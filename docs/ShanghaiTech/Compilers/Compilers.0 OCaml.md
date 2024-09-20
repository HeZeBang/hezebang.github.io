---
share: true
---


# OCaml 学习手记

> 学习资料来自：[Introduction to OCaml](https://www.seas.upenn.edu/~cis3410/current/_static/files/ocaml-book.pdf)

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

