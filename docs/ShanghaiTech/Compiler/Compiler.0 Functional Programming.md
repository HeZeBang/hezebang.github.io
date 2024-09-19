---
share: true
---


# 在开始之前——函数式初探

很早之前就听说了同学的 Haskell 和北大图灵班✌️的 Agda。并对函数式颇感兴趣。

正好 CS131 改成了 OCaml ，说实话是第一次了解这个语言，也是第一次了解函数式编程。作为妮可唯一的 FP 课（x）记录一下初探函数式的一些小不适应吧。

> 这部分是 [这个教程](https://sanette.github.io/ocaml2.org/learn/tutorials/functional_programming.zh.html) 的简单读后感

## 什么是函数式

> 在**函数式语言中**, **函数（functions）**是一等公民。

不理解，继续看

```ocaml
# let double x = x * 2 in
  List.map double [ 1; 2; 3 ];;
- : int list = [2; 4; 6]
```

上面的程序中，正常的逻辑应该是这样：

```python
>>> double = lambda x : x * 2
>>> map([1, 2, 3], double)
[2, 4, 6]
```

`map` 被称为**高阶函数（higher-order function）** (HOF)。高阶函数是指一个把其他函数作为参数之一的函数。（虽然用 Python 的对象也可以解释）

**闭包（closure）** 是那些带着它们被定义时的环境的函数。特别的，一个闭包可以引用它定义时存在的变量。让我们把上面那个函数变得更通用一些，以便我们可以对任何整数列表乘以一个任意值 `n`:

```ocaml
# let multiply n list =
    let f x =
      n * x in
    List.map f list;;
val multiply : int -> int list -> int list = <fun>
# multiply 2 [1; 2; 3];;
- : int list = [2; 4; 6]
# multiply 5 [1; 2; 3];;
- : int list = [5; 10; 15]
```

我们并没有把`n`作为显式的参数传递给它。`f`是从它的环境中找到它的。`n`是传递给函数`multiply`的参数，所以在这个函数中都是有效的。

但 `map` 的定义在`List`模块中，离当前的代码很远。而代码可以传递`f`给其他模块，或者把它的引用（reference）放在某个地方以便之后再调用它。不管怎样，这个闭包保证`f`总是可以获取它定义时的环境，比如`n`。

## 偏函数应用（Partial function applications）和 currying

```ocaml
# let plus a b =
    a + b;;
val plus : int -> int -> int = <fun>
```

- `plus` 是一个函数，类型表示为：`plus : int -> int -> int`
- `plus 2 3` 是一个数，类型表示为 `5 : int`
- `plus 2` 是一个 **函数**，类型为 `int -> int`，相当于，我们指定了第一个参数，这其实就是 currying 的实践

起初我觉得这个 `->` 和空格分割的参数很蠢，但是现在这么一看：

```ocaml
    plus : int -> int -> int
  plus 2 : int -> int
plus 2 3 : int
```

这不就是函数链吗？！师傅我悟了！

~~爆论：（这写法不比 Haskell 的 Monad 方便解释多了）~~

于是我们可以用 currying 来实现简单封装：

```ocaml
# let double = multiply 2;;
val double : int list -> int list = <fun>
# let triple = multiply 3;;
val triple : int list -> int list = <fun>
```

而什么叫 部分应用（Partial Application）？

```ocaml
# let multiply n = List.map (( * ) n);; (* 空格防止认成注释 *)
(* 写成 let multiply n = List.map ( * ) n;; 也可以 *)
val multiply : int -> int list -> int list = <fun>
# let double = multiply 2;;
val double : int list -> int list = <fun>
# let triple = multiply 3;;
val triple : int list -> int list = <fun>
# double [1; 2; 3];;
- : int list = [2; 4; 6]
# triple [1; 2; 3];;
- : int list = [3; 6; 9]
```

在上面的例子中，`((*) n)`是一个`(*)` (乘)函数的部分应用。也就是说，可以把中序操作符放在括号中而形成一个函数。

例如，`+` 其实是一个 `int -> int -> int` 函数

```ocaml
# let plus = ( + );;
val plus : int -> int -> int = <fun>
# plus 2 3;;
- : int = 5
# List.map (plus 2) [1; 2; 3];;
- : int list = [3; 4; 5]
# let list_of_functions = List.map plus [1; 2; 3];;
val list_of_functions : (int -> int) list = [<fun>; <fun>; <fun>]
```

## 函数式编程的优点

> 函数式编程，像其他任何优秀的编程技术一样，是你的工具箱中解决某些问题的利器。它使得 callback 函数变得非常方便，可以用于从 GUI 编程到事件驱动循环等多种场合。它也很适合编写通用算法。`List.map` 就是一个把函数应用到链表中每个元素的通用算法。类似的，你也可以定义树的通用算法。另外，某些类型的数值运算可以用函数式编程更加迅速地解决（比方说求导）。

## 纯函数式和非纯函数式编程

终于讲到 pure functions 了（x

一个**纯函数**是没有**副作用**的。

副作用的意思是这个函数保留了某些隐藏的状态。`strlen`就是一个 C 的纯函数的例子。如果你调用 `strlen` 到相同的字符串，它==总会返回相同的结果==。`strlen` 的==输出只依赖于输入而没有任何其他==。很多C的函数是非纯的。比方说 `malloc`，显然它不会对相同的输入返回相同的结果。 `malloc` 内部有一个很大的数据结构记录状态，如堆的分配情况，用户接口调用情况，OS相关信息等，其实 I/O也是不纯的。

ML衍生的语言，如OCaml是“几乎纯”（mostly pure）的。它们允许引用和数组引入一定的副作用，但很大程度上你会写纯函数，而语言本身也鼓励你这么做。另一个函数式语言 Haskell 是纯的（如果不考虑IO模块）。 相比，OCaml更加实用，因为非纯的函数有时候还是很有用的。

在理论上，纯函数有很多好处。其中一个就是如果一个函数是纯的，那么编译器可以把以 同样参数对该函数的多次调用消除至只剩一个：

```c
for (i = 0; i < strlen (s); ++i)
  {
    // Do something which doesn't affect s.
  }
```

如果是就代码原样编译，那么这个循环的复杂度是 $O(n^2)$，因为`strlen(s)`在 **每个循环都会被调用**，而该调用会把 `s` 遍历一遍。如果编译器知道`strlen`是一个纯函数， 并且`s`不会被更新，它可以简单地把每个循环中的`strlen`调用 **替换成常数**， 使得这个循环变成O(n)。那么编译器是否真的这么做了呢？对于`strlen`，是的， 对于其他函数，不见得（译注：gcc对其有支持，分别是**attribute**((pure)) 和**attribute**((const))，具体参见info page，如我之前所述，gcc的扩展可以让编译器认识纯函数， 并且做这样的优化。但是这种优化不是必然会做的，你可以通过参数-O0使得编译器 不做任何优化）。

## 懒惰、`Lazy`

C类和ML类的语言都是非懒惰的（饥饿求值），而Haskell和Miranda都是懒惰的。OCaml是**默认非懒惰**， 但是在需要的时候支持懒惰的风格。（幽默 OCaml）

对于一个非懒惰的语言，参数和函数总是在使用前被求值，然后再传入到函数中。比如 下面的代码会引起除零错误：

```ocaml
# let give_me_a_three _ = 3;;
val give_me_a_three : 'a -> int = <fun>
# give_me_a_three (1/0);;
Exception: Division_by_zero.
```

在懒惰语言中，一些奇怪的事情会发生。函数的参数只有在被使用的时候才会被求值。 `give_me_a_three`没有使用参数而直接返回3，因而在一个懒惰语言中，这个函数调用 不会失败，因为这个参数根本没有被求值！因此，也不会引起除零错误。

懒惰语言允许你定义无限长的链表，只要你不会真的要遍历整个链表（比方说你只要前10个元素）。

OCaml是一个非懒惰的语言，但是`Lazy`模块允许你写懒惰的表达式，下面就是这样一个例子：

```ocaml
# let lazy_expr = lazy (1/0);;
val lazy_expr : int lazy_t = <lazy>
```

注意到其类型是 `int lazy_t`。

因为`give_me_a_three`是多态的，所以我们也可以把这个懒惰表达式传入：

```ocaml
# give_me_a_three lazy_expr;;
- : int = 3
```

如果要求值，我们要用`Lazy.force`函数：

```ocaml
# Lazy.force lazy_expr;;
Exception: Division_by_zero.
```

## box和unbox

box的意思是，把一些标准数据类型，如int，用一个对象封装，而这个对象的行为如int本身无异。但是 这会损耗一定效率。

你可能会经常听到函数式语言是boxed的。我经常会混淆这个词，但实际上在C/C++, Java中， 这里的区别还是很明显的（Perl总是box的）。

一个boxed的对象就像用C中用`malloc`分配在了堆上（C++中则是new），并且被指针引用， 下面是一个C的例子：

```c
#include <stdio.h>

void
printit (int *ptr)
{
  printf ("the number is %d\n", *ptr);
}

void
main ()
{
  int a = 3;
  int *p = &a;

  printit (p);
}
```

`a` 是在栈上的，显然是unboxed的。（堆栈详情左转 CS130 PintOS(x）而函数`printit`打印一个boxed的整数。

> ![../res/Pasted image 20240919204617.png](../res/Pasted%20image%2020240919204617.png)
> 
> 上图 unboxed，下图 boxed

显然操作一个unboxed的整数数组是比操作一个boxed的要快很多。并且由于上了很多 小的分块，垃圾收集也要快很多。

C/C++，这应该不成问题，在Java中，`int`是unboxed而`Integer`是boxed的。Ocaml中， 基本类型是unboxed的。