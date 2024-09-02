---
share: true
---

# Lec.9 离散对数

## 前置知识

### 阶（元素的阶）

> [!warning] 
> 
> 在抽象代数中，这里的「阶」就是模 $m$ 的缩剩余系关于乘法形成的群中，**元素 $a$ 的阶**。记号 $\delta$ 表示阶也只用于这个特殊的群。
> 
> 参见：[DM.9 > 阶](DM.9.md)

> [!definition] Order
> **群的阶**：群 $G$ 的阶是它元素的个数，记作 $\operatorname{ord}(G)$ 或 $|G|$ ，无限群有无限阶。
> 
> **群内元素的阶**：群 $G$ 内的一个元素 $a$ 的阶是使 $a^m=e$ 成立的最小正整数 $m$ ，记作 $\operatorname{ord}(a)$ 或 $|a|$ ，等于 $\operatorname{ord}(\langle a\rangle)$ 。若这个数不存在，则称 $a$ 有无限阶。有限群的所有元素都有有限阶。

由欧拉定理可知，对 $a \in \mathbf{Z} ， m \in \mathbf{N}^*$ ，若 $(a, m)=1$ ，则 $a^{\varphi(m)} \equiv 1(\bmod m)$.

因此满足同余式 $a^n \equiv 1 (\bmod m)$ 的最小正整数 $n$ 存在，这个 **$n$ 称作 $a$ 模 $m$ 的阶**，记作 $\delta_m(a)$ 或 $\operatorname{ord}_m(a)$.

下面的诸多性质可以直接扩展到抽象代数中阶的性质。

**性质**

- $a, a^2, \cdots, a^{\delta_m(a)}$ 模 $m$ 两两不同余。
- 若 $a^n \equiv 1(\bmod m)$ ，则 $\delta_m(a) \mid n$.
- 设 $m \in \mathbf{N}^* ， a, b \in \mathbf{Z} ，(a, m)=(b, m)=1$ ，则  
	$$
	\delta_m(a b)=\delta_m(a) \delta_m(b)
	$$  

	的充分必要条件是  
	$$
	\left(\delta_m(a), \delta_m(b)\right)=1
	$$
- 设 $k \in \mathbf{N} ， m \in \mathbf{N}^* ， a \in \mathbf{Z} ，(a, m)=1$ ，则  
	$$
	\delta_m\left(a^k\right)=\frac{\delta_m(a)}{\left(\delta_m(a), k\right)}
	$$

### 原根（循环群的生成元）

> [!warning] 
> 
> 在抽象代数中，原根就是**循环群的生成元**。这个概念只在模 $m$ 的缩剩余系关于乘法形成的群中有「原根」这个名字，在一般的循环群中都称作**「生成元」**。
> 
> 并非每个模 m 缩剩余系关于乘法形成的群都是循环群，存在原根就表明它同构于循环群，如果不存在原根就表明不同构。

> [!definition] 
> 
> 设 $m \in \mathbf{N}^* ， g \in \mathbf{Z}$. 若 $(g, m)=1$ ，且 $\delta_m(g)=\varphi(m)$ ，则称 $g$ 为模 $m$ 的原根。  
> 即 $g$ 满足 $\delta_m(g)=\left|\mathbf{Z}_m^*\right|=\varphi(m)$. 当 $m$ 是质数时，我们有 $g^i \bmod m, 0<i<m$ 的结果互不相同。

#### 原根判定定理

> [!theorem] 
> 设 $m \geqslant 3,(g, m)=1$ ，则 $g$ 是模 $m$ 的原根的充要条件是，对于 $\varphi(m)$ 的每个素因数 $p$ ，都有 $g^{\frac{\varphi(m)}{p}} \not \equiv 1(\bmod m)$

#### 原根存在定理

> [!theorem] 
> 一个数 $m$ 存在原根当且仅当 $m=2,4, p^\alpha, 2 p^\alpha$ ，其中 $p$ 为奇素数， $\alpha \in \mathbf{N}^*$.

## 离散对数

> [!definition] DLOG
> 设 $G=\langle g\rangle$ 为阶数为 $q$ 的循环群. 对所有 $h \in G$, 若存在 $x \in\{0,1, \ldots, q-1\}$ 使得 $h=g^x$. 则整数 $x$ 称为 $h$ 对 $g$ 的离散对数 ( Discrete Log of $h$ with respect to $g$, 
**DLOG**) .  
> 记为: $x=\log _g h$i

