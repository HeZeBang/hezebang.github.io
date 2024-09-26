---
share: true
---

# 编译原理 - Lecture 4

## Implementing X86lite

### DEMO: Handcoding X86lite

在 `lec4.zip` 里面，包含了一个最简单的 `x86LITE` 翻译套件。

例如，`main.ml` 里面会调用 `X86.string_of_prog` 将 `X86LITE` 语法转换为汇编代码字符串并输出，实际上， `p3` 的代码就是计算 `fact(6)` 的简单程序

我们来分析其中的一些部分操作

其中，`make` 生成的可执行文件 `test` 实际上是 `runtime.c` 与 `main.ml` 翻译成汇编的 `test.s` 二者连接生成的可执行文件，运行后会正确返回 `720`

我们也可以看看 `test.s` 的代码：

```asm
	.text                # 指示接下来的指令属于代码段
	.globl	program      # 定义 program, 使得 runtime.c 可以正常调用
program:
	movq	$1, %rax     # 将通用累加器 (ans) 赋值为立即数 1
	movq	$6, %rdi     # 指针指向立即数 6
	.text
loop:
	cmpq	$0, %rdi     # 比较 %rdi 与 0
	je	exit             # rdi == 0 => 跳到 exit
	imulq	%rdi, %rax   # ans *= rax
	decq	%rdi         # rdi --
	jmp	loop             # 循环
	.text
exit:
	retq	             # 返回 (rax)
```

#### Assembler Syntax

让我们来看看 `x86` 的基本解释代码

---

首先定义了汇编的基本语法

```ocaml
(* assembler syntax --------------------------------------------------------- *)

type lbl = string

type quad = int64

type imm = Lit of quad
         | Lbl of lbl
```

例如，标签是字符串，`quad` 代表 x86lite 仅有的数据类型 `int64`，立即数是 `quad`(`int64`) 的字面值 (`Lit` aka `int`)

---

下面是关于寄存器和操作数的定义：

```ocaml
(* arguments: rdi, rsi, rdx, rcx, r09, r08
   callee-save rbx, rbp, r12-r15 *)
type reg = Rip
         | Rax | Rbx | Rcx | Rdx | Rsi | Rdi | Rbp | Rsp
         | R08 | R09 | R10 | R11 | R12 | R13 | R14 | R15
         
type operand = Imm of imm            (* immediate *)
             | Reg of reg            (* register *)
             | Ind1 of imm           (* indirect: displacement *)
             | Ind2 of reg           (* indirect: (%reg) *)
             | Ind3 of (imm * reg)   (* indirect: displacement(%reg) *)
```

其中，`reg` 定义了几种寄存器，而操作数也有不同的匹配方法

---

下面是对条件指令的定义

```ocaml
(* Condition Codes *)
type cnd = Eq | Neq | Gt | Ge | Lt | Le

type opcode = Movq | Pushq | Popq
            | Leaq
            | Incq | Decq | Negq | Notq
            | Addq | Subq | Imulq | Xorq | Orq | Andq
            | Shlq | Sarq | Shrq
            | Jmp  | J of cnd
            | Cmpq  | Set of cnd
            | Callq | Retq
```

然后定义了什么是指令、数据、汇编

```ocaml
type ins = opcode * operand list    

type data = Asciz of string
          | Quad of imm

type asm = Text of ins list    (* code *)
         | Data of data list   (* data *)
```

- 指令，也就是 `机器码 * 操作数列表` 的元组
- 数据，可能是 `Asciz` 构造的字符串，也有可能是 `Quad` 构造的立即数
- 汇编，包含代码和数据，代码是指令的列表，数据是之前定义的 `data` 的列表

---

```ocaml
(* labeled blocks of data or code *)
type elem = { lbl: lbl; global: bool; asm: asm }

type prog = elem list
```

- `elem` 代表数据或代码的带标签块，包含
	- 标签字符串
	- 是否全局（涉及到作用域和生命周期）
	- 含有的汇编代码
- `prog` 代表整个程序，程序是 `elem` 构成的列表

---

#### Pretty Printing

这部分是将中间表示转化为输出的部分，我们略作讲解

首先，是对寄存器的转换，`string_of_reg` 和 `string_of_byte_reg` 都是将对应的寄存器的字符串输出，需要注意，由于 `string_of_byte_reg` 将寄存器转换为字节级别的字符串，需要避免 `%rip` 的调用。

其次是对标签、立即数的转换。

接着是操作数的两种转换，除了寄存器调用的函数不同并无其他区别（唉唉，没有重写）

