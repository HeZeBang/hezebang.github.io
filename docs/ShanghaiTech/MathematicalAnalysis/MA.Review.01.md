---
share: true
---


> [!question]
> - 

## 极限
### 性质
- **唯一：** <b class="md-tag">收敛数列唯一性</b>  #极限唯一性  
- **局部：** 数列: 有限项不能改变数列的收敛性; 函数: $x_{0}$ 点处收敛性只需考察 $x_{0}$ 的邻域内
- **有界：** 数列: <b class="md-tag">收敛数列有界性</b> 收敛必有界; 函数: <b class="md-tag">局部有界性</b> $x_{0}$ 点处收敛 ⇒ $x_{0}$ 点附近有界 
- **保序：** 
	- <b class="md-tag">收敛数列保序性</b> $\lim x_{n}=a,\ \lim y_{n}=b,a < b \;\Rightarrow\; x_{n} < y_{n}$（$n$充分大时）
	- <b class="md-tag">极限局部保序性</b> 
	- 加强：保号性
		- <b class="md-tag">收敛数列保号性</b> 
			- $b>0:y_{n}>k \cdot b>0$（$n$充分大时）
			- $b<0:y_{n}<k \cdot b<0$（$n$充分大时）
			- $\Rightarrow|y_{n}|>k\cdot |b| > 0$
			- 理解：$y_{n}$ 与 $0$ 的距离不能任意小
			- ==适用于：==倒数取范围
		- <b class="md-tag">极限局部保号性</b> 
- **保四则运算** 除法运算中分母极限不为0

### 收敛/发散的证明