### DLOG 问题, CDH 问题

> **DLOG Problem**: $G=\langle g\rangle$ 是 $q$ 阶循环群
> - Input: $q, G, g$ and $h \in G$; Output: $\log _g h$

> **CDH Problem**: **C**omputational **D**iffie-**H**ellman
> - Input: $q, G, g$ and $A=g^a, B=g^b$ for $a, b \leftarrow\{0,1, \ldots, q-1\}$; Output: $g^{a b}$

**DLOG 和 CDH 的复杂度**: If $p=2 q+1$ is a **safe prime** and $G$ is the order $q$ subgroup of $\mathbb{Z}_p^*$, then the best known algorithm for DLOG/CDH runs in time $\exp (O(\sqrt{\ln q \ln \ln q})) \cdot / / q \approx 2^{2048}$

## Diffie-Hellman Key Exchange

1. 爱丽丝和鲍伯协商一个有限循环群 $G$ 和它的一个生成元 $g$ 。 (这通常在协议开始很久以前就已经规定好; $g$ 是公开的，并可以被所有的攻击者看到。)
2. 爱丽丝选择一个随机自然数 $a$ 并且将 $g^a \bmod p$ 发送给鲍伯。
3. 鲍伯选择一个随机自然数 $b$ 并且将 $g^b \bmod p$ 发送给爱丽丝。
4. 爱丽丝计算 $\left(g^b\right)^a \bmod p$ 。
5. 鲍伯计算 $\left(g^a\right)^b \bmod p$ 。

爱丽丝和鮑伯就同时协商出群元素 $g^{a b}$ ，它可以被用作共享秘密。 $\left(g^b\right)^a$ 和 $\left(g^a\right)^b$ 因为群是乘法交换的。

例如：

下列过程分别用不同颜色标出了$\textcolor{Cyan}{ 公开的内容 }和\textcolor{orange}{ 私密的内容 }$

1. 爱丽丝与鲍伯协定使用 $\textcolor{Cyan}{ p=23 }$ 以及 base $\textcolor{Cyan}{ g=5 }$.
2. 爱丽丝选择一个秘密整数 $\textcolor{orange}{ a=6 }$ ，计算 $\textcolor{Cyan}{ A }=\textcolor{Cyan}{ g }^\textcolor{orange}{ a } \bmod \textcolor{Cyan}{ p }$ 并发送给鲍伯。
	- $\textcolor{Cyan}{ A }=\textcolor{Cyan}{ 5 }^\textcolor{orange}{ 6 } \bmod \textcolor{Cyan}{ 23 }=\textcolor{Cyan}{ 8 }$ .
3. 鲍伯选择一个秘密整数 $\textcolor{orange}{ b=15 }$ ，计算 $\textcolor{Cyan}{ \mathrm{B} }=\textcolor{Cyan}{ g }^{\textcolor{orange}{ b }} \bmod \textcolor{Cyan}{ p }$ 并发送给爱丽丝。
	- $\textcolor{Cyan}{ B }=\textcolor{Cyan}{ 5 }^{\textcolor{orange}{ 15 }} \bmod \textcolor{Cyan}{ 23 }=\textcolor{Cyan}{ 19 }$ .
4. 爱丽丝计算 $\textcolor{orange}{ s }=\textcolor{Cyan}{ B }^\textcolor{orange}{ a } \bmod \textcolor{Cyan}{ p }$
	- $\textcolor{orange}{ 19 }^\textcolor{Cyan}{ 6 } \bmod \textcolor{orange}{ 23 }=\textcolor{Cyan}{ 2 }$.
5. 鲍伯计算 $\textcolor{orange}{ s }=\textcolor{Cyan}{ A }^\textcolor{orange}{ b } \bmod \textcolor{Cyan}{ p }$
	- $\textcolor{orange}{ 8 }^{\textcolor{Cyan}{ 15 }} \bmod \textcolor{orange}{ 23 }=\textcolor{Cyan}{ 2 }$

于是两人得到了公共秘密 $2$

一旦爱丽丝和鲍伯得出了公共秘密，他们就可以把它用作对称密钥，以进行双方的加密通讯，因为这个密钥只有他们才能得到。