然后是解析 `jump` 的操作数：注意这里涉及到了地址的操作，需要解引用==（开头加入 `*`）==

条件后缀和 `opcode` 的解析，非常简单。

---

后面的开始有意思起来了

先是定义了一个工具函数 `map_contact`

```ocaml
let map_concat s f l = String.concat s @@ List.map f l
```

- 用于对一个列表 `l` 应用 `f` 进行映射，然后将结果中间加入 `s` 连接成字符串

然后是 `string_of_shift` 函数，用来处理移位相关的指令，将其转换为字符串

```ocaml
let string_of_shift op = function
  | [ Imm i ; dst ] as args ->
    "\t" ^ string_of_opcode op ^ "\t" ^ map_concat ", " string_of_operand args
  | [ Reg Rcx ; dst ] ->
    Printf.sprintf "\t%s\t%%cl, %s" (string_of_opcode op) (string_of_operand dst)
  | args -> failwith (Printf.sprintf "shift instruction has invalid operands: %s\n" 
                     (map_concat ", " string_of_operand args))
```

- 首先是这个颇具特色的函数的定义，相当于模式匹配了三个函数（重载是吧）
- 然后是各种匹配，分别对应参数为
	- 立即数+操作数 -> `<op>  <i>, <op-dst>`
	- 寄存器+操作数 -> `<op>  %cl, <op-dst>` ==是否只有 `%rcx` 能够直接位移？==
	- 其它 -> 报错

---

而我们看看如何将 instruction 翻译到 asm string

```ocaml
let string_of_ins (op, args: ins) : string =
  match op with
  | Shlq | Sarq | Shrq -> string_of_shift op args
  | _ ->
  let f = match op with
    | J _ | Jmp | Callq -> string_of_jmp_operand 
    | Set _ -> string_of_byte_operand
    | _ -> string_of_operand 
  in
  "\t" ^ string_of_opcode op ^ "\t" ^ map_concat ", " f args
```

首先会判断，如果是位移相关就交给 `string_of_shift` ，否则再处理其他的，因为位移的输出不太相同。

```ocaml
let string_of_data : data -> string = function
  | Asciz s -> "\t.asciz\t" ^ "\"" ^ (String.escaped s) ^ "\""
  | Quad i -> "\t.quad\t" ^ string_of_imm i

let string_of_asm : asm -> string = function
  | Text is -> "\t.text\n" ^ map_concat "\n" string_of_ins is
  | Data ds -> "\t.data\n" ^ map_concat "\n" string_of_data ds

let string_of_elem {lbl; global; asm} : string =
  let sec, body = match asm with
    | Text is -> "\t.text\n", map_concat "\n" string_of_ins is
    | Data ds -> "\t.data\n", map_concat "\n" string_of_data ds
  in
  let glb = if global then "\t.globl\t" ^ string_of_lbl lbl ^ "\n" else "" in
  sec ^ glb ^ string_of_lbl lbl ^ ":\n" ^ body

let string_of_prog (p:prog) : string =
  String.concat "\n" @@ List.map string_of_elem p
```

最后几个处理：
- `string_of_data` 在一个数据前附上标识
	- `.asciz` - `\0` 结尾的字符串
	- `.quad` - 8字节常量
- `string_of_asm` 在一个 asm 汇编段前附上标识==（但是这个真的被调用了吗？存疑）==
	- `.text` 标识代码段的开始，这个标识符常在汇编代码的开头或函数定义之前
	- `.data` 标识数据段的开始，这一段含有全局变量和静态数据`
- `string_of_elem` 将（带有标签和是否全局标志）汇编元素转换为字符串
- `string_of_prog` 将整个程序连接起来

---

#### Examples

```ocaml
(* This module defines some convenient notations that can help when 
 * writing x86 assembly AST by hand. *)
module Asm = struct
  let (~$) i = Imm (Lit (Int64.of_int i))      (* int64 constants *)
  let (~$$) l = Imm (Lbl l)                    (* label constants *)
  let (~%) r = Reg r                           (* registers *)

  (* helper functions for building blocks of data or code *)
  let data l ds = { lbl = l; global = true; asm = Data ds }
  let text l is = { lbl = l; global = false; asm = Text is }
  let gtext l is = { lbl = l; global = true; asm = Text is }
