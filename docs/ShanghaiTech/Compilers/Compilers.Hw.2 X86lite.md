---
share: true
---

# 编译原理 - Homework 2

## Overview

本次的作业需要修改到 `simulator.ml` 和 `studenttests.ml`，我们将在这次作业中继续完善我们的 X86lite 工具链，实现一个小的模拟器。

## Part.I: The Simulator

### 简介

由于 X86 原版臭名昭著地复杂（原文：notoriously complicated），我们的**内存实现**将会基于 OCaml 的 `sbyte` 数组。 每行内存中加载的指令都用固定长度，8-bytes 编码的 `sbyte` 数组表示。

```ocaml
[| ...
 InsB0 (Subq,  [Imm (Lit 8L); Reg Rsp]);  InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (Cmpq,  [Imm (Lit 1L); Reg Rdi]);  InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (J Le,  [Imm (Lit 72L)]);          InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (Movq,  [Reg Rdi;      Ind2 Rsp]); InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (Decq,  [Reg Rdi]);                InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (Callq, [Imm (Lit 0L)]);           InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (Imulq, [Ind2 Rsp;     Reg Rax]);  InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (Addq,  [Imm (Lit 8L); Reg Rsp]);  InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (Retq,  []);                       InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (Movq,  [Imm (Lit 1L); Reg Rax]);  InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (Addq,  [Imm (Lit 8L); Reg Rsp]);  InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (Retq,  []);                       InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (Movq,  [Imm (Lit 5L); Reg Rdi]);  InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (Callq, [Imm (Lit 0L)]);           InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 InsB0 (Retq,  []);                       InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag; InsFrag
 ...
|]
```

这些象征性的字节中
- `InsB0` 代表了在指令的第一个字节
- 接下来的 7 个 `InsFrag`s 代表了剩下的 7 字节用来对齐
- 读取指令只需要读取第一个字节，然后忽略掉剩下的占位符即可