| 爱丽丝 |  | 鲍伯 |  | 伊芙 |  |
| :---: | :---: | :---: | :---: | :---: | :---: |
| 知道 | 不知道 | 知道 | 不知道 | 知道 | 不知道 |
| $p=23$ |  | $p=23$ |  | $p=23$ |  |
| base $\mathrm{g}=5$ |  | base $\mathrm{g}=5$ |  | base $\mathrm{g}=5$ |  |
| $a=6$ |  |  | $a=6$ |  | $a=6$ |
|  | $b=15$ | $b=15$ |  |  | $b=15$ |
| $A=5^6 \bmod 23=8$ |  | $B=5^{15} \bmod 23=19$ |  | $A=5^a \bmod 23=8$ |  |
| $B=5^b \bmod 23=19$ |  | $A=5^a \bmod 23=8$ |  | $B=5^b \bmod 23=19$ |  |
| $s=19^6 \bmod 23=2$ |  | $s=8^{15} \bmod 23=2$ |  | $s=19^a \bmod 23$ |  |
| $s=8^b \bmod 23=2$ |  | $s=19^a \bmod 23=2$ |  | $s=8^b \bmod 23$ |  |
| $s=19^6 \bmod 23=8^b \bmod 23$ |  | $s=8^{15} \bmod 23=19^a \bmod 23$ |  | $s=19^a \bmod 23=8^b \bmod 23$ |  |
| $s=2$ |  | $s=2$ |  |  | $s=2$ |

## 组合数学

### 基本概念

- 集合 set
- 函数（映射 map）
	- 单射（injective） $f(a)=f(b) \implies a = b$ / 每一个自变量单独对应一个值
	- 满射（surjective） $f(A) = B$ / 每一个值都能映射到一个自变量
	- 双射：单射+满射 / 每一个值和自变量都**一一对应**
- 基数（Cardinality）
	- $|A|$: $A$ 中元素个数
		- ==>有限、无限集
	- $|A| = |B|$ / 基数**相同**：存在双射 $f: A \to B$
	- $|A| \leq |B|$ ：存在单射 $f: A \to B$
		- 如果 $|A| \leq |B| \cap |A| \neq |B|$，则我们称为 $|A| < |B|$
	- 定理
		- $|A| = |A|$
		- $|A| = |B| \implies |B| = |A|$
		- $|A| = |B| \cap |B| = |C| \implies |A| = |C|$
	- 例子
		- $\left|\mathbb{Z}^{+}\right|=|\mathbb{N}|=|\mathbb{Z}|=\left|\mathbb{Q}^{+}\right|=|\mathbb{Q}|$
			- $\mathbb{Z}^{+}\xrightarrow{x\mapsto x-1}\mathbb{N}$
			- $\mathbb{Z}\xrightarrow{f(x):\;2x(x\geq 0);\ -(2x+1)(x<0) }\mathbb{N}$
			- $\mathbb{Z}^{+}\xrightarrow{} \mathbb{Q}^{+}$:![../res/Pasted image 20240401211424.png](../res/Pasted%20image%2020240401211424.png)
		- $\left|\mathbb{R}^{+}\right|=|\mathbb{R}|=|(0,1)|=|[0,1]|$
			- $f: \mathbb{R} \rightarrow \mathbb{R}^{+} x \mapsto 2^x$
			- $f:(0,1) \rightarrow \mathbb{R} x \mapsto \tan (\pi(x-1 / 2))$
			- $f:[0,1] \rightarrow(0,1)$
				- $f(1)=2^{-1}, f(0)=2^{-2}, f\left(2^{-n}\right)=2^{-n-2}, n=1,2,3, \ldots$
				- $f(x)=x$ for all other $x$
		- $|(0,1)| \neq\left|\mathbb{Z}^{+}\right|$
			- Suppose that $|(0,1)|=\left|\mathbb{Z}^{+}\right|$. Then there is a bijection $f: \mathbb{Z}^{+} \rightarrow(0,1)$
				- ![../res/Pasted image 20240401215326.png](../res/Pasted%20image%2020240401215326.png)
			- Let $b_i=\left\{\begin{array}{l}4, b_{i i} \neq 4 \\ 5, b_{i i}=4\end{array}\right.$ for $i=1,2,3, \ldots$
			- $b=0 . b_1 b_2 b_3 b_4 b_5 b_6 b_7 b_8 b_9 \cdots$ is in $(0,1)$ but has no preimage
				- $b \neq f(i)$ for every $i=1,2, \ldots$
			- $f$ cannot be a bijection