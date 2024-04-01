---
share: true
---

# 群

文章部分摘自：https://oiwiki.org/math/group-theory/

## 群 - Group

> [!definition] 
> **群**（group）是由一种集合以及一个二元运算所组成的，符合「群公理」的代数结构。

一个群是一个集合 $G$ 加上对 $G$ 的二元运算。二元运算用. 表示，它结合了任意两个元素 $a$ 和 $b$ 形成了一个属于 $G$ 的元素，记为 $a \cdot b$ 。

### 群公理
群公理包含下述四个性质（有时略去封闭性，只有三个性质）。若集合 $G \neq \varnothing$ 和 $G$ 上的运算 $\cdot$ 构成的代数结构 $(G, \cdot)$ 满足以下性质:

> [!axiom] 群公理
> 1. **封闭性**: 对于所有 $G$ 中 $a, b$ ，运算 $a \cdot b$ 的结果也在 $\mathrm{G}$ 中。
> 2. **结合律** (associativity)：对于 $G$ 中所有的 $a, b, c$ ，等式 $(a \cdot b) \cdot c=a \cdot(b \cdot c)$ 成立。
> 3. **单位元** (identity element，也称幺元) : $G$ 中存在一个元素 $e$ ，使得对于 $G$ 中的每一个元素 $a$ ，都有一个 $e \cdot a=a \cdot e=a$ 成立。这样的元素是独一无二的。它被称为群的单位元。
> 4. **逆元** (inverse element)：对于每个 $G$ 中的 $a$ ，总存在 $G$ 中的一个元素 $b$ 使 $a \cdot b=b \cdot a=e$ ，此处 $e$ 为单位元，称 $b$ 为 $a$ 的逆元，记为 $a^{-1}$ 。

则称 $(G, \cdot)$ 为一个群。例如，整数集和整数间的加法 $(\mathbb{Z},+)$ 构成一个群，单位元是 0 ，一个整数的逆元是它的相反数。

### 群的衍生结构

- 若代数结构 $(G, \cdot)$ 满足封闭性、结合律性质，则称 $(G, \cdot)$ 为一个半群 (semigroup)。
- 若半群 $(G, \cdot)$ 还满足单位元性质，则称 $(G, \cdot)$ 为一个幺半群 (monoid)。
- 若群 $(G, \cdot)$ 还满足 **交换律** (commutativity)：对于 $G$ 中所有的 $a, b$ ，等式 $a \cdot b=b \cdot a$ 成立。则称 $(G, \cdot)$ 为一个 ==**阿贝尔群** (Abelian group)==，又称 交换群 (commutative group)。

#### 阿贝尔群

常见有加法群和乘法群

- **Additive Group**: binary operation + ; identity 0
	- Example: $(\mathbb{Z},+),(n \mathbb{Z},+),(\mathbb{Q},+),\left(\mathbb{Z}_n,+\right)$
- **Multiplicative Group**: binary operation $\cdot ;$ identity $1 / /\left(\mathbb{Z}_n^*, \cdot\right)$
	- Example: $\left(\mathbb{Q}^*, \times\right),(\{ \pm 1\}, \times),\left(\mathbb{Z}_n^*, \cdot\right)$

#### $\mathbb{Z}_{n}^*$ 群

- $\mathbb{Z}_{n}^*$ 为交换（阿贝尔）群

> [!theorem] $\mathbb{Z}_n^*$ is an *Abelian group* for any integer $n>1$.
> - Closure: $\forall[a]_n,[b]_n \in \mathbb{Z}_n^*,[a]_n \cdot[b]_n=[a b]_n \in \mathbb{Z}_n^*$
> - Associative: $\forall[a]_n,[b]_n,[c]_n \in \mathbb{Z}_n^*,[a]_n \cdot\left([b]_n \cdot[c]_n\right)=[a b c]_n=\left([a]_n \cdot[b]_n\right) \cdot[c]_n$
> - Identity element: $\exists[1]_n \in \mathbb{Z}_n^*, \forall[a]_n \in \mathbb{Z}_n^*,[a]_n \cdot[1]_n=[1]_n \cdot[a]_n=[a]_n$
> - Inverse: $\forall[a]_n \in \mathbb{Z}_n^*, \exists[s]_n \in \mathbb{Z}_n^*$ such that $[a]_n \cdot[s]_n=[s]_n \cdot[a]_n=[1]_n$
> - Commutative: $\forall[a]_n,[b]_n \in \mathbb{Z}_n^*,[a]_n \cdot[b]_n=[a b]_n=[b a]_n=[b]_n \cdot[a]_n$

## 环* - Ring

环是域的基础，故在此放上

> [!definition] Ring
> 形式上，**环** (ring) 是一个集合 $R$ 及对 $R$ 的两个二元运算：加法 + 和乘法. (注意这里不是我们一般所熟知的四则运算加法和乘法) 所组成的，且满足如下性质的代数结构 $(R,+, \cdot)$ :
> 1. $(R,+)$ 构成**交换群**，其单位元记为 $0 ， R$ 中元素 $a$ 的加法逆元记为 $-a_0$
> 	- 封闭+结合+单位+逆元+交换
> 2. $(R, \cdot)$ 构成**半群**。
> 	- 封闭+结合
> 3. **分配律** (distributivity)：对于 $R$ 中所有的 $a, b, c$ ，等式 $a \cdot(b+c)=a \cdot b+a \cdot c$ 和 $(a+b) \cdot c=a \cdot c+b \cdot c$ 成立。

### 环的衍生结构

