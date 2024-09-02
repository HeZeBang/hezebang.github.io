---
dg-publish: true
share: true
---


# Verilog HDL 语言

## 基本流程

![../../res/Pasted image 20240204220938.png](../../res/Pasted%20image%2020240204220938.png)

- 名词解释
	- HDL / Hardware Description Language：硬件描述性语言
	- RTL / Register Transfer Level：寄存器传输级，根据寄存器间的信号流动和电路逻辑来记录动作的一种设计模型
	- 逻辑综合：将 RTL 级别的抽象电路转换到门电路级别的电路网表
- 若电路验证失败 / 逻辑综合结果无法满足约束条件（无法收敛）：更正设计参数，重新开始

## 电路描述

```verilog
module <模块名> (
	<输入输出信号的定义>,
	...);
	
	<电路描述>
	
endmodule
```

### 例子：加法器

![../../res/Pasted image 20240204221623.png](../../res/Pasted%20image%2020240204221623.png)

```verilog
module adder (
    input  wire [31:0] in_0,  // 输入 0
    input  wire [31:0] in_1,  // 输入 1
    output wire [31:0] out    // 输出
);
    // in_0 和 in_1 相加后结果代入 out
    assign out = in_0 + in_1;
endmodule
```

### 基本语法

- 自由格式
- 标识符：`a-z`, `A-Z`, `0-9`, `_`, `$`
- 注释：`/*...*/`, `//...`
- 块：`begin` -> `end`

#### 信号声明

- 信号声明语法
	1. 信号类别
		- 输入 `input`
		- 输出 `output`
		- 双向 `inout`
	2. 数据类型
		- `wire` 型输入信号
	3. 信号线的位宽 `[最高位位置:最低位位置]` Most/Least Significant Bit
		- `[31:0]` = 32位信号
	4. 信号名

#### 电路描述

- `assign` 赋值

### 模块的实例化

```verilog
// 实例化上文定义的 adder
adder adder01 ( // 模块名 实例名
    .in_0 (adder01_in_0), // adder01_in_0 信号连接到 in_0 端口
    .in_1 (adder01_in_1), // adder01_in_1 信号连接到 in_1 端口
    .out  (adder01_out)   // adder01_out 信号连接到 out 端口
);
```

### 逻辑值与常数表达

#### 逻辑值

| 逻辑值 | 名称 | 含义 |
| :--- | :--- | :--- |
| `0` | Low | 数值 0 ( 接地 ) 与逻辑假 |
| `1` | High | 数值 1 (电源电压) 与逻辑真 |
| `x` | 不定值 | 无法确定值是 0 还是 1 |
| `z` | 高阻值 | 电气绝缘状态（无任何连接） |

#### 常数

必须指定位宽

![../../res/Pasted image 20240204222624.png](../../res/Pasted%20image%2020240204222624.png)

### 变量的声明与数据类型

![../../res/Pasted image 20240204222734.png](../../res/Pasted%20image%2020240204222734.png)

元素数省略默认元素数为 `1`

![../../res/Pasted image 20240902102241.png](../../res/Pasted%20image%2020240902102241.png)

- **数据类型**
	- 寄存器型
		- 可以保存上次写入数据的数据类型
		- 根据程序不同可以生成锁存器、触发器等存储元件，也可能生成组合电路
		- ![../../res/Pasted image 20240204222844.png](../../res/Pasted%20image%2020240204222844.png)
		- 在 `always` 和 `initial` 语句中实现**过程赋值**
	- 网络型
		- 用来描述模块和寄存器间**连接**的数据类型
		- 只描述信号的传输不持有数据
		- ![../../res/Pasted image 20240204223341.png](../../res/Pasted%20image%2020240204223341.png)
		- 可以在 `assign` 语句或*声明语句*中实现**连续赋值**
- **过程赋值** （Procedural Assignment）
	- 阻塞式赋值
		- 按照代码顺序进行赋值，先赋值的代码赋值完成之前阻塞后续代码的赋值
		- 使用 `=` 运算符
		- ![../../res/Pasted image 20240204223133.png](../../res/Pasted%20image%2020240204223133.png)
	- 非阻塞式赋值
		- 所有代码不会互相阻塞，同时进行赋值
		- 使用 `<=` 运算符
		- ![../../res/Pasted image 20240204223147.png](../../res/Pasted%20image%2020240204223147.png)
	- 在一个过程块中，阻塞式赋值和非阻塞式赋值只能**使用其中一种**
- **连续赋值**（Continuous Assignment）
	- 变量的符号用 `signed` 和 `unsigned` 关键字指定
		- 在**赋值**或**比较**等处理时，如果需要在有符号数和无符号数间进行**转换**，需要使用 `$signed()` 和 `$unsigned()` 系统任务（system task）
	- `assign` 语句中连续赋值
		- ![../../res/Pasted image 20240204223617.png](../../res/Pasted%20image%2020240204223617.png)
	- 声明语句中连续赋值
		- ![../../res/Pasted image 20240204223633.png](../../res/Pasted%20image%2020240204223633.png)

> [!note] 默认网格类型
> 
> 使用网络型变量时，如果定义默认网络类型，可以不用声明直接使用。
> 
> ![../../res/Pasted image 20240902103405.png](../../res/Pasted%20image%2020240902103405.png)
> 
> RTL 设计时为了规避默认网络类型的副作用，推荐将默认网络类型设置为无效。

