---
share: true
---

# 编译原理 - Lecture 3

> 本笔记适用于
> 
> - UPENN CIS 3410/7000
> - ShanghaiTech CS 131 2024+
> - Havard CS 153

## X86Lite

- X86 太复杂了，我们使用 X86 Lite
- 比起完整的 X86，它
	- 只有 64 位有符号整数（没有其他位数，没有浮点数）
	- 只有 20 个指令（真少啊，我在 TuringComplete 里面搭的 CPU 都有 20 个指令（逃））
	- 作为一般计算的目标语言完全足够了

> ![../res/Pasted image 20240923001023.png](../res/Pasted%20image%2020240923001023.png)
> 
> X86 示意图

于是我们来了解一下这个结构和基本汇编

（回来了，都回来了，我亲爱的~~CA课程~~图灵完备）

### 寄存器

16 x 64-bit reg

- `rax` general purpose accumulator
- `rbx` base register, pointer to data
- `rcx` counter register for strings & loops
- `rdx` data register for I/O
- `rsi` pointer register, string source register
- `rdi` pointer register, string destination register
- `rbp` base pointer, points to the stack frame
- `rsp` stack pointer, points to the top of the stack
- `r08`-`r15` general purpose registers

以及一个特殊的寄存器

- `rip` a “virtual” register, points to the current instruction
	- `rip` is modified only indirectly via jumps and return, but it can be
mentioned as a register elsewhere

### 操作数

- `Imm` Immediate, 64-bit literal signed intege
- `Lbl` Label, representing address, solved by the assembler/linker/loade
- `Reg` Register, has contents
- `Ind` Indirect Address, `addr(Ind) = (Base + [Index * Scale]) + Disp`, contains
	- Base
	- Index \* Scale ==(Index 不能为 `rsp`，是否和栈生长方向有关)==
	- Disp: const
- 例如：
	- `-4(%rsp) = rsp - 4`
	- `(%rax, %rcx, 4) = rax + 4 * rcx + 0`
	- `12(%rax, %rcx, 4) = rax + 4 * rcx + 12`

### 内存模型

- 内存地址: $2^{64}$ bytes - `0x00000000` ~ `0xffffffff`
- Quadword-aligned: 四字节对齐==(地址能被 8 整除)==
- 栈顶指针 `rsp` 指向栈顶（地址最低处），栈根据习俗生长方向从高到低

### 指令

#### `mov`

```asm
movq SRC, DEST
```

- 将 SRC(value: content / immediate) 复制到 DEST(location: reg/mem addr)
- SRC, DEST 都是 **操作数（Operands）**
- Example:
	- `movq $4, %rax` // move the 64-bit immediate value 4 into `rax`
	- `movq %rbx, %rax` // move the contents of `rbx` into `rax`

> [!info] AT&T notation VS Intel notation
> 
> ***AT&T Notation:***
> 
> ```asm
> mov $5, %rax
> mov $5, %eax
> ```
> 
> - `INST src, dest`
> - 流行于 Unix / Mac
> - Immediate: `$`
> - Register: `%`
> - Mnemonic suffix
> 	- **`q` quadword (4 words, 64-bit)**
> 	- `l` long (2 words, 32-bit)
> 	- `w` word (16-bit)
> 	- `b` byte (8-bit)
> 
> ***Intel Notation***
> 
> - `INST dest, src`
> - 常见于 Wintel
> - 指令变体由寄存器名称决定

#### Arithmetic

- `negq DEST` 负（二进制补码）
- `addq SRC, DEST` 加
- `subq SRC, DEST` 减
- `imulq SRC, Reg` 乘 （`Reg` <- `Reg` \* `SRC`，128-bit 截断）

#### Logic/Bit

- `notq DEST`
- `andq SRC, DEST`
- `orq SRC, DEST`
- `xorq SRC, DEST`
- `sarq Amt, DEST` (`>>`，有符号)
- ==`shlq Amt, DEST` (`<<`，无符号)==
- `shrq Amt, DEST` (`>>>`，无符号)

#### Memory

- `leaq Ind, DEST` `DEST` <- `addr(Ind)` 向 `DEST` 加载一个指针
- `pushq SRC` = `rsp -= 8` + `Mem[rsp] = SRC`
- `popq DEST` = `DEST = Mem[rsp]` + `rsp += 8`

#### Conditional

> [!note] 标志位
> - 标志位：记录了与最近的一次算术或逻辑操作结果有关的信息
> - X86 指令会在执行时设置 **标志（Flags）**，作为副作用
> - Flags
> 	- `OF` Overflow, 对于 64-bit reg 太大/太小时设置
> 	- `SF` Sign, 由结果的符号设置（0=正数，1=负数）
> 	- `ZF` Zero, 当结果为0时设置
> - 据此可以定义出条件代码（以下完全指令为`CC SRC1, SRC2`，实际上是根据 `SRC1 - SRC2` 的 Flag 判别）

> [!note] 条件代码 (`CC`)
> - `eq SRC1, SRC2`, equality => `ZF`
> - `neq SRC1, SRC2`, not equality => `!ZF`
> - `gt SRC1, SRC2`, greater than => `!le` <=> `(SF == OF) && (!ZF)`
> - `lt SRC1, SRC2`, less than => `SF != OF` <=> `(SF && !OF) || (!SF && OF)` ==细节：大到了溢出就是负数==
> - `ge SRC1, SRC2`, greater or equal => `!lt` <=> `(SF == OF)`
> - `le SRC1, SRC2`, less or equal => `(SF != OF) || ZF`

由此定义出

- `comq SRC1, SRC2`, compute,  计算 `SRC2 - SRC1` 并设置标志（不会存储结果）
- `setbCC DEST` 设置 `DEST` 的最低字节为 `CC` 结果（`b(DEST) = if CC then 1 else 0`）
- `jCC DEST` 跳转（设置 `rip = if CC then SRC else fallthrough`）

所以一次成功的条件跳转 / 设置低位的方式需要两步，例如

```asm
comq %rcx, %rax // Compare rcx to rax
je __truelbl // If rcx == rax then jump to __trueklbl
```

#### Jump, Call, Return

- `jmp SRC`, jump 相当于 `rip = SRC`
- `callq SRC`, call function, 区别就是会压栈和返回，相当于 `Push(rip)` + `rip = SRC`，会导致 `rsp --`
- `retq`, return, 就是从出栈复原（无返回值），相当于 `rip = Pop()`，会导致 `rsp ++`

### 代码块，标签

```asm
label1:
	instruction1
	...

label2:
	instruction2
	...
```

- 标签（Labels）可以作为 jump 的目标（条件/调用）
- 标签由 Linker 和 Loader 翻译 - 指令位于“代码段”的堆中（也就是 `PHYS_BASE` 上的第一段，详情复习 OS 的内存结构）
- X86 程序从指定的代码标签（通常是 `main`）开始执行