end
```

在开始之前，我们定义了一个 `Asm` 模块，它可以实现以下 shorthands：
- `~$42` - 快速 `int64` 常数
- `~$$"lbl"` - 快速 `label`
- `~%Rax` - 快速寄存器
- `data`, `text`, `gtext` - 快速包装为汇编元素

另外，OCaml 也有类似于 `using Asm` 的用法：即 `Asm.[ ... ]`

---

```ocaml
(* Example X86 assembly program (written as OCaml AST).

     Note: OS X does not allow "absolute" addressing (i.e. using
     Ind1 (Lbl "lbl_name") as a source operand of Movq).
     So this program causes an error when assembled using gcc.
*)
let p1 : prog =
  Asm.[
    text "foo"
        [ Xorq, [~%Rax; ~%Rax]
        ; Movq, [~$100; ~%Rax]
        ; Retq, []
        ]
    ; gtext "_program" 
        [ Xorq, [~%Rax; ~%Rax]
        ; Movq, [Ind1 (Lbl "baz"); ~%Rax]
        ; Retq, []
        ]
    ; data "baz"  [Quad (Lit 99L)]
    ; data "quux" [Asciz "Hello, world!"]
    ]
```

一个用来测试的函数，虽然非常简单，但是笔者在构建可执行文件时遇到了 PIE 报错，也许和上文注释中 OS X 的原因一致？看看 GPT 的解释：

> - PIE（Position Independent Executable，位置无关执行文件）是一种可执行文件，它可以装载到内存中的任意位置。它使得安全特性如地址空间布局随机化（ASLR）更加有效。
> - 这个错误表明正在尝试生成一个 PIE，但是目标文件中的 `R_X86_64_32S` 重定位类型不适用于 PIE。
>   - 解决办法是重新编译时使用 `-fPIE`（生成位置无关代码）选项。
> - 它告诉编译器生成适合位置无关执行文件的代码。

```txt
cd code && dune build
Entering directory '/workspaces/lec04'
./code/main.exe > test.s           
gcc -o test test.s runtime.c
/usr/bin/ld: /tmp/cc0WbUWg.o: relocation R_X86_64_32S against symbol `baz' can not be used when making a PIE object; recompile with -fPIE
collect2: error: ld returned 1 exit status
make: *** [Makefile:22: test] Error 1
```

好吧，那我们就看看下一个

---

```ocaml
(* This example uses "rip-relative" addressing to load the 
   global value (99L) stored at label "baz". *)
let p2 : prog =
  Asm.[
    text "foo"
      [ Xorq, [~%Rax; ~%Rax]
      ; Movq, [~$100; ~%Rax]
      ; Retq, []
      ]
  ; gtext "program" 
      [ Xorq, [~%Rax; ~%Rax]
      ; Movq, [Ind3 (Lbl "baz", Rip); ~%Rax]
      ; Retq, []
      ]
  ; data "baz" [Quad (Lit 99L)]
  ; data "quux" [Asciz "Hello, world!"]
  ]
```

最大的区别是将 `Ind1 (Lbl "baz")]` 改成了 `Ind3 (Lbl "baz", Rip)`，在生成的汇编中由 `movq	baz, %rax` 改为了 `movq	baz(%rip), %rax`。

让我们来分析：

- 首先，进入 `foo` 函数段
	- 对 Rax 寄存器进行自我 `xor` 操作，是一个常见的清零。
	- 将 100 赋值 Rax
	- 返回
- 进入 `_program` 函数段
	- 清零
	- 在第一份代码中，会生成 `movq baz, %rax` 将标签 `baz` 对应的地址移动到 Rax，是绝对寻址
	- 而在第二份代码中，会生成 `movq	baz(%rip), %rax` 将标签 `baz` 计算偏移量之后的地址移动到 Rax ，是相对寻址
- 后续两个数据段不做赘述

需要注意的是，前者的绝对寻址时，汇编程序在组装和链接时已经知道 `baz` 在内存中的确切位置，并会在指令中嵌入这个地址。而绝对寻址在位置无关可执行文件 (PIE) 时可能会产生重定位问题（现代操作系统通常会启用地址空间布局随机化（ASLR）等安全策略，所以每次程序会被加载到随机的地址），因为绝对地址在不同的加载位置可能会改变。  
在 x86 架构中，相对寻址是基于指令指针 `%rip` 的偏移地址计算的。因此，相对地址是相对于当前执行代码的位置计算的。  
相对寻址允许生成位置无关代码 (PIC)，这种代码可以加载到内存中的不同位置而无需重定位修改。

---