> [!warning] 请务必仔细阅读手册
> [x86lite specification](https://www.seas.upenn.edu/~cis3410/current/hw2/doc/x86lite.html#x86lite) RTFM.

Assembler 以及 Linker / Loader 解决了部分标签的行为问题，我们的 Simulator 因此可以假设这些已经完成，因此 operand 将不包含标签。例如在上面阶乘示例中，使用标签 `fac` 的调用和使用 `exit` 的跳转已被替换为 literal immediate operand `OL` 和 `72L`。

我们的 ML 级解释器对 X86lite **机器状态**的表示由以下类型给出，寄存器和内存采用了 mutable 的 Ocaml array，condition flags 存储为 mutable boolean field。整个状态存储为了一个 record。

```ocaml
type flags = { mutable fo : bool
             ; mutable fs : bool
             ; mutable fz : bool
             }

type regs = quad array

type mem = sbyte array

type mach = { flags : flags
            ; regs : regs
            ; mem : mem
            }
```

关于其他的配置以及与实体机不同的地方：

- **内存**：只是用 `64K` 内存， 堆模拟的部分是最高可寻址内存位置的部分，范围从 `mem_bot` 到 `mem_top`，并且不会要求像 OS 一样实现内存请求（好耶），即：你可以假设这些内存都是已经被虚拟化和分页好了的，也不会模拟与内存分页相关的对齐或代码布局的任何限制。
- **符号指令编码**：补充前文，程序读取和操作代表指令的 `sbyte`s 作为数据的行为是没有指定的，我们写的 Simulator 可能会报错或者指定一些默认操作，原文中称 `we will not test these cases.`
- **操作数限制**：比如 `leaq` 在 x86lite 规范中只能使用间接内存操作数。而我们的 Simulator 不要求检测无效操作数。
- **终止和 System calls**：正常的程序会在终止时调用例如 POSIX 的 `exit` 这种系统调用来通知 OS 终止，我们这里采用 `exit_addr` 这样一个超出内存空间的 sentinel address 来表示程序是否被终止。

#### Tasks

推荐顺序：

1. 作为条件代码的练习，实现 `interp_cnd` 函数
2. 实现 `map_addr` 函数
	- 它将用 `quad` 表示的地址值转化为某些数组索引
	- 不合法的访问将返回 `None`
3. 实现操作数的解释（包括间接寻址），因为模拟指令需要此功能
4. 实现 `step` 函数，它通过修改作为参数传递的机器状态来模拟单个指令的执行

##### 在开始之前

项目结构还是比较简单的，首先是一堆与地址范围、寄存器数量、指令集大小、退出指示地址的常量定义。

以及一个有趣的：`X86lite_segfault` - 当访问越界时应该 raise 这个错误。

关于符号字节：见上文，来看具体定义：

```ocaml
type sbyte = InsB0 of ins       (* 1st byte of an instruction *)
           | InsFrag            (* 2nd, 3rd, or 4th byte of an instruction *)
           | Byte of char       (* non-instruction byte *)
           
type mem = sbyte array
```

除了 `InsB0` 和 `InsFrag` 占位符以外还有一个非指令的 `Byte` 构造器

后面的机器状态上文也讲过了，这里不再赘述。

然后是一些工具函数
- 寄存器
	- `rind : reg -> int` 将寄存器转换为索引
- `sbyte`s 读写
	- `sbytes_of_int64 (i:int64) : sbyte list` 将一个 `int64` 转换为 `sbyte`s
	- `int64_of_sbytes (bs:sbyte list) : int64` 将 `sbyte`s 转换为一个 `int64`
	- `sbytes_of_string (s:string) : sbyte list` 将字符串转换为 `sbyte`s
	- `sbytes_of_ins (op, args:ins) : sbyte list` 将带参数的指令转换为一组 `sbyte`s
	- `sbytes_of_data : data -> sbyte list` 将 `data` 转换为一组 `sbyte`s

最后是一个调试标记 `debug_simulator`

##### `interp_cnd`

Interpret a condition code with respect to the given flags.

参考 [Compilers.Lec.3 > Conditional](./Compilers.Lec.3.md#conditional) 完成模式匹配即可

##### `map_addr`

注意可爱的 `Int64` 即可，以及提供的一些常量如 `mem_bot`, `mem_size`, `mem_top`

> [!warning] raise
> 
> 在 `map_addr` 中不应该直接 raise，否则某些测试点会失败， 新版的文件中添加了对错误的统一处理修复了该问题。

##### Interpreting operands

已知操作数有如下类型，那就直接分开匹配就行了，记得阅读手册

```ocaml
type operand = Imm of imm            (* immediate *)
             | Reg of reg            (* register *)
             | Ind1 of imm           (* indirect: displacement *)
             | Ind2 of reg           (* indirect: (%reg) *)
             | Ind3 of (imm * reg)   (* indirect: displacement(%reg) *)
```

- Immediate: 即返回立即数本身，类似于字面值
- Register: 返回寄存器的值
- 接下来的所有 Indirect 寻址都像是：将原本的字面值作为一个指针，也就是 `*addr` 的形式，例如 `*0x1234` 就是指向 `0x1234` 的地址。
	- Ind1：返回字面值指向的地址存放的值
	- Ind2：返回寄存器的值指向的地址存放的值
	- Ind3：寄存器+偏移的地址存放的值

不过这里只给出了 `interp_op` 是一个 `operand -> int64` 的映射，我这里默认做的是对操作数取出具体值。

需要注意的是，这里还没有涉及到关于 `lbl` 的实现，这将会在我们的后续的任务中实现 `lbl` 的替换，这里只需要 `raise` 或者做默认行为即可。

##### `step`

我们来看看注释中给 `step` 定义的步骤：

1. 获取指令，很简单，从 `%rip` 中读取值并且转译成指令就好
2. 计算操作数的信息，解析指令中含有的操作数，直接调用上面我们写的函数即可
3. 模拟指令语义，
4. 更新寄存器或内存
5. 设置 Conditional flags

首先我决定开始实现位移指令，因此定义了一个用来存放数据的函数。  
在这里先要区分两个概念：

- Location：是位置，可以是一个 Imm.Lit 来表示绝对位置，也可以是 Reg 作为目标，也可以是 Indx 等间接的表示
- Value：是值，可以是 Imm.Lit 来表示字面值，也可以是从 Reg 中或者 Indx 的地址中提取值

而我们的数据是 64-bit 的，也就是占用 8 bytes

> 等下 4-byte encoding? 但是 8-byte 编码？
> 
> ```ocaml
> let ins_size = 4L (* assume we have a 4-byte encoding *)
> ```

好吧，那么读取内存和读取数据不能用同一个 match 了，所以笔者姑且把对内存的读取换成了 `InsB0 (op, args) :: _` 的匹配

> [!note] 这个问题在新的版本已经修复了

然后涉及到位移的话必须要有针对内存的操作，我单独设置了一个 `read_data` 和 `save_data` 分别针对 `m` 的状态存放 `data` 到操作数 `dest`  
并且抽象出针对地址的 `read_data_addr` 和 `save_data_addr` 用来抽象出针对 `Ind` 寻址的存储，然后在解析的时候编写了一个用来解包参数用的函数。

做完了读取和转译，也编写好了工具函数，接下来的 parse 就非常公式化了，对每一个指令无非就是以下几个过程：

- 匹配
- 获取操作数
- 按照指令看是否解析操作数
- 执行指令，更新内存等
- 设置 flags 等

需要注意的是，在我们下发的文件里面含有了对于 `Int64` 的基本操作的工具模块，只需要 `let open Int64_overflow in` 即可使用模块，返回值包含 `value : int64` 和 `overflow : bool` 两部分

最后则是让整个模拟器正常运行，首先你可能需要设置栈顶指针的初始位置，并且注意每次运行 `step` 之后都要更新 `rip` 寄存器的值，这样就可以正常运行了。

> [!note] 附上新版更新后笔者的实现顺序
> 
> - `map_addr`
> - Read / Write
> - `fechins`
> - `validate_operands`
> - `crack`
> - Interpreate basic implement
> - Fix known issues
 
## Part II: X86lite Assembler and Loader

### 简介

这一部分将会编写一个 Assembler 和 Loader，Assembler 将助记符转换为机器码，并且将符号、标签转换为地址。

在下发的代码中是这样：

```ocaml
let assemble (p : prog) : exec = failwith "assemble unimplemented"
```

```ocaml
type elem = { lbl: lbl; global: bool; asm: asm }
```

而 `prog` 是 `elem list` 的 alias ，而 `exec` 的定义如下

```ocaml
(* A representation of the executable *)
type exec = {
  entry : quad; (* address of the entry point *)
  text_pos : quad; (* starting address of the code *)
  data_pos : quad; (* starting address of the data *)
  text_seg : sbyte list (* contents of the text segment *);
  data_seg : sbyte list (* contents of the data segment *);
}
```

如何实现？参考的步骤如下：

- 分离 `text` 和 `data` 两个段
- 计算两个堆的大小（`Asciz` 的大小是 `strlen + 1`）
- 解析 `label` 和地址，并且用 Immediate 替换掉代码里出现的标签
- 堆从最低地址开始，首先是 `text` 然后是 `data`

还给了一个 HINT，善用 `List.fold_left` 和 `List.fold_right`

> [!info] `gtext` 与 `text`
> 
> 在汇编层面上没有本质区别，但是带有 `.global` 的标记的能够被外部程序导入，例如 C 语言中的 `extern` 等。