- 若环 $R$ 上的乘法还满足交换律，则称 $R$ 为 **交换环** (commutative ring)。
- 若环 $R$ 存在乘法单位元 1 ，则称 $R$ 为 **幺环** (ring with identity)。
- 若么环 $R$ 的所有非 0 元素 $a$ 存在乘法逆元 $a^{-1}$ ，则称 $R$ 为 **除环** (division ring)。

## 域 - Field

**域**（field）是一个比环性质更强的代数结构，具体地，**域是交换除环**。

> [!definition] Field
> **域** 是一个集合 $\mathbb{F}$ 与两个二元运算符 $+$, $\cdot$ 且满足如下性质
> 
> - $\mathbb{F}$ 对 $+$ 为**交换群**
> - $\mathbb{F} \backslash 0$ 对 $\cdot$ 为 **交换群**
> - **分配律** (Distributivity)：$\forall a, b, c \in \mathbb{F}, a \cdot(b+c)=a b+a c$

> [!note] 
> 加法单位元 $0$, 乘法单位元 $1$

例如：
- $(\mathbb{R},$ $+,$ $\cdot)$
- $(\mathbb{Z}_{p},$ $+,$ $\cdot)$ 其中 $p$ 是质数，且
	- $+,$ $\cdot$ 均为剩余类计算

### 有限域 - Finite field

> [!definition] Finite field
> 含有有限个元素

## $\mathbb{Z}_{p}$ 上的多项式

## 群的基本概念

### 阶 - Order

> [!definition] Order
> **群的阶**：群 $G$ 的阶是它元素的个数，记作 $\operatorname{ord}(G)$ 或 $|G|$ ，无限群有无限阶。
> 
> **群内元素的阶**：群 $G$ 内的一个元素 $a$ 的阶是使 $a^m=e$ 成立的最小正整数 $m$ ，记作 $\operatorname{ord}(a)$ 或 $|a|$ ，等于 $\operatorname{ord}(\langle a\rangle)$ 。若这个数不存在，则称 $a$ 有无限阶。有限群的所有元素都有有限阶。

例如：$\left|\mathbb{Z}_n\right|=n,\left|\mathbb{Z}_p^*\right|=p-1,|\mathbb{Z}|=\infty$

> [!example] 
> Determine the orders of all elements of $\mathbb{Z}_7^*$ and $\mathbb{Z}_6$
> - $\mathbb{Z}_7^*=\{1,2,3,4,5,6\},$ $o(1)=1 ; o(2)=o(4)=3 ; o(3)=o(5)=6 ; o(6)=2$
> - $\mathbb{Z}_6=\{0,1,2,3,4,5\},$ $o(0)=1, o(1)=o(5)=6, o(2)=o(4)=3, o(3)=2$

> [!theorem] 
> 
> 群中任意元素的阶一定整除群的阶（拉格朗日定理推出）
> 
> - Let $G$ be a multiplicative Abelian group of order $m$. Then for any $a \in G, a^m=1$.  
> 	乘法交换群中 $e=1$

### 子群 - Subgroup

> [!definition] Subgroup
> 
> 群 $(G, \cdot),(H, \cdot)$ ，满足 $H \subseteq G$ ，则 $(H, \cdot)$ 是 $(G, \cdot)$ 的子群。

**子群** 是包含在更大的群 $G$ 内的一个群 $H_{\text {。 }}$ 它具有 $G$ 的元素的子集和相同操作。这意味着 $G$ 的单位元素必须包含在 $H$ 中，并且每当 $h_1$ 和 $h_2$ 都在 $H$ 中，那么 $h_1 \cdot h_2$ 和 $h_1^{-1}$ 也在 $H$ 中。所以 $H$中的元素，和在 $G$ 上的限制为 $H$ 的群操作，形成了一个群体。

即，若 $(G, \cdot)$ 是群， $H$ 是 $G$ 的非空子集，且 $(H, \cdot)$ 也是群，则称 $(H, \cdot)$ 是 $(G, \cdot)$ 的 子群。

> [!note] 子群检验法
> 
> **子群检验法**（subgroup test）是群 $G$ 的子集 $H$ 是子群的**充分必要条件**：
> 
> 对于所有元素 $g, h \in H$ ， $g^{-1} \cdot h \in H_{\text {。 }}$

例如：
- 对于乘法：$G=\mathbb{Z}_6^*=\{1,5\}, H=\{1\}$
- 对于加法：$G=\mathbb{Z}_6=\{0,1,2,3,4,5\} ; H=\{0,2,4\}$

> [!theorem] 
>  Let $(G, \cdot)$ be an Abelian group. Let $\langle g\rangle=\left\{g^k: k \in \mathbb{Z}\right\}$ be a subset of $G$, where $g \in G$. Then $\langle g\rangle \leq G$.  

### 循环群 - Cyclic group

> [!definition] Cyclic group
> **循环群** (cyclic group，记作 $C_n$ ) 是最简单的群。群 $G$ 中任意一个元素 $a$ 都可以表示为 $a=g^k$ ，其中 $k$ 为整数。  
> （或 $\exists g \in G \implies G= \left< g \right>$） 
> - 称 $g$ 为群 $G$ 的**生成元** (generator)。

- 例如：$\mathbb{Z}_{10}^*=\left\{[1]_{10},[3]_{10},[7]_{10},[9]_{10}\right\}=\left\langle[3]_{10}\right\rangle$
	- $g=[3]_{10}$
	- $g^0=[1]_{10}, g^1=[3]_{10}, g^2=[9]_{10}, g^3=[27]_{10}=[7]_{10}$

> [!theorem] 
> 生成元 $g$ 的阶就是群 $G$ 的阶

> [!theorem] 
> $\mathbb{Z}_{p}^{*}$ ($p$ 为质数) 是循环群