> [!quote]- Recall
> ![MA.1.2 数列极限](../../../MA.1.2%20%E6%95%B0%E5%88%97%E6%9E%81%E9%99%90.md#bc7721)
> ![MA.1.3 函数极限](../../../MA.1.3%20%E5%87%BD%E6%95%B0%E6%9E%81%E9%99%90.md#b0f285)
> ![MA.1.3 函数极限](../../../MA.1.3%20%E5%87%BD%E6%95%B0%E6%9E%81%E9%99%90.md#a548f4)
> ![MA.1.2 数列极限](../../../MA.1.2%20%E6%95%B0%E5%88%97%E6%9E%81%E9%99%90.md#ca5275)
> ![MA.1.2 数列极限](../../../MA.1.2%20%E6%95%B0%E5%88%97%E6%9E%81%E9%99%90.md#31cae5)
> ![MA.1.3 函数极限](../../../MA.1.3%20%E5%87%BD%E6%95%B0%E6%9E%81%E9%99%90.md#aa2b80)
> ![MA.1.2 数列极限](../../../MA.1.2%20%E6%95%B0%E5%88%97%E6%9E%81%E9%99%90.md#ebb8dd)
> ![MA.1.2 数列极限](../../../MA.1.2%20%E6%95%B0%E5%88%97%E6%9E%81%E9%99%90.md#d3b385)
> ![MA.1.2 数列极限](../../../MA.1.2%20%E6%95%B0%E5%88%97%E6%9E%81%E9%99%90.md#71d4d8)

#### 数列/函数收敛的证明方法

- <b class="md-tag">epsilon-N定义</b> #epsilon-delta定义 
- 数列: <b class="md-tag">单调有界定理</b> 
- <b class="md-tag">Cauchy收敛准则</b> / <b class="md-tag">Cauchy判别准则</b> 
- <b class="md-tag">夹逼定理</b> 
- <b class="md-tag">Stolz定理</b> #LHospital法则 
- 数列: 比值判别法

#### 数列/函数发散的证明方法

- <b class="md-tag">epsilon-N定义</b> #epsilon-delta定义 
- 无界
- <b class="md-tag">Cauchy收敛准则</b> / <b class="md-tag">Cauchy判别准则</b> 
- <b class="md-tag">子数列归并性定理</b> 

### <b class="md-tag">BW定理</b> 

![MA.1.2 数列极限](../../../MA.1.2%20%E6%95%B0%E5%88%97%E6%9E%81%E9%99%90.md#1b7b46)

### 函数极限与数列极限的关系—— <b class="md-tag">Cauchy判别准则</b> / <b class="md-tag">Heine归并定理</b>

$\lim\limits_{x\to x_{0}}f(x)=l \Leftrightarrow \forall x_{n}\to x_{0}(x_{n}\ne x_{0}),\lim\limits_{n\to +\infty}f(x_{n})=l.$

$l$ 可以是有限数，也可以是无穷

---

#Heine归并定理  $f(x)已知极限\Rightarrow f采样~有极限$
在求数列极限时，若表达式明确，则可对其连续化。

![MA.1.3 函数极限](../../../MA.1.3%20%E5%87%BD%E6%95%B0%E6%9E%81%E9%99%90.md#91bb61)

---

$自变量接近\Rightarrow 函数值接近$

![MA.1.3 函数极限](../../../MA.1.3%20%E5%87%BD%E6%95%B0%E6%9E%81%E9%99%90.md#dce2c1)

### 函数极限的相容性

$\lim\limits_{x\to x_{0}}f(x)=l,~\lim\limits_{t\to t_{0}}g(t)\xrightarrow{g(t)\ne x_{0},t\ne t_{0}}\lim\limits_{t\to }f(g(t))=l$

### 概念区别

$发散\supset无界\supset无穷大$

## 连续

### 某点连续

![MA.2.1 连续函数](../../../MA.2.1%20%E8%BF%9E%E7%BB%AD%E5%87%BD%E6%95%B0.md#7da1c3)

#### 性质

- **保邻近：**（局部性质）$\lim\limits_{x\to x_{0}}f(x)=f(x_{0})$
- **换次序：** <b class="md-tag">连续函数极限的穿越</b> $\lim\limits_{x\to x_{0}}f(x)=f(\lim\limits_{x\to x_{0}}x)$
- **离散判别：**$对x_{n}\to x_{0}且x_{n}\ne x_{0},有\lim\limits_{n\to +\infty}f(x_{n})=f(x_{0})$
- **左右连续：**$\lim\limits_{x\to x_{0}^{-}}f(x)=f(x_{0})=\lim\limits_{x\to x_{0}^{+}}f(x)$
- **保四则运算**
- **保复合运算**
- **极限与绝对值可交换：**$\lim\limits_{x\to x_{0}}|f(x)|=|\lim\limits_{x\to x_{0}}f(x)|$ ==逆命题不成立==

#### 第一类间断点

左右极限都存在
- <b class="md-tag">可去间断点</b> $\lim\limits_{x\to x_{0}^{-}}f(x)=\lim\limits_{x\to x_{0}^{+}}f(x)\ne f(x_{0})$
- <b class="md-tag">跳跃间断点</b> $\lim\limits_{x\to x_{0}^{-}}f(x)\ne\lim\limits_{x\to x_{0}^{+}}f(x)$
#### 第二类间断点

$\lim\limits_{x\to x_{0}^{-}}f(x) \text{ or }\lim\limits_{x\to x_{0}^{+}}f(x)$ 至少一个不存在

#### 连续函数存在反函数的充要条件：严格递增

### 闭区间上的连续函数

#### 性质

- <b class="md-tag">闭区间连续函数介值性</b> 
- <b class="md-tag">闭区间连续函数有界性</b> 
- <b class="md-tag">闭区间连续函数最值性</b> ：取到最大值、最小值；值域是闭区间
- <b class="md-tag">闭区间连续函数零值性</b> 
- <b class="md-tag">一致连续性</b> 

### $f$在区间$I$上一致连续

![MA.2.2 闭区间上连续函数的性质](../../../MA.2.2%20%E9%97%AD%E5%8C%BA%E9%97%B4%E4%B8%8A%E8%BF%9E%E7%BB%AD%E5%87%BD%E6%95%B0%E7%9A%84%E6%80%A7%E8%B4%A8.md#3ad3d1)
> 注：给定$\varepsilon>0,~对不同的x_{0},~\delta(\varepsilon,x_{0})可能不同$

#### $对任意 ε > 0, 一致由公共 δ 体现:$

- **一致连续:** $公共 δ, 即 δ = δ(ε).$
- **非一致连续:** $非公共 δ, 即 δ = δ(ε, x_{0})$

#### 等价命题

> [!proposition] <b class="md-tag">一致连续性/Cauchy判别准则形式</b>
>
> $\forall \varepsilon > 0, \exists \delta > 0, 对 \forall x_{1}, x_{2}\in I, 当|x_{1}-x_{2}|<\delta时, 有|f(x_{1})-f(x_{2})|<\varepsilon$

> [!proposition] <b class="md-tag">一致连续性/极限表达形式</b>
>
> $\lim\limits_{\delta\to 0^{+}} \sup|f(x_{1})-f(x_{2})|=0\cdots(\forall x_{1},x_{2}\in I, |x_{1}-x_{2}|<\delta)$

#### 连续与一致连续

> 一致连续：整体
> 连续：局部（逐点连续）

![MA.2.2 闭区间上连续函数的性质](../../../MA.2.2%20%E9%97%AD%E5%8C%BA%E9%97%B4%E4%B8%8A%E8%BF%9E%E7%BB%AD%E5%87%BD%E6%95%B0%E7%9A%84%E6%80%A7%E8%B4%A8.md#082aeb)

#### 一致连续的判别

- **常用判别法：** $若 f 在区间 I 上可导, 则 f' 有界\xrightarrow[\text{Lipschitz}]{微分中值定理}f在I上一致连续$
- **推广 1:** $若 f 在 [a, +∞] 上连续, 且对 ∀x_{0} > a, f' 在 [x_{0}, +\infty] 上有界,$ $则 f 在 [a, +∞]上一致连续. (如 f (x) = \sqrt x 在 [0, +∞) 上一致连续)$
- **推广 2:** $若 f 在 x_{0} 处连续,$ $且对 ∀a > 0,$ $f' 在 \mathbb R\backslash(x_{0} − a, x_{0} + a) 上有界, 则 f 在 \mathbb R 上一致收敛.$
- **命题 2:** $f 在 [a, +∞] 上连续且 \lim\limits_{x\to \infty}f (x) 存在 ⇒ f 在 [a, +∞] 上一致连续.$
- **命题 3:** $f 在 (a, b], [b, c) 上一致连续 ⇒ f 在 (a, c) 上一致连续.$
- **命题 4:** $f, g 在 [a, +∞) 上有界且一致连续 ⇒ f g 在 [a, +∞) 上一致连续.$
注意: 有界不能省略, 反例:$f (x) = g(x) = x, x ∈ R^{+}$. 若把无穷区间换成有区间, 则有界可省略, 因为有穷区间的一致连续性包含有界.
- **命题 5:** $f 在 \mathbb R 上连续且 f 是周期函数 ⇒ f 在 \mathbb R 上一致连续.$

## 一元微分学

### 导数

#### 可导

- 定义：$\lim\limits_{x\to x_{0}}\dfrac{f(x)-f(x_{0})}{x-x_{0}}:=f'(x_{0})存在且有限$，局部概念（$\dfrac00$型极限）
- 等价定义：$f'_{+}(x_{0}):=\lim\limits_{\Delta x\to 0^{+}}\dfrac{f(x_{0}+\Delta x)-f(x_{0})}{\Delta x}=$$\lim\limits_{\Delta x\to 0^{-}}\dfrac{f(x_0+\Delta x)}{\Delta x}:=f'_{-}(x_{0})$
	- $f在x_{0}处可导\Rightarrow f在x_{0}处连续$

> [!tips] 自行回顾如下内容:
> 导数的四则运算
> 链式 (复合函数) 求导法则
> 反函数求导法则
> 所有初等函数的求导公式
> 用 Leibniz 法则计算高阶导数
> 幂指数型求导
> 隐函数求导 (微分)
> 参数方程表示函数的求导 (微分)

### 微分

#### 可微

- 定义：$\exists\lambda\in\mathbb R,使得f(x_{0}+\Delta x)-f(x_{0})=\lambda \Delta x=f'(x_{0})\Delta x$
	- $\lambda=f'(x_{0})唯一$
	- $\lambda \Delta x称为f在x_{0}处的微分,$ $记为\mathrm d y:=\lambda \Delta x=f'(x_{0}) \Delta x$
	- 导数=微商：$f'(x)=\dfrac{\mathrm d f(x)}{\mathrm d x}$
		- 分子分母有独立意义
		- $\mathrm d f$是$\mathrm d x$的线性函数
- **在一元微分学中，可导$\Leftrightarrow$可微**
- <b class="md-tag">一阶微分形式不变性</b> ![MA.3.2 微分](../../../MA.3.2%20%E5%BE%AE%E5%88%86.md#5ff0eb)

### 微分中值定理

> [!tip] 自行回顾如下内容 (后三个定理都是考试常考点):
> Fermat 定理
> Rolle 定理
> Cauchy 定理
> Lagrange 定理
> Darboux 定理

