---
share: true
---

# 编译原理 - Lecture 2

> 本笔记适用于
> 
> - UPENN CIS 3410/7000
> - ShanghaiTech CS 131 2024+
> - Havard CS 153

## OCaml Crash Course: the SIMPLE language

### Interpreters

这一部分将讲述，如何将程序表示为数据结构；以及如何写一个能够处理程序的程序。

首先得明白两个概念：

- Syntax 语法：怎样的字符组合是合法的？
- Semantics 语义：怎样的意思（行为）是合法的？

我们看看 SIMPLE 的语法

```txt
 *  <exp> ::= 
 *         |  <X>                       // variables
 *         |  <exp> + <exp>             // addition
 *         |  <exp> * <exp>             // multiplication
 *         |  <exp> < <exp>             // less-than
 *         |  <integer constant>        // literal
 *         |  (<exp>)
 *
 *  <cmd> ::= 
 *         |  skip
 *         |  <X> = <exp>
 *         |  ifNZ <exp> { <cmd> } else { <cmd> }
 *         |  whileNZ <exp> { <cmd> }
 *         |  <cmd>; <cmd>
```

- 使用 巴科斯范式 （Backus-Naur form, BNF） 书写，
	- BNF 语法本身就是特定于领域的元语言，用于描述其他语言的语法......
	- 有点像正则表达式一样，是类似正则语言的上下文无关语言
	- `<exp>` 和 `<cmd>` 是 **非终止符 (nonterminals)**
	- `::=`, `|`, `<...>` 是元语言的一部分
	- 关键字，例如 `skip`, `ifNZ`, 以及符号，例如 `+`, `{` 都是目标语言的一部分
- 用来表示抽象语法（与具体语法无关）
- 实现操作上的语义（定义程序的行为或含义）

### OCaml Demo

对比目标语言和元语言

- 目标语言：the language being represented, manipulated, analyzed and transformed （SIMPLE）
- 元语言：the language in which the object language representation and transformations are implemented （OCaml）

对比解释和编译

- 解释器需要执行目标语言和产生结果
- 编译器需要将一种语言翻译为另一种语言

对比静态 (Static) 和动态 (Dynamic)

- Static = determined before the program is executed
	- "static analysis" "static type checking" "statically-linked library"
- Dynamic = determined while the program is running
	- "dynamic analysis" "dynamic checks" "dynamically-linked library"
- 绝大多数优化都是静态的

回到课件代码，我们发现代码中多了一点对程序的定义：

```ocaml
type prog = cmd * state

let interpret_prog (c, s) : state = 
  interpret_cmd s c
```

注意，我们参考之前的示例，实际上顺序执行的程序是用 `Seq` 不断包裹形成的~~回调地狱~~

也就是说，所谓程序就是 命令 与 状态 二者结合相生构成的元组，很好理解。命令的结果依赖当前状态。而执行或者解释一个程序，就是一个，接受命令和当前状态（这里是元组，也就是我们定义的 `prog` 类型），返回新状态的黑盒子，其中解释命令的交给 `interpret_cmd` 来完成。

实际上，也可以把程序看作状态的单向流动，也就是每一行的命令通过 currying 的方式给被赋予了一个不同的黑盒子。

### SIMPLE to OCaml Translation

课件里面多了一个 `translate.ml` ，也就是将我们的 SIMPLE 翻译成 OCaml 的代码（字符串），这也解释了为什么不希望用字符串来表示程序。

话不多说直接上代码：

```ocaml
;; open Simple

module OrderedVars = struct
  type t = var
  let compare = String.compare
end

module VSet = Set.Make(OrderedVars)
let (++) = VSet.union
```

- 普通的导入之前写的 `Simple`
- 定义了一个模块 `OrderedVars` 代表变量，其中
	- 成员类型 `t` 就是类型 `var` (`string`) 的别名
	- 成员函数 `compare` 调用字符串的比较
- 定义了 `VSet` 模块为 `OrderedVars` 类型的集合（这里用到了 `Set.Make` 函数子来生成，有点像 OOP 里面的继承）
- 定义了 `++` 运算符为 `VSet` 集合的连接操作

```ocaml
(* 
  Calculate the set of variables mentioned in either an expression or a command. 
*)

let rec vars_of_exp (e:exp) : VSet.t =
  begin match e with
  | Lit i -> VSet.empty
  | Add(e1,e2) | Mul(e1,e2) | Lt(e1, e2) -> (vars_of_exp e1) ++ (vars_of_exp e2)
  | Var x -> VSet.singleton x
  end 
 
let rec vars_of_cmd (c:cmd) : VSet.t =
  begin match c with
  | Skip -> VSet.empty 
  | Assn(x,e) -> (VSet.singleton x) ++ (vars_of_exp e) 
  | IfNZ(e,c_then,c_else) -> (vars_of_exp e) ++ (vars_of_cmd c_then) ++ (vars_of_cmd c_else)
  | WhileNZ(e,c_body) -> (vars_of_exp e) ++ (vars_of_cmd c_body)
  | Seq(c1, c2) -> (vars_of_cmd c1) ++ (vars_of_cmd c2)
  end 
```

这段代码定义了两个递归的函数，分别用于计算表达式和命令中的变量集合。

这里也非常简单易懂，都是模式匹配，可以通过传入表达式（变量名，操作，字面值）或者命令的各种操作中，返回里面涉及的所有的变量集合，并且这是**递归**进行的，也就是会逐层解包并最后返回含有的所有变量。  
递归的最后一层就是 `Var x` 代表的 `VSet.singleton x` 或者 `Skip` / `Lit i` 代表的 `VSet.empty`。