```ocaml
(* This x86 program computes [n] factorial via a loop.
   Note that the argument [n] is a meta-level variable.
   That means that p3 is really a "template" that, given
   an OCaml integer [n] produces assembly code to 
   compute [n] factorial.
*)
let p3 (n : int) : prog =
  Asm.[
    gtext "program"
      [ Movq,  [~$1; ~%Rax]
      ; Movq,  [~$n; ~%Rdi]
      ]
  ; text "loop"
      [ Cmpq,  [~$0; ~%Rdi]
      ; J Eq,  [~$$"exit"]
      ; Imulq, [~%Rdi; ~%Rax]
      ; Decq,  [~%Rdi]
      ; Jmp,   [~$$"loop"]
      ]
  ; text "exit"
      [ Retq,  [] 
      ]
  ]
```

这里不多做赘述，可以看之前的分析。

---

```ocaml
(* This x86 program computes [n] factorial via recursion.
   As above, [n] is a meta-level argument.
*)
let p4 (n : int) : prog =
  Asm.[
    text "fac"
      [ Movq,  [~%Rsi; ~%Rax]
      ; Cmpq,  [~$1; ~%Rdi]
      ; J Eq,  [~$$"exit"]
      ; Imulq, [~%Rdi; ~%Rsi]
      ; Decq,  [~%Rdi]
      ; Callq, [~$$"fac"]
      ]
  ; text "exit"
      [ Retq,  [] ]
  ; gtext "program"
      [ Movq,  [~$n; ~%Rdi]
      ; Movq,  [~$1; ~%Rsi]
      ; Callq, [~$$"fac"]
      ; Retq,  []
      ]
  ]
```

与 p3 不同，这里用的是递归的方式，也就是说，函数的“循环”操作不再依赖 `jmp`，而是用 `call` （虽然本质上都是改变 rip，但是调用函数需要有栈的操作）  
虽然这里的栈的操作看起来是多余的，但是向我们展示了 `call` 的用法

### Programming in X86lite

#### 关于存储

基本的 C 内存模型包含三个部分，地址从高到低分别为

- Stack
	- 存储局部变量
	- 存储函数 return 的地址
- Heap
	- 存储**动态分配**的对象
	- 通过 `malloc`, `free` 分配和释放
	- 由 C runtime system 管理
- Code & data (and text)
	- 包括编译后的代码，字符串常量等

我们可能需要存储全局变量、函数参数、（原先或者编译器定义的）局部变量。我们可以存储到快速但空间小的 Register 或者慢速但空间大的 Memory（或者 Cache）。在 X86 的实践中， Reg 有限，而 Mem 被划分为了很多带有堆栈的小区域。

#### 函数调用

> 下面以 X86-64 SYSTEM V AMD 64 ABI 为例

根据调用的主从关系分为 Caller / Callee，例如 `a` 调用了 `b` ，则 `b.caller` 就是 `a`

而寄存器也分为

- Callee Save，例如 `rbp`, `rbx`, `r12-15` 等 - 被调用者保存，被调用的函数 `b` 有责任在被调用时先保存一份寄存器，然后在返回时恢复。
- Caller Save，调用者保存，如果 `a` 想在调用 `b` 之后继续使用这些寄存器的话，那 `a` 有责任在调用 `b` 前保存一份在之后恢复，`b` 可以自由使用而没有限制。

定义栈分配参数的清理协议：

- 调用者负责清理。
- 被调用者负责清理（这使得支持可变数量参数变得更困难）。

**参数的分配**

- 1~6：按顺序存放在 `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`
- 其他：入栈（right-to-left），例如 n-th arg 的地址为：`(((n-7)+2)*8)(%rbp)`

**返回值**

- 存储在 `rax`

**128-byte 红线** (128 byte "red zone"): 栈上的一个特定区域，通常大小为 128 字节，位于栈顶。

- 可以被被调用函数用来存储临时数据，而无需调整栈指针，减少指针修改
- 在许多 C 编译器中被使用，编译器可以将那些只在函数内部使用的局部变量放入红区，从而节省栈空间，提高函数调用的效率。并不是必需的 x86-64 特性。
- 可以优化

**32-bit cdecl 调用约定**

- 在许多基于 C 的操作系统中仍然被广泛使用
	- 返回值：通过 `EAX` 寄存器返回的（有一些不统一，例如一些编译器使用寄存器 EAX 和 EDX 来返回小的值，以及 64 位可以在一个寄存器中打包多个返回值）
	- 传参：所有参数都是按照从右到左的顺序通过栈传递。这意味着最后一个参数先入栈，第一个参数最后入栈。
	- 寄存器：`EAX`, `ECX`, `EDX` 都是 Caller Save，其他为 Callee Save

下面的示例见 [Slides.4.14](https://www.seas.upenn.edu/~cis3410/current/_static/lectures/lec04.pdf#page=14)