#### 运算符

![../../res/Pasted image 20240902103512.png](../../res/Pasted%20image%2020240902103512.png)

- 缩减运算符的特点是对信号的每一位逐个进行位运算，最终输出 1 位的运算结果。

![../../res/Pasted image 20240902103531.png](../../res/Pasted%20image%2020240902103531.png)

![../../res/Pasted image 20240902103641.png](../../res/Pasted%20image%2020240902103641.png)

#### `if`, `case`

- 可以在 initial 或 always 语句声明的过程块中使用。
- `if`
	- ![../../res/Pasted image 20240902103835.png](../../res/Pasted%20image%2020240902103835.png)
- `case`
	- ![../../res/Pasted image 20240902103849.png](../../res/Pasted%20image%2020240902103849.png)

#### `for`, `while`

- 可以在 initial 或 always 语句声明的过程块中使用。
- `for`
	- ![../../res/Pasted image 20240902103948.png](../../res/Pasted%20image%2020240902103948.png)
- `while`
	- ![../../res/Pasted image 20240902104000.png](../../res/Pasted%20image%2020240902104000.png)

#### `always` 过程块

![../../res/Pasted image 20240902104039.png](../../res/Pasted%20image%2020240902104039.png)

- 事件表达式：所指定的事件触发时执行其中的语句序列
	- 事件可以是特定信号的变化、信号的上升沿（posedge）、信号的下降沿（negedge）等。
- 常数表达式：每经过该常数时间便执行一次 always 中的语句序列
- `always` 过程中可以使用寄存器变量赋值、`if`、`case`、`for`、`while` 等语句。

#### `always` 描述组合电路

![../../res/Pasted image 20240902104401.png](../../res/Pasted%20image%2020240902104401.png)

- 事件表达式：`*` （通配符）
	- 任何输入信号变化时都会执行过程块中的代码

> [!note] 组合电路描述中锁存器的推定与 Don’t care
> 
> 使用 always 语句描述组合电路时，如果信号未被赋值，有可能会引入锁存器。
> 
> 例如 `case` 中的未指定的情况会导致输出**保持**，而为了保持之前的值就需要存储元件。这时会生成异步的存储元件锁存器，变成时序电路。
> 
> 寄存器推定的发生原因是不完整的 case 语句或没有 else 的 if 语句。
> 
> **Best practice:** 使用 `default`, `else`，或确定不存在该情况（Don't Care），输出为逻辑综合时优化的数值。
> 
> Verilog HDL 中 Don’t care 的指示方法是在 default 中为输出赋予不定值。图 1-56 的示例中加入 Don’t care 指示的程序如图 1-57 所示。
> 
> ![../../res/Pasted image 20240902105015.png](../../res/Pasted%20image%2020240902105015.png)

#### `always` 描述时序电路

![../../res/Pasted image 20240902105059.png](../../res/Pasted%20image%2020240902105059.png)

> 示例中定义了一个叫做 `ff` ([flip-flop](./AZ.1.1.3%20%E6%95%B0%E5%AD%97%E7%94%B5%E8%B7%AF%E5%9F%BA%E7%A1%80.md#flip-flop)) 的模块，它有 `clk`、`reset_`、`d_in` 三个一位 `wire`型输入信号，和一位 `reg` 型输出信号 `d_out`。`d_out` 在 `clk` 的上升沿同步动作，将 `d_in` 的值储存。并且 `d_out` 在 `reset_` 的下降沿被异步地复位，初始化为 `0`。

- 含有触发器等存储元件
- 按照时钟同步执行 => 事件表达式中要指定时钟的信号边沿和时钟信号名
	- 时钟信号边沿
		- 信号上升时 `posedge`
		- 信号下降时 `negedge`
	- 时钟信号名
- 事件表达式可以使用 `or` 列举多个条件
- 为存储元件设置异步复位（`reset`）信号时，除了时钟信号还要写上复位信号的边沿和信号名

#### 预处理

- 在代码编译前对其进行预先处理的程序
- 可实现宏定义和条件编译
- 使用编译指示符可对编译器进行各种控制
	- ![../../res/Pasted image 20240902110422.png](../../res/Pasted%20image%2020240902110422.png)
	- 编译指示符以 ``` ` ``` 开头
	- 为了区分宏与变量名，宏的名称前也加有后引号 Eg. ``` `BYTE_DATA_W ```

#### 程序例

![../../res/Pasted image 20240902110911.png](../../res/Pasted%20image%2020240902110911.png)

> 本示例制作了 32 组位宽为 32 的寄存器堆。图 1-60 是寄存器堆的框图。寄存器堆中有作为存储的 32 个 32 位寄存器，以及读写寄存器序列用的接口。
> 
> 读取操作时将地址信号（`addr`）指定的寄存器的内容，通过多路选择器选择，输出到输出信号（`d_out`）。对于写入操作，当写入使能信号（`we_`）有效时，向地址信号（`addr`）指定的寄存器写入输入数据（`d_in`）。

![../../res/Pasted image 20240902111206.png](../../res/Pasted%20image%2020240902111206.png)

![../../res/Pasted image 20240902111220.png](../../res/Pasted%20image%2020240902111220.png)  
![../../res/Pasted image 20240902111229.png](../../res/Pasted%20image%2020240902111229.png)