接下来就是翻译的过程

```ocaml
(* 
  The translation invariants are guided by the _types_ of the operations:

  - variables are global state, so they become mutable references
  - expressions denote integers
  - commands denote imperative actions of type unit

  [[ state : Var => Int ]]
  [[ Var ]] = int ref 

  [[ X ]] : int ref

  [[ exp ]] : int

  [[ cmd ]] : unit
*)
```

在翻译中的“不变量”主要依赖于类型

- 变量是全局变量，也就是全局的 state -> 将会变成可变的引用，就像前文说的那样
	- 变量在翻译过程中被表示为 `int ref`（整数引用）。在OCaml中，`int ref` 是一种可以存储整数且可变的引用类型。这虽然是不纯的，但是也有一定的符合直觉的地方。它可以使用“赋值”，而不是状态似的传递。
- 表达式 -> 整数
- 命令 -> 表示命令动作，其结果是 `unit` 类型，表示命令的副作用

#### 变量

```ocaml
let trans_var (x:var) : string =
  "v_" ^ x

let trans_lookup (x:var) : string =
  Printf.sprintf("%s.contents") (trans_var x)
```

- `trans_var` 会给变量名加上 `v_` 的前缀用来区分
- `trans_lookup` 将会对加入前缀后的变量名调用 `.contents` 函数，这就是翻译获取变量值的代码，例如 `v_Var.contents`

#### 表达式

```ocaml
let rec trans_exp (e:exp) : string =
  let trans_operator e1 e2 op : string =
    Printf.sprintf "(%s %s %s)"
    (trans_exp e1)
    op
    (trans_exp e2)
  in 
  begin match e with
  | Var x -> trans_lookup x
  | Add(e1, e2) -> trans_operator e1 e2 "+"
  | Mul(e1, e2) -> trans_operator e1 e2 "*"
  | Lt(e1, e2)  -> 
    Printf.sprintf "(if %s then 1 else 0)" 
    (trans_operator e1 e2 "<")
  | Lit l -> string_of_int l 
  end 
```

这里用了递归，可以保证算子的两侧是最简的，其中的几个方法都用到了算子来翻译，而剩下的变量名和字面值无需化简。

- 变量名：直接 `trans_lookup`
- 加、乘：翻译成算子中缀输出
- 小于：由于 SIMPLE 的特殊语法，需要翻译成 `if` 表达式，其中的条件仍然用算子翻译函数输出
- 字面值：转换为字符串

#### 赋值语句

```ocaml
let trans_assn (x:var) (e:exp) : string =
  Printf.sprintf "%s.contents <- %s" (trans_var x) (trans_exp e)
```

#### 命令

```ocaml
let rec trans_cmd (c:cmd) : string =
  begin match c with 
   | Skip -> "()"
   | Assn(x, e) -> trans_assn x e
   | IfNZ(e, c1, c2) ->
     Printf.sprintf "if %s <> 0 then (%s) else (%s)"
     (trans_exp e) (trans_cmd c1) (trans_cmd c2)
   | WhileNZ(e, c) -> 
     Printf.sprintf "while %s <> 0 do\n %s done" 
     (trans_exp e) (trans_cmd c)
   | Seq(c1, c2) ->
     Printf.sprintf "%s;\n%s" (trans_cmd c1) (trans_cmd c2)
  end
```

注意，这里也用了递归调用，目的是最简化。

- Skip：空
- 赋值：调用上文的赋值
- `IfNZ` 翻译为 `if` 结构，递归简化
- `WhileNZ` 翻译为 `while` 结构，递归简化
- `Seq` 翻译为 `;\n` 正常换行，递归简化

#### 程序

```ocaml
let trans_prog (c:cmd) : string =
  let vars = vars_of_cmd c in 
  let decls = VSet.fold 
      (fun x s -> Printf.sprintf "let %s = ref 0\n%s" (trans_var x) s)
      vars ""
  in 
  Printf.sprintf "module Program = struct\n%slet run () = \n%s\nend" decls (trans_cmd c)
```

在翻译程序前，我们用 `vars` 获取了命令里面所有的变量，用 `decls` 来生成所有的变量声明的代码（也就是只有全局变量）， `VSet.fold` 对集合中的每个元素应用匿名函数，并将结果累积起来，就形成了声明的代码。

接下来会生成完整的模块代码，该模块包含了一个 `run` 函数，可以等效执行命令 `c`，其中命令 `c` 的具体代码由 `trans_cmd c` 来翻译。

至此，我们就完成了一个从 SIMPLE 到 OCaml 模块的翻译程序。

#### 简单示例

```ocaml
;; print_endline (trans_prog factorial)
```

我们尝试 parse 我们的阶乘程序：

```ocaml
let factorial : cmd =
  let x = "X" in
  let ans = "ANS" in
  Seq(Assn(x, Lit 6),
      Seq(Assn(ans, Lit 1),
          WhileNZ(Var x,
                  Seq(Assn(ans, Mul(Var ans, Var x)),
                      Assn(x, Add(Var x, Lit(-1)))))))
```

源代码如上，翻译后输出如下

```ocaml
module Program = struct
let v_X = ref 0
let v_ANS = ref 0
let run () = 
v_X.contents <- 6;
v_ANS.contents <- 1;
while v_X.contents <> 0 do
 v_ANS.contents <- (v_ANS.contents * v_X.contents);
v_X.contents <- (v_X.contents + -1) done
end
```

实际上，递归“化简”的过程更可以看作递归“翻译”的过程，最显著的特点就是括号的自动添加，实际上阅读起来似乎什么都没有做，毕竟我们还没做任何优化呢！