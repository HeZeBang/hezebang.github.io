---
share: true
---


>[!contents]
>
>```table-of-contents
> style: nestedList # TOC style (nestedList|inlineFirstLevel)
> maxLevel: 0 # Include headings up to the speficied level
> includeLinks: true # Make headings clickable
> debugInConsole: false # Print debug info in Obsidian console
> ```

> [!chatgpt] 生成式人工智能声明
> 
> 本文档由 ChatGPT 扩写，请注意甄别错误

> 本 Cheatsheet 源自 Boqing Xue 的 Linear Algebra Checklist *(2022 Spring)*
> 
> 适用于 Boqing Xue's **Linear Algebra** *2023 Fall*
> 
> ***Written by ZAMBAR***

# Chap.00

> If $A\neq 0$ Then $A^TA\neq0$

> [!Theorem]
> Euivalent Statements

If $A$ is an $n \times n$ matrix, then the following statements are equivalent:

1. $A$ is invertible.

2. $Ax = 0$ has only the trivial solution.

3. The reduced row echelon form of $A$ is $I_n$.

4. $A$ can be expressed as a product of elementary matrices.

5. $Ax = b$ is consistent for every $n \times 1$ matrix $b$.

6. $Ax = b$ has exactly one solution for every $n \times 1$ matrix $b$.

7. $\det(A) \neq 0$.

8. The column vectors of $A$ are linearly independent.
   
9. The row vectors of $A$ are linearly independent.
   
10. The column vectors of $A$ span $\mathbb{R} ^n$.
    
11.  The row vectors of $A$ span $\mathbb{R} ^n$.
    
12. The column vectors of $A$ form a basis for $\mathbb{R} ^n$.
    
13. The row vectors of A form a basis for $\mathbb{R} ^n$.
    
14. $\text{rank}(A) = n$.
    
15. $\text{nullity}(A) = 0$.
    
16. $\text{Null}(A)^⊥ = \mathbb{R} ^n$.
    
17. $\text{Row}(A)^⊥ = {0}$.

# Chap.01 Systems of Linear Equations and Matrices

> [!definition]
> linear system; homogeneous linear system; solution; general solution; consistent/inconsistent; augmented matrix; coefficient matrix.

当涉及到线性代数中的一些基本概念和定义时，以下是对每个术语的阐释：

1. **线性系统（Linear System）：**
   线性系统是由一组线性方程组成的系统。每个方程都涉及一组未知数的线性组合。一般形式为：
   $$a_{11}x_1 + a_{12}x_2 + \ldots + a_{1n}x_n = b_1$$
   $$a_{21}x_1 + a_{22}x_2 + \ldots + a_{2n}x_n = b_2$$
   $$\vdots$$
   $$a_{m1}x_1 + a_{m2}x_2 + \ldots + a_{mn}x_n = b_m$$
   其中，$a_{ij}$ 是系数，$x_i$ 是未知数，$b_i$ 是常数。

2. **齐次线性系统（Homogeneous Linear System）：**
   齐次线性系统是一个特殊的线性系统，其右侧常数项都为零。即，对于一个齐次线性系统：
   $$a_{11}x_1 + a_{12}x_2 + \ldots + a_{1n}x_n = 0$$
   $$a_{21}x_1 + a_{22}x_2 + \ldots + a_{2n}x_n = 0$$
   $$\vdots$$
   $$a_{m1}x_1 + a_{m2}x_2 + \ldots + a_{mn}x_n = 0$$
   所有的 $b_i$ 都等于零。

3. **解（Solution）：**
   对于线性系统，解是一组满足所有方程的未知数值。如果一个解存在，我们称这个系统是有解的。

4. **一般解（General Solution）：**
   一般解是表示线性系统所有可能解的形式。它包含了系统中所有特定解的参数表示，因此可以表示出无穷多个解。

5. **一致性/不一致性（Consistent/Inconsistent）：**
   一个线性系统是一致的，如果至少存在一个解。反之，如果不存在解，则系统是不一致的。

6. **增广矩阵（Augmented Matrix）：**
   增广矩阵是将线性系统的系数矩阵和常数项列合并成一个矩阵的形式。例如，对于线性系统：
   $$a_{11}x_1 + a_{12}x_2 + \ldots + a_{1n}x_n = b_1$$
   $$a_{21}x_1 + a_{22}x_2 + \ldots + a_{2n}x_n = b_2$$
   $$\vdots$$
   $$a_{m1}x_1 + a_{m2}x_2 + \ldots + a_{mn}x_n = b_m$$
   对应的增广矩阵为：
   $$[A | B] = \begin{bmatrix} a_{11} & a_{12} & \ldots & a_{1n} & | & b_1 \\ a_{21} & a_{22} & \ldots & a_{2n} & | & b_2 \\ \vdots & \vdots & \ddots & \vdots & | & \vdots \\ a_{m1} & a_{m2} & \ldots & a_{mn} & | & b_m \end{bmatrix}$$

7. **系数矩阵（Coefficient Matrix）：**
   系数矩阵是线性系统中由所有系数构成的矩阵。对于上述线性系统，系数矩阵为：
   $$A = \begin{bmatrix} a_{11} & a_{12} & \ldots & a_{1n} \\ a_{21} & a_{22} & \ldots & a_{2n} \\ \vdots & \vdots & \ddots & \vdots \\ a_{m1} & a_{m2} & \ldots & a_{mn} \end{bmatrix}$$

这些概念对于理解和解决线性系统问题非常重要。增广矩阵和系数矩阵的使用使得线性系统的处理更加方便。

> [!definition]
> matrix; entry; order; column; row; addition; scalar multiplication; multiplication; transpose; trace; rank; zero matrix; identity matrix; partitioned matrix; elementary matrix; invertible matrix; polynomial of matrix; diagonal matrix; triangular matrix; symmetric/anti-symmetric matrix.

下面是关于线性代数中一些基本概念和定义的阐释：

1. **矩阵（Matrix）：**
   矩阵是一个由数字排列成的矩形阵列。通常用方括号表示，如 $A = [a_{ij}]$，其中 $a_{ij}$ 是矩阵中的元素。

2. **元素（Entry）：**
   矩阵中的每个数字都称为一个元素，记作 $a_{ij}$，其中 $i$ 表示行号，$j$ 表示列号。

3. **阶（Order）：**
   矩阵的阶是指它的行数和列数。一个 $m \times n$ 的矩阵有 $m$ 行和 $n$ 列。

4. **列（Column）：**
   矩阵中的一列是指矩阵中相同列号的所有元素组成的向量。

5. **行（Row）：**
   矩阵中的一行是指矩阵中相同行号的所有元素组成的向量。

6. **加法（Addition）：**
   矩阵加法是指两个具有相同阶的矩阵中相应元素相加的操作。

7. **标量乘法（Scalar Multiplication）：**
   矩阵的标量乘法是指将矩阵的每个元素都乘以一个标量。

8. **乘法（Multiplication）：**
   矩阵乘法是一种将两个矩阵相乘得到新矩阵的运算。要使乘法定义，第一个矩阵的列数必须等于第二个矩阵的行数。

	> [!zhihu]
	> AB=0 =>
	> If nxn：
	> > A, B都不满秩（Det=0）
	> > - Det=0 => $A B_{i}=\mathbb0=C_{i}$有无穷多解（任意）
	> 
	> > If A:mxn B:nxs
	> > - A的列向量线性相关，B的行向量线性相关。 

9. **转置（Transpose）：**
   矩阵的转置是将矩阵的行和列交换得到的新矩阵。

10. **迹（Trace）：**
    方阵的迹是指其主对角线上的元素之和。

11. **秩（Rank）：**
    矩阵的秩是指矩阵中线性无关的行或列的最大数量。
    （变换后的空间维数）
    - Full rank $r=\text{Rank}$ <=> Det=0
	    - Only $\mathbf {\vec0}$ is still zero!

12. **零矩阵（Zero Matrix）：**
    全部元素都为零的矩阵。

13. **单位矩阵（Identity Matrix）：**
    主对角线上的元素都为1，其他元素都为零的方阵。

14. **分块矩阵（Partitioned Matrix）：**
    将一个矩阵划分成若干个子矩阵的形式。

15. **初等矩阵（Elementary Matrix）：**
    由单位矩阵经过一次初等行变换得到的矩阵。

16. **可逆矩阵（Invertible Matrix）：**
    如果存在一个矩阵，使得它与原矩阵相乘或相加得到单位矩阵，则原矩阵称为可逆矩阵。

17. **矩阵的多项式（Polynomial of Matrix）：**
    包含矩阵的多项式表达式。

18. **对角矩阵（Diagonal Matrix）：**
    除了主对角线上的元素外，其他元素都为零的矩阵。

19. **上三角矩阵和下三角矩阵（Triangular Matrix）：**
    如果一个矩阵的主对角线以下的元素全为零，那么它是上三角矩阵；如果主对角线以上的元素全为零，那么它是下三角矩阵。

20. **对称矩阵和反对称矩阵（Symmetric/Anti-symmetric Matrix）：**
    对称矩阵是指 $A^T = A$，即矩阵关于主对角线对称；反对称矩阵是指 $A^T = -A$，即矩阵关于主对角线反对称。

> [!theorem]
> Properties of matrix operations, transpose, trace, inverse and diagonal/triangular/(anti-)symmetric matrix.

以下是一些关于矩阵操作、转置、迹、逆矩阵以及对角矩阵、三角矩阵和（反）对称矩阵性质的定理：

1. **矩阵操作的性质（Properties of Matrix Operations）：**
   - **结合律：** 对于矩阵乘法，$(AB)C = A(BC)$。
   - **分配律：** 矩阵乘法对于加法具有分配律，即$A(B + C) = AB + AC$和$(A + B)C = AC + BC$。

2. **转置的性质（Properties of Transpose）：**
   - $(A^T)^T = A$，即转置的转置是原矩阵。
   - $(A + B)^T = A^T + B^T$，即转置的和等于各自转置的和。
   - $(cA)^T = cA^T$，其中 $c$ 是标量。

3. **迹的性质（Properties of Trace）：**
   - 对于方阵 $A$，$\text{tr}(A) = \text{tr}(A^T)$。
   - 对于方阵 $A$ 和 $B$，$\text{tr}(A + B) = \text{tr}(A) + \text{tr}(B)$。
   - 对于方阵 $A$，$c$ 是标量，$\text{tr}(cA) = c \cdot \text{tr}(A)$。

4. **逆矩阵的性质（Properties of Inverse Matrix）：**
   - 如果 $A$ 可逆，那么其逆矩阵 $A^{-1}$ 也可逆，且 $(A^{-1})^{-1} = A$。
   - 如果 $A$ 和 $B$ 都是可逆矩阵，那么 $AB$ 也是可逆矩阵，且 $(AB)^{-1} = B^{-1}A^{-1}$。
   - 如果 $A$ 是可逆的，那么 $A^T$ 也是可逆的，且 $(A^T)^{-1} = (A^{-1})^T$。

5. **对角矩阵、三角矩阵和（反）对称矩阵的性质：**
	当涉及对角矩阵、三角矩阵以及（反）对称矩阵时，以下是一些性质的表示：
	- 对角矩阵（Diagonal Matrix）：
	  1. **对角矩阵的逆：**
   如果 $D$ 是一个对角矩阵，其中对角线上的元素 $d_{ii} \neq 0$，那么其逆矩阵为：
   $$ D^{-1} = \begin{bmatrix} \frac{1}{d_{11}} & 0 & \cdots & 0 \\ 0 & \frac{1}{d_{22}} & \cdots & 0 \\ \vdots & \vdots & \ddots & \vdots \\ 0 & 0 & \cdots & \frac{1}{d_{nn}} \end{bmatrix} $$
		2. **对角矩阵的行列式：**
   对角矩阵的行列式等于其主对角线上的元素的乘积：
   $$ \text{det}(D) = d_{11} \cdot d_{22} \cdot \ldots \cdot d_{nn} $$

	- 三角矩阵（Triangular Matrix）：
	  
	  1. **上三角矩阵的逆：**
   如果 $U$ 是一个上三角矩阵（主对角线以下的元素都为零），那么它的逆矩阵也是上三角矩阵：
	  2. **下三角矩阵的逆：**
   如果 $L$ 是一个下三角矩阵（主对角线以上的元素都为零），那么它的逆矩阵也是下三角矩阵：
	- （反）对称矩阵：
	  1. **对称矩阵的性质：**
   如果 $A$ 是对称矩阵，则它与其转置相等： $A^T = A$。
	  2. **反对称矩阵的性质：**
   如果 $B$ 是反对称矩阵，则它的转置等于其负矩阵： $B^T = -B$。
	   - 若矩阵$B ∈ M_{m×n}$，那么$BB^⊤$为$m$阶对称矩阵，$B^⊤B$为$n$阶对称矩阵

> [!corollary] Schur 公式
> 

> [!theorem]
> Rank of augmented/coefficient matrices 
> ***vs.***
> Consistency of linear systems

**定理：**
对于线性系统的系数矩阵 $A$ 和常数矩阵 $B$，设其增广矩阵为 $[A | B]$。线性系统是一致的当且仅当 $\text{rank}(A) = \text{rank}([A | B])$。

**阐释：**
1. **系数矩阵 $A$ 的秩：**
   $$ \text{rank}(A) $$

2. **增广矩阵 $[A | B]$ 的秩：**
   $$ \text{rank}([A | B]) $$

3. **一致性判断：**
   如果 $\text{rank}(A) = \text{rank}([A | B])$，则线性系统一致，存在解；否则，线性系统不一致，不存在解。

这里，$\text{rank}(A)$ 表示系数矩阵 $A$ 的秩，而 $\text{rank}([A | B])$ 表示增广矩阵 $[A | B]$ 的秩。通过比较这两个秩，我们可以得知线性系统的一致性。如果它们相等，说明增广矩阵中的常数列没有冗余信息，系统是一致的；如果它们不相等，说明常数列中包含了冗余信息，系统是不一致的。

> [!theorem]
> Three possibilities of solutions to a linear system.

**定理：**
线性系统的解有三种可能性：

1. **唯一解（Unique Solution）：**
   线性系统存在唯一解当且仅当系数矩阵 $A$ 的秩等于方程组中的未知数数量 $n$，即 $\text{rank}(A) = n$。

   $$ \text{rank}(A) = n \implies \text{唯一解} $$

2. **无穷多解（Infinitely Many Solutions）：**
   线性系统存在无穷多解当且仅当系数矩阵 $A$ 的秩小于方程组中的未知数数量 $n$，即 $\text{rank}(A) < n$，且存在自由变量。

   $$ \text{rank}(A) < n \implies \text{无穷多解} $$

3. **无解（No Solution）：**
   线性系统无解当且仅当系数矩阵 $A$ 的秩小于增广矩阵 $[A | B]$ 的秩，即 $\text{rank}(A) < \text{rank}([A | B])$。

   $$ \text{rank}(A) < \text{rank}([A | B]) \implies \text{无解} $$

其中，$\text{rank}(A)$ 表示系数矩阵 $A$ 的秩，$n$ 表示未知数的数量。这个定理表明了线性系统解的三种可能性与系数矩阵的秩之间的关系。

> [!fact]
> Production with elementary matrices on left(right)-hand side $\Leftrightarrow$ application of elementary row(column) operation

**事实（Fact）：**
通过在矩阵的左（右）侧使用初等矩阵进行乘法，等价于在矩阵的左（右）侧应用初等行（列）操作。

**阐释：**
1. **左乘初等矩阵：**
   如果我们有一个矩阵 $A$，并且左乘一个初等矩阵 $E$，即 $EA$，这相当于对矩阵 $A$ 进行了一系列的初等行操作。

   例如，如果 $E$ 是通过交换矩阵 $A$ 的两行得到的初等矩阵，那么左乘 $E$ 相当于在矩阵 $A$ 中交换相应的两行。

2. **右乘初等矩阵：**
   如果我们有一个矩阵 $A$，并且右乘一个初等矩阵 $E$，即 $AE$，这相当于对矩阵 $A$ 进行了一系列的初等列操作。

   例如，如果 $E$ 是通过交换矩阵 $A$ 的两列得到的初等矩阵，那么右乘 $E$ 相当于在矩阵 $A$ 中交换相应的两列。

这个事实表明，通过在矩阵的左（右）侧乘以初等矩阵，我们可以实现对矩阵进行一系列的初等行（列）操作。这种操作是线性代数中求解线性系统、计算矩阵的逆等问题中非常有用的技巧。


> [!example]
> 
> **Example 1.1:**
> 
> Solve the linear system:
> 
> $$
> \begin{cases}
> x_1 + 3x_2 - 2x_3 + 2x_5 = 0 \newline 2x_1 + 6x_2 - 5x_3 - 2x_4 + 4x_5 - 3x_6 = -1 \newline 5x_3 + 10x_4 + 15x_6 = 5 \newline 2x_1 + 6x_2 + 8x_4 + 4x_5 + 18x_6 = 6
> \end{cases}
> $$
> 
> Solve by:
> 
> 1. Gauss-Jordan elimination.
> 2. Gaussian elimination and back-substitution.
> 
> **Example 1.2:**
> 
> Consider the linear system of equations:
> 
> $$
> \begin{cases}
> -2x + y + z = -2 \newline x - 2y + z = a \newline x + y + (b - 2)z = a
> \end{cases}
> $$
> 
> Find the conditions on $a, b$ such that the above linear system is consistent. Then find the solutions.
> 
> **Example 1.3:**
> 
> Solve the linear system:
> 
> $$ Ax = B $$
> 
> where:
> 
> $$ A =
> \begin{bmatrix}
> 1 & 2 & 3 \newline 2 & 5 & 3 \newline 1 & 0 & 8
> \end{bmatrix}
> $$
> 
> $$ B =
> \begin{bmatrix}
> -1 & 0 & 1 \newline 1 & 2 & -2 \newline 0 & 3 & 2
> \end{bmatrix}
> $$
> 
> Evaluate $A^{-1}$ and $A^{-1}B$.

# Chap.02 Euclidean Vector Spaces

> [!definition]
> n-space; vector; addition; scalar multiplication; linear combination; norm; distance; unit vector; dot product; orthogonality; orthogonal projection; line and plane; cross product; triple product

**概念/定义：**

1. **n-空间（n-space）：**
   - **阐释：** n-空间是具有n个实数的集合，通常用$\mathbb{R}^n$表示。每个元素是n维向量。

2. **向量（Vector）：**
   - **阐释：** 向量是n个有序实数的组合，通常表示为 $\mathbf{v} = \begin{bmatrix} v_1 \\ v_2 \\ \vdots \\ v_n \end{bmatrix}$。向量可以在n-空间中表示一个点或一个方向。

3. **加法（Addition）：**
   - **阐释：** 向量加法是指对应元素相加，例如 $\mathbf{u} + \mathbf{v} = \begin{bmatrix} u_1 + v_1 \\ u_2 + v_2 \\ \vdots \\ u_n + v_n \end{bmatrix}$。

4. **标量乘法（Scalar Multiplication）：**
   - **阐释：** 标量乘法是指将向量的每个元素乘以一个实数，例如 $c \cdot \mathbf{v} = \begin{bmatrix} c \cdot v_1 \\ c \cdot v_2 \\ \vdots \\ c \cdot v_n \end{bmatrix}$。

5. **线性组合（Linear Combination）：**
   - **阐释：** 线性组合是指通过对向量进行加法和标量乘法操作得到的结果，如 $c_1 \cdot \mathbf{v}_1 + c_2 \cdot \mathbf{v}_2 + \ldots + c_k \cdot \mathbf{v}_k$。

6. **范数（Norm）：**
   - **阐释：** 向量的范数是一个非负实数，表示向量的大小。常见的有欧几里得范数（二范数）：$\|\mathbf{v}\| = \sqrt{v_1^2 + v_2^2 + \ldots + v_n^2}$。

7. **距离（Distance）：**
   - **阐释：** 两个向量之间的距离是它们之间的欧几里得距离，即 $\|\mathbf{v} - \mathbf{u}\|$。

8. **单位向量（Unit Vector）：**
   - **阐释：** 单位向量是范数为1的向量，通常表示为 $\frac{\mathbf{v}}{\|\mathbf{v}\|}$

9. **点积（Dot Product）：**
   - **阐释：** 两个向量的点积是对应元素相乘后的和，例如 $\mathbf{u} \cdot \mathbf{v} = u_1 \cdot v_1 + u_2 \cdot v_2 + \ldots + u_n \cdot v_n$。

10. **正交性（Orthogonality）：**
    - **阐释：** 两个向量正交表示它们的点积为零，即 $\mathbf{u} \cdot \mathbf{v} = 0$。

11. **正交投影（Orthogonal Projection）：**
    - **阐释：** 向量 $\mathbf{v}$ 在向量 $\mathbf{u}$ 上的正交投影是一个向量，表示 $\text{proj}_{\mathbf{u}}(\mathbf{v}) = \dfrac{\mathbf{v} \cdot \mathbf{u}}{\|\mathbf{u}\|^2} \cdot \mathbf{u}$。
    - **正交投影的模长：** $\|\text{proj}_{\mathbf{u}}(\mathbf{v})\| = \dfrac{|\mathbf{v} \cdot \mathbf{u}|}{\|\mathbf{u}\|}$

12. **直线和平面（Line and Plane）：**
    - **阐释：** 在n-空间中，直线可以由一个点和一个方向向量确定而平面可以由一个点和两个线性无关的方向向量确定。

13. **叉积（Cross Product）：**
    - **阐释：** 三维空间中，两个向量的叉积是一个与这两个向量都垂直的向量，其大小由平行四边形的面积表示，方向由右手定则确定。
    - Notational trick: 得到的是向量 $$(v_{1},v_{2},v_{3})\times(w_{1},w_{2},w_{3})=\begin{vmatrix}\hat i & \hat j & \hat k\\v_{1} & v_{2} & v_{3}\\w_{1} & w_{2} & w_{3}\end{vmatrix} $$

> [!definition]
> determinant; minor; cofactor; adjunct(adjunct).

**概念/定义：**

1. **行列式（Determinant）：**
   - **阐释：** 对于一个n阶方阵 $A$，其行列式表示为 $|A|$ 或 $\det(A)$。对于3阶矩阵 $A$，行列式的表达式为：
     $$ |A| = \det(A) = a_{11}(a_{22}a_{33} - a_{23}a_{32}) - $$$$a_{12}(a_{21}a_{33} - a_{23}a_{31}) + a_{13}(a_{21}a_{32} - a_{22}a_{31}) $$
     - **含义：** 面积/体积

2. **余子式（Minor）：**
   - **阐释：** 对于矩阵 $A$ 中的一个元素 $a_{ij}$，其对应的余子式是删除第 $i$ 行和第 $j$ 列后形成的行列式，表示为$\text{Minor}(A)_{ij}$或$M_{ij}$。

3. **代数余子式（Cofactor）：**
   - **阐释：** 对于矩阵 $A$ 中的一个元素 $a_{ij}$，其对应的代数余子式是其余子式乘以 $(-1)^{i+j}$。代数余子式通常表示为 $\text{cof}(A)_{ij}$ 或 $C_{ij}$。
     $$ C_{ij} = (-1)^{i+j} \cdot M_{ij} $$

4. **伴随矩阵（adjunct/Adjugate）：**
   - **阐释：** 对于n阶方阵 $A$，其伴随矩阵（伴随矩阵也称为伴随矩阵）记作 $\text{adj}(A)$ 或 $\text{adjunct}(A)$，其中每个元素是对应位置的余子式。
     $$ \text{adj}(A)_{ij} = C_{ji} $$
   - **性质：** 如果 $A$ 可逆，则其逆矩阵为 $$A^{-1}=\dfrac1{\det(A)}\cdot{\text{adj}(A)}$$

> [!definition]
> Concepts/Definitions: matrix transformation; composition; inverse.

**概念/定义：**

1. **矩阵变换（Matrix Transformation）：**
   - **阐释：** 矩阵变换是一种线性变换，通过矩阵与向量相乘来改变向量的位置。对于一个矩阵 $A$ 和一个列向量 $\mathbf{v}$，矩阵变换的结果是另一个列向量 $\mathbf{u} = A\mathbf{v}$。

2. **复合（Composition）：**
   - **阐释：** 复合是指将两个或多个变换结合在一起形成一个新的变换。如果有两个矩阵变换 $A$ 和 $B$，它们的复合表示为 $C = BA$，其中 $C$ 的效果等同于先进行 $A$ 变换，然后进行 $B$ 变换。

3. **逆变换（Inverse Transformation）：**
   - **阐释：** 对于一个变换 $T$，如果存在一个逆变换 $T^{-1}$，那么对于任意输入 $x$，应用 $T$ 后再应用 $T^{-1}$ 将返回原始输入，即 $T^{-1}(T(x)) = x$。对于矩阵变换，逆变换通常通过矩阵的逆来表示，即 $A^{-1}$。

> [!theorem]
> Properties of vector operations/norm/distance.

**定理：向量运算/范数/距离的性质**

1. **向量加法的性质：**
   - **公式：** 对于任意向量 $\mathbf{u}, \mathbf{v}, \mathbf{w}$，满足交换律和结合律。
     $$ \mathbf{u} + \mathbf{v} = \mathbf{v} + \mathbf{u} $$
     $$ (\mathbf{u} + \mathbf{v}) + \mathbf{w} = \mathbf{u} + (\mathbf{v} + \mathbf{w}) $$

2. **标量乘法的性质：**
   - **公式：** 对于任意标量 $c$ 和向量 $\mathbf{v}$，满足分配律。
     $$ c(\mathbf{u} + \mathbf{v}) = c\mathbf{u} + c\mathbf{v} $$

3. **范数的性质：**
   - **公式：** 对于任意向量 $\mathbf{v}$ 和标量 $c$，满足非负性、齐次性、和三角不等式。
     - **非负性：** $\|\mathbf{v}\| \geq 0$，且等号成立当且仅当 $\mathbf{v} = \mathbf{0}$。
     - **齐次性：** $\|c\mathbf{v}\| = |c| \cdot \|\mathbf{v}\|$。
     - **三角不等式：** $\|\mathbf{u} + \mathbf{v}\| \leq \|\mathbf{u}\| + \|\mathbf{v}\|$。

4. **距离的性质：**
   - **公式：** 对于向量空间中的任意两个向量 $\mathbf{u}$ 和 $\mathbf{v}$，它们之间的距离满足非负性、同一性、和三角不等式。
     - **非负性：** $d(\mathbf{u}, \mathbf{v}) \geq 0$，且等号成立当且仅当 $\mathbf{u} = \mathbf{v}$。
     - **同一性：** $d(\mathbf{u}, \mathbf{v}) = d(\mathbf{v}, \mathbf{u})$。
     - **三角不等式：** $d(\mathbf{u}, \mathbf{v}) + d(\mathbf{v}, \mathbf{w}) \geq d(\mathbf{u}, \mathbf{w})$。

> [!theorem]
> Properties of vectors

设 $\mathbf{u, v, w} \in \mathbb{R}^n$，而 $\lambda, \mu \in \mathbb{F}$. 则

- $\mathbf{u + v} = \mathbf{v + u}.$
- $\mathbf{u + (v + w)} = (\mathbf{u + v}) + w.$
- $\mathbf{v + 0} = \mathbf{v}.$
- $\mathbf{v + (-v)} = \mathbf{0}.$
- $\lambda(\mathbf{u + v}) = \lambda \mathbf{u} + \lambda \mathbf{v}.$
- $(\lambda + \mu)\mathbf{v} = \lambda \mathbf{v} + \mu \mathbf{v}.$
- $\mu(\lambda \mathbf{v}) = (\mu \lambda)\mathbf{v}.$
- $\mathbf{1v} = \mathbf{v}.$
- $\mathbf{0v} = \mathbf{0}.$
- $\lambda\mathbf{0} = \mathbf{0}.$
- $(-1)\mathbf{v} = -\mathbf{v}.$

> [!Theorem]
> Properties of dot, cross and scalar triple products; geometric meaning of determinant

**定理：点积、叉积和标量三重积的性质以及行列式的几何意义**

1. **点积 (Inner Product) 的性质：**
   - **公式：** 对于向量 $\mathbf{u}, \mathbf{v}, \mathbf{w}$ 和标量 $c$，点积具有交换律和分配律。
     $$ \mathbf{u} \cdot \mathbf{v} = \mathbf{v} \cdot \mathbf{u} $$
     $$ (k\mathbf{u})\cdot\mathbf{v} = k(\mathbf{u}\cdot\mathbf{v}) $$
     $$ (\mathbf{u} + \mathbf{v}) \cdot \mathbf{w} = \mathbf{u} \cdot \mathbf{w} + \mathbf{v} \cdot \mathbf{w} $$
   - **几何意义：** 点积表示了两个向量之间的投影关系，可以用来计算夹角余弦。
	- **Proposition:**
		- Let $\mathbf{u}, \mathbf{v}$ be vectors. Then:
			- $\mathbf{v} \cdot \mathbf{v} = \lVert \mathbf{v} \rVert^2$.
			- $\lvert \mathbf{u} \cdot \mathbf{v} \rvert \leq \lVert \mathbf{u} \rVert \lVert \mathbf{v} \rVert$ (Cauchy’s Inequality).
	- **Corollary:**
		- Let $\mathbf{u}, \mathbf{v}$ be vectors in $\mathbb{R}^n$. We have:
			- $\lVert \mathbf{u} + \mathbf{v} \rVert \leq \lVert \mathbf{u} \rVert + \lVert \mathbf{v} \rVert$ (Triangular Inequality).
			- $d(\mathbf{u}, \mathbf{v}) \leq d(\mathbf{u}, \mathbf{w}) + d(\mathbf{w}, \mathbf{v})$ (Triangular Inequality).

2. **叉积的性质：**
   - **公式：** 对于向量 $\mathbf{u}, \mathbf{v}, \mathbf{w}$ 和标量 $c$，叉积具有分配律、反对称性和线性性。
     $$ \mathbf{u} \times \mathbf{v} = -(\mathbf{v} \times \mathbf{u}) $$
     $$ (\mathbf{u} + \mathbf{v}) \times \mathbf{w} = \mathbf{u} \times \mathbf{w} + \mathbf{v} \times \mathbf{w} $$
	- **性质:**
		$$\mathbf{u} \times (\mathbf{v} + \mathbf{w}) = (\mathbf{u} \times \mathbf{v}) + (\mathbf{u} \times \mathbf{w})$$
		$$(\mathbf{u} + \mathbf{v}) \times \mathbf{w} = (\mathbf{u} \times \mathbf{w}) + (\mathbf{v} \times \mathbf{w})$$
		$$\mathbf{u} \times (\mathbf{v} \times \mathbf{w}) = (\mathbf{u} \cdot \mathbf{w})\mathbf{v} - (\mathbf{u} \cdot \mathbf{v})\mathbf{w}$$
		$$(\mathbf{u} \times \mathbf{v}) \times \mathbf{w} = (\mathbf{u} \cdot \mathbf{w})\mathbf{v} - (\mathbf{v} \cdot \mathbf{w})\mathbf{u}$$
		$$\mathbf{u} \times (\mathbf{v} \times \mathbf{w}) + \mathbf{v} \times (\mathbf{w} \times \mathbf{u}) + \mathbf{w} \times (\mathbf{u} \times \mathbf{v}) = \mathbf{0}$$

   - **几何意义：** 叉积的结果是一个垂直于参与运算的两个向量的向量，其大小等于这两个向量围成的平行四边形的面积。
	- **Theorem:** Let $\mathbf{u}$, $\mathbf{v}$, and $\mathbf{w}$ be vectors in $\mathbb{R}^3$, and $k$ be a scalar.
	
		- $\mathbf{u} \times \mathbf{v} = -(\mathbf{v} \times \mathbf{u})$.
		- $\mathbf{u} \cdot (\mathbf{u} \times \mathbf{v}) = 0$.
		- $\mathbf{v} \cdot (\mathbf{u} \times \mathbf{v}) = 0$.
		- $k(\mathbf{u} \times \mathbf{v}) = (\mathbf{ku}) \times \mathbf{v} = \mathbf{u} \times (\mathbf{kv})$.
		- $\mathbf{u} \times \mathbf{0} = \mathbf{0} \times \mathbf{u} = \mathbf{0}$.
		- $\mathbf{u} \times \mathbf{u} = \mathbf{0}$.
		- $\lVert \mathbf{u} \times \mathbf{v} \rVert^2 = \lVert \mathbf{u} \rVert^2 \lVert \mathbf{v} \rVert^2 - (\mathbf{u} \cdot \mathbf{v})^2$.

	- **Theorem:** Suppose that $\mathbf{u} = (u_1, u_2, u_3)$ and $\mathbf{v} = (v_1, v_2, v_3)$. Then,
	$$
	\mathbf{u} \times \mathbf{v} =
	\begin{pmatrix}
	\begin{vmatrix} u_2 & u_3 \\ v_2 & v_3 \end{vmatrix} , & 
	\begin{vmatrix} u_3 & u_1 \\ v_3 & v_1 \end{vmatrix} , & 
	\begin{vmatrix} u_1 & u_2 \\ v_1 & v_2 \end{vmatrix}
	\end{pmatrix}
	$$

	- **Gou-Gu Theorem:**
Suppose that $\mathbf{u} = (u_1, u_2, u_3)$ and $\mathbf{v} = (v_1, v_2, v_3)$. Then,
$$ \lVert \mathbf{u} \times \mathbf{v} \rVert^2 = \begin{vmatrix} u_2 & u_3 \\ v_2 & v_3 \end{vmatrix}^2 + \begin{vmatrix} u_3 & u_1 \\ v_3 & v_1 \end{vmatrix}^2 + \begin{vmatrix} u_1 & u_2 \\ v_1 & v_2 \end{vmatrix}^2 $$
$$ = \lVert \text{proj}_{\text{yOz}}(\mathbf{u}) \times \text{proj}_{\text{yOz}}(\mathbf{v}) \rVert^2 + $$$$\lVert \text{proj}_{\text{xOz}}(\mathbf{u}) \times \text{proj}_{\text{xOz}}(\mathbf{v}) \rVert^2 + \lVert \text{proj}_{\text{xOz}}(\mathbf{u}) \times \text{proj}_{\text{xOz}}(\mathbf{v}) \rVert^2 $$
Here, $\text{proj}_{\text{yOz}}(\mathbf{u})$ is the projection of $\mathbf{u}$ onto the $yOz$-plane, and the other notations are similar.

3. **混合积 / 标量三重积的性质：**
   - **公式：** 对于向量 $\mathbf{u}, \mathbf{v}, \mathbf{w}$，标量三重积满足交换律。
     $$ \mathbf{u} \cdot (\mathbf{v} \times \mathbf{w}) = \mathbf{v} \cdot (\mathbf{w} \times \mathbf{u}) = \mathbf{w} \cdot (\mathbf{u} \times \mathbf{v}) $$
   - **几何意义：** 标量三重积的绝对值等于以三个向量为边的平行六面体的体积。

	- **Theorem:**
		- Suppose that
		$$ \mathbf{u} = (u_1, u_2, u_3), \; \mathbf{v} = (v_1, v_2, v_3), \;\mathbf{w} = (w_1, w_2, w_3). $$
		Then the scalar triple product
		$$ \mathbf{u} \cdot (\mathbf{v} \times \mathbf{w}) = \begin{vmatrix} u_1 & u_2 & u_3 \\ v_1 & v_2 & v_3 \\ w_1 & w_2 & w_3 \end{vmatrix} $$
		$$ = u_1 \begin{vmatrix} v_2 & v_3 \\ w_2 & w_3 \end{vmatrix} - u_2 \begin{vmatrix} v_1 & v_3 \\ w_1 & w_3 \end{vmatrix} + u_3 \begin{vmatrix} v_1 & v_2 \\ w_1 & w_2 \end{vmatrix} $$
		$$ = u_1v_2w_3 + u_2v_3w_1 + u_3v_1w_2 - $$$$u_3v_2w_1 - u_2v_1w_3 - u_1v_3w_2. $$
	- **Proposition:**
		1. $\lvert (\mathbf{a} \times \mathbf{b}) \cdot \mathbf{c} \rvert$ is the volume of the parallelepiped determined by $\mathbf{a}, \mathbf{b}, \mathbf{c}$.
		2. If $\mathbf{a}, \mathbf{b}, \mathbf{c}$ satisfy the "right-hand rule," then $(\mathbf{a} \times \mathbf{b}) \cdot \mathbf{c} > 0$;
		3. If $\mathbf{a}, \mathbf{b}, \mathbf{c}$ satisfy the "left-hand rule," then $(\mathbf{a} \times \mathbf{b}) \cdot \mathbf{c} < 0$;
		4. If $\mathbf{a}, \mathbf{b}, \mathbf{c}$ are coplanar vectors, then $(\mathbf{a} \times \mathbf{b}) \cdot \mathbf{c} = 0$.

	- **Remark:**
		$$ (\mathbf{a} \times \mathbf{b}) \cdot \mathbf{c} = (\mathbf{b} \times \mathbf{c}) \cdot \mathbf{a} = (\mathbf{c} \times \mathbf{a}) \cdot \mathbf{b} $$

4. **行列式的几何意义：**
   - **公式：** 对于3阶方阵 $A$，其行列式 $\det(A)$ 表示了由矩阵的列向量所确定的平行六面体的体积。
   - **几何意义：** 行列式的符号表示平行六面体的方向，为正表示右手定则，为负表示左手定则。

> [!theorem]
> Equations of lines and planes in $\mathbb{R} ^3$.

**定理：在 $\mathbb{R}^3$ 中的直线和平面方程**

1. **直线的参数方程：**
   - **公式：** 一条通过点 $(x_0, y_0, z_0)$ 且方向向量为 $\mathbf{v} = \begin{bmatrix} a \\ b \\ c \end{bmatrix}$ 的直线的参数方程可以表示为：
     $$ \begin{cases}
         x = x_0 + at \\
         y = y_0 + bt \\
         z = z_0 + ct
       \end{cases} $$
   - **几何意义：** 直线上的每个点都可以通过参数 $t$ 来表示，表示了直线上的点沿着方向向量的运动。

2. **直线的对称式方程：**
   - **公式：** 一条通过点 $(x_0, y_0, z_0)$ 且方向向量为 $\mathbf{v} = \begin{bmatrix} a \\ b \\ c \end{bmatrix}$ 的直线的对称式方程为：
     $$ \frac{x - x_0}{a} = \frac{y - y_0}{b} = \frac{z - z_0}{c} $$
   - **几何意义：** 对称式方程表示了直线上的任意一点到起点的距离与方向向量的比例相等。

3. **平面的点法式方程：**
   - **公式：** 一个过点 $(x_0, y_0, z_0)$ 且法向量为 $\mathbf{n} = \begin{bmatrix} A \\ B \\ C \end{bmatrix}$ 的平面的点法式方程为：
     $$ A(x - x_0) + B(y - y_0) + C(z - z_0) = 0 $$
   - **几何意义：** 平面上的每个点满足点法式方程，表示点到平面的向量与法向量垂直。

4. **平面的一般方程：**
   - **公式：** 一个平面的一般方程为：
     $$ Ax + By + Cz + D = 0 $$
   - **几何意义：** 一般方程表示了平面上的点满足平面方程，其中 $A, B, C$ 是法向量的分量，$D$ 是平面的截距。

> [!theorem]
> 
> Properties of determinant

**定理：行列式的性质**

> 保乘法

1. **性质1 - 行的交换：** 
   - **公式：** 行列式的值不变，当且仅当交换行。
     $$ \det(A) = -\det(A') $$
   - 理解：交换坐标

2. **性质2 - 行的倍乘：** 
   - **公式：** 行列式的值乘以一个标量，结果为原行列式的值乘以该标量。
     $$ \det(cA) = c^n \cdot \det(A) $$
    - 理解：n次面积翻c倍

3. **性质3 - 行的加法：**
   - **公式：** 如果将矩阵的某一行加上另一行的某个倍数，行列式的值不变。
     $$ \det(A) = \det(A') $$
    - 理解：左乘初等矩阵保乘法；进行行列式为1的变换不改变面积

4. **性质4 - 单位矩阵的行列式：**
   - **公式：** 单位矩阵的行列式为1。
     $$ \det(I) = 1 $$

5. **性质5 - 乘积矩阵的行列式：**
   - **公式：** 两个矩阵的乘积的行列式等于这两个矩阵的行列式的乘积。
     $$ \det(AB) = \det(A) \cdot \det(B) $$

6. **性质6 - 转置矩阵的行列式：**
   - **公式：** 矩阵的转置的行列式等于原矩阵的行列式。
     $$ \det(A^T) = \det(A) $$

7. **性质7 - 逆矩阵的行列式：**
   - **公式：** 如果矩阵可逆，其逆矩阵的行列式等于原矩阵的行列式的倒数。
     $$ \det(A^{-1}) = \frac{1}{\det(A)} $$

这些性质描述了行列式在矩阵运算中的一些基本规律，它们对于计算和理解矩阵的行列式是非常有用的。

> [!theorem]
> Properties of adjunct matrix.

**定理：伴随矩阵的性质**

1. **矩阵乘法：** $AA^{*}=A^{*}A=|A|I$
	- **简证:** 对于对角线上的元素为行列式的展开式；非对角线上的元素可以理解为一个替换了某一行/列的行列式，由于该行/列在矩阵内是重复的，故行列式为0
	- **推论:** $A^{*}=|A|A^{-1}$ 常用于替换证明
2. **纯量乘法：**$(cA)^{*}=c^{n-1}A^{*}$
	   - $(cA)^{*}=|cA|(cA)^{-1}=c^{n}|A|c^{-1}A^{-1}=c^{n-1}A^{*}$
3. **逆可互换：**$(A^{*})^{-1}=(A^{-1})^{*}=\dfrac A{|A|}$
	- **简证:**
	  $(A^{*})^{-1}=(|A|A^{-1})^{-1}=\dfrac A{|A|}$
	  $(A^{-1})^{*}=|A^{-1}|(A^{-1})^{-1}=\dfrac A{|A|}$
4. **转置可互换：**$(A^{*})^{T}=(A^{T})^{*}$
	   - **简证:** $(A^{*})^{T}=(|A|A^{-1})^{T}=|A|(A^{-1})^{T}=|A^{\textcolor{lightgray}T}|(A^{T})^{-1}=(A^{T})^{*}$
5. **伴随的行列式：**$|A^{*}|=|A|^{n-1}$ 
	- **简证:** $|A^{*}|=\left||A|A^{-1}\right|=|A|^{n}\cdot|A^{-1}|=A^{n-1}$
6. **伴随的伴随：**$(A^{*})^{*}=|A|^{n-2}A$
	- **简证:** $(A^{*})^{*}=|A^{*}|(A^{*})^{-1}$
	  由(5), (3), $=|A|^{n-1}\cdot\dfrac A{|A|}=|A|^{n-2}A$

> [!theorem]
> Crammer’s rule

**定理：克拉默法则（Cramer's Rule）**

克拉默法则是解线性方程组的一种方法，适用于方程组的系数矩阵为可逆矩阵的情况。

考虑一个线性方程组：

$$ Ax = b $$

其中，$A$ 是一个 $n \times n$ 的矩阵，$x$ 是未知向量，$b$ 是已知向量。如果矩阵 $A$ 是可逆的，即 $\det(A) \neq 0$，那么克拉默法则可以用以下公式表示：

1. **解的存在性：**
   - 如果 $\det(A) \neq 0$，方程组有唯一解。

2. **解的表达式：**
   - 方程组的解可以通过克拉默法则表示为：
     $$ x_i = \frac{\det(A_i)}{\det(A)} $$
   其中，$x_i$ 是向量 $x$ 的第 $i$ 个分量，$\det(A_i)$ 是将矩阵 $A$ 的第 $i$ 列替换为向量 $b$ 后得到的矩阵的行列式。

3. **注意事项：**
   - 为了使用克拉默法则，必须确保矩阵 $A$ 是可逆的（即 $\det(A) \neq 0$）。当 $\det(A) = 0$ 时，克拉默法则不适用，表示方程组可能没有唯一解或无解。

克拉默法则提供了一种通过矩阵的行列式来计算线性方程组的解的方法，但它的效率较低，特别是在高维情况下。在实际应用中，通常使用更高效的线性代数方法求解线性方程组。

> [!theorem]
> Split Sums in a Column

- **Theorem:**

$$
\begin{vmatrix}
a_{11} & \ldots & \hat{a}_{1k} + \tilde{a}_{1k} & \ldots & a_{1n} \\
a_{21} & \ldots & \hat{a}_{1k} + \tilde{a}_{1k} & \ldots & a_{2n} \\
\vdots & \vdots & \vdots & \ddots & \vdots \\
a_{n1} & \ldots & \hat{a}_{nk} + \tilde{a}_{nk} & \ldots & a_{nn} \\
\end{vmatrix}
$$
$$=
\begin{vmatrix}
a_{11} & \ldots & \hat{a}_{1k} & \ldots & a_{1n} \\
a_{21} & \ldots & \hat{a}_{1k} & \ldots & a_{2n} \\
\vdots & \vdots & \vdots & \ddots & \vdots \\
a_{n1} & \ldots & \hat{a}_{nk} & \ldots & a_{nn} \\
\end{vmatrix}
+
\begin{vmatrix}
a_{11} & \ldots & \tilde{a}_{1k} & \ldots & a_{1n} \\
a_{21} & \ldots & \tilde{a}_{1k} & \ldots & a_{2n} \\
\vdots & \vdots & \vdots & \ddots & \vdots \\
a_{n1} & \ldots & \tilde{a}_{nk} & \ldots & a_{nn} \\
\end{vmatrix}
$$

> [!Formulae]
> $\det(cA) = c^n \det(A)$
> $\det(AB) = \det(A) \det(B)$

**公式：行列式的基本性质**

1. **常数倍法则：**
   - **公式：** 对于任意 $n \times n$ 矩阵 $A$ 和标量 $c$，有 $\det(cA) = c^n \det(A)$。
     $$ \det(cA) = c^n \det(A) $$

2. **乘积法则：**
   - **公式：** 对于任意两个 $n \times n$ 矩阵 $A$ 和 $B$，有 $\det(AB) = \det(A) \det(B)$。
     $$ \det(AB) = \det(A) \det(B) $$

这些性质是关于行列式的基本性质，它们对于行列式的计算和理解非常有用。第一个常数倍法则说明了当矩阵中的所有元素都乘以一个常数时，行列式的值变为原来的 $n$ 次幂倍。第二个乘积法则则表示了两个矩阵的乘积的行列式等于这两个矩阵的行列式的乘积。这些性质在解决线性代数问题和矩阵计算中经常被使用。

> [!Formulae]
> $A \cdot \text{adj}(A) = \text{adj}(A) \cdot A = \det(A) \cdot I_n$
> $\color{darkgray}\Rightarrow A^{-1}=\dots$
> $\det(\text{adj}(A)) = (\det(A))^{n-1}$
> $\Rightarrow \text{adj}(\text{adj}(A))=(\det(A))^{n-2}A$

**公式：伴随矩阵的性质**

1. **伴随矩阵与原矩阵的乘积：**
   - **公式：** 对于任意可逆的 $n \times n$ 矩阵 $A$，其伴随矩阵为 $\text{adj}(A)$ 或 $\text{adjunct}(A)$。有 $A \cdot \text{adj}(A) = \text{adj}(A) \cdot A = \det(A) \cdot I_n$。
     $$ A \cdot \text{adj}(A) = \text{adj}(A) \cdot A = \det(A) \cdot I_n $$

2. **伴随矩阵的行列式：**
   - **公式：** 对于任意可逆的 $n \times n$ 矩阵 $A$，有 $\det(\text{adj}(A)) = (\det(A))^{n-1}$。
     $$ \det(\text{adj}(A)) = (\det(A))^{n-1} $$

这些性质是关于伴随矩阵的基本性质，它们对于解决线性代数中的问题和计算伴随矩阵时非常有用。第一个性质表明矩阵与其伴随矩阵的乘积等于该矩阵的行列式乘以单位矩阵。第二个性质涉及伴随矩阵的行列式，提供了关于伴随矩阵行列式和原矩阵行列式之间的关系。

> [!note] Formulae
> Example: Evaluate Vandermonde Determinant
> 
> $$ \Delta_n = \begin{vmatrix}
> 1 & 1 & \ldots & 1 \newline x_1 & x_2 & \ldots & x_n \newline x_1^2 & x_2^2 & \ldots & x_n^2 \newline \vdots & \vdots & \ddots & \vdots \newline x_1^{n-1} & x_2^{n-1} & \ldots & x_n^{n-1}
> \end{vmatrix} $$
> 
> This is the Vandermonde determinant of order $n$, where $x_1, x_2, \ldots, x_n$ are distinct real numbers. The determinant is calculated by taking the product of the differences between all pairs of $x_i$'s:
> 
>  $$\Delta_n = \prod_{1 \leq i < j \leq n} (x_j - x_i) $$
> 
> Solution:
>1. $x_i=x_j$ => $\det \Delta n= 0$
>2. $x_{i} \ne x_{j}$ 
>从最后一行开始，$行_{k+1}-x_{n}\cdot行_k$
>$$M'_{k+1,~j}=x_{j}^{k}-x_{j}^{j-1}\cdot x_{n} = x_{j}^{k-1}(x_{j}-x_{n})$$
>$列j$提出$(x_{j}-x_{n})$
>$$\det=\small\prod_{j=1}^{n-1} (x_j - x_n)\cdot\begin{vmatrix}\dots &\dots &\dots &1\\1&1&1&0\\\dots &\dots &\dots &\vdots\\\dots &x_{j}^{k-1} &\dots &\vdots\\\dots &\dots &\dots &0\end{vmatrix}$$
>按最后一列展开
>$$\Delta_{n}=(-1)^{1+n}\cdot\prod_{j=1}^{n-1} (x_j - x_n)\cdot\Delta_{n-1}$$
>$$\Delta_{n}=\prod_{j=1}^{n-1} (x_{n} - x_{j})\cdot\Delta_{n-1}=\dots$$
>$$\Delta_n = \prod_{1 \leq i < j \leq n} (x_j - x_i) $$

> [!corollary]
>
> $$ A_n =
> \begin{vmatrix}
> a_1 & 1 & 1 & \ldots & 1 \newline 1 & a_2 \newline 1 && a_3 \newline \vdots & && \ddots \newline 1 &&&& a_n \newline \end{vmatrix}
> $$
> 化三角：
> $=a_{2}\cdot a_{3}\cdots a_{n}\begin{vmatrix}a_{1} & 1 & 1 & \dots & 1\\ \frac{1}{a_{2}} & 1 & 0 & \dots & 0\\ \frac{1}{a_{3}} & 0 & 1 & \dots & 0\\\vdots & \vdots & \vdots & \ddots & \vdots\\ \frac{1}{a_{n}} & 0 & 0 & \dots & 1\end{vmatrix}$
> $=a_{2}\cdot a_{3}\cdots a_{n}\begin{vmatrix}a_{1}-\sum_{i=2}^{n} \frac{1}{a_{i}} & 0 & 0 & \dots & 0\\ \frac{1}{a_{2}} & 1 & 0 & \dots & 0\\ \frac{1}{a_{3}} & 0 & 1 & \dots & 0\\\vdots & \vdots & \vdots & \ddots & \vdots\\ \frac{1}{a_{n}} & 0 & 0 & \dots & 1\end{vmatrix}$
> $=\left(a_{0}-\sum\limits_{i=1}^{n}\dfrac {1}{a_{i}}\right)\prod\limits_{i=1}^{n}a_{i}$
> 
> ---
> 
> $$ B_n =
> \begin{vmatrix}
> a_1 & b & b & \ldots & b \newline c & a_2 & b & \ldots & b \newline c & c & a_3 & \ldots & b \newline \vdots & \vdots & \vdots & \ddots & \vdots \newline c & c & c & \ldots & a_n \newline \end{vmatrix}
> $$
> 1. 写出递推
>    - $b=c$
>      - $行_{1}+行_{2\to n}$
>    提出$a+(n-1)b$
>    $行_{i}-行_{1}\times b$ 变成三角
>    - $b\ne c$
>      - $[a~b~\dots~b]=[b\dots b] + [a-b~0\dots0]$
>  	$D_{n}=\begin{vmatrix}a-b & 0 & 0 & \dots & 0\\c & a & b & \dots & b\\c & c & a & \dots & b\\&&\ddots & \ddots&\vdots\\c & c & c & \dots & a\end{vmatrix}$$+\begin{vmatrix}b & b & b & \dots & b\\c & a & b & \dots & b\\c & c & a & \dots & b\\ &&&\ddots\\\end{vmatrix}$ $=(a-b) D_{n-1}$$+b\begin{vmatrix}1 & 1 & 1 & \dots & 1\\ & a-c & b-c & \dots & b-c\\&&a-c&\dots&b-c\\&&&\ddots\\&&\end{vmatrix}$ $=(a-b) D_{n-1}+b(a-c)^{n-1}$
>  	第二项提出第一行$b$, 相减变成上三角
> 2. 特征方程递推
>    - $D_{n}=\det(A_n)=\det(A_{n}^{T})\dots b/c互换位置$
> 
> ---
> 
>
> $$ C_n =
> \begin{vmatrix}
> a & b \newline c & a & b \newline &c & \ddots & \ddots \newline & & \ddots & \ddots & b \newline  & &  & c & a \newline \end{vmatrix}
> $$
>
> $=a\cdot C_{n-1}+(-c)\times b\cdot C_{n-2}$
>
> ---
> 
> $$ D_n =
> \begin{vmatrix}
> 1 + a_1 & a_2 & \ldots & a_n \newline a_1 & 1 + a_2 & \ldots & a_n \newline \vdots & \vdots & \ddots & \vdots \newline a_1 & a_2 & \ldots & 1 + a_n \newline \end{vmatrix}
> $$
> 
>---
>
>$$\begin{vmatrix}
> a_n &&&&&&& b_n \newline  & a_{n-1} & & &&& b_{n-1} \newline &&\ddots &&& \dots \newline &&&a_1 & b_1 \newline &&&c_1 & d_1 \newline &&\dots &&& \ddots \newline &c_{n-1} &&&&& d_{n-1} \newline c_n &&&&&&& d_n
> \end{vmatrix}$$
> 沿第一行展开 - 沿最后一行展开

> [!note]
> Common methods for computing determinant: 
> -  cofactor expansion (reduce to lower order);
> -  elementary linear operation (reduce to upper triangular matrix);
> -  splitting one row/column into two;
> -  recurrence relation;
> -  computing diagonal and anti-diagonal lines for order 2 or 3;

**行列式计算的常见方法：**

1. **代数余子式展开法（Cofactor Expansion）：**
   - **公式：** 对于一个 $n \times n$ 的矩阵 $A$，其行列式可以通过代数余子式展开法计算。
     $$ \det(A) = a_{11}C_{11} + a_{12}C_{12} + \ldots + a_{1n}C_{1n} = \sum_{i=1}^{n} a_{1i}C_{1i} $$
   - **方法：** 选择某一行（或列），计算每个元素与其代数余子式的乘积，然后求和。

2. **初等行变换法（Elementary Row Operations）：**
   - **公式：** 通过初等行变换，将矩阵化为上三角形矩阵，然后行列式即为对角线元素的乘积。
     $$ \det(A) = \prod_{i=1}^{n} a_{ii} $$
   - **方法：** 利用行变换，将矩阵化为上（或下）三角形，然后计算对角线元素的乘积。

3. **拆分行/列法（Splitting One Row/Column into Two）：**
   - **公式：** 将矩阵的一行（或一列）拆分成两行（或两列），通过展开计算行列式。
   - **方法：** 将矩阵的一行（或一列）拆分，然后利用代数余子式展开计算。

4. **递归关系法（Recurrence Relation）：**
   - **公式：** 利用递归关系，将 $n$ 阶矩阵的行列式表示为 $n-1$ 阶矩阵的行列式。
     $$ \det(A) = a_{11} \det(A_{11}) - a_{12} \det(A_{12}) + \ldots $$$$+ (-1)^{1+n}a_{1n} \det(A_{1n}) $$
   - **方法：** 利用递归关系，将较高阶矩阵的行列式表示为较低阶矩阵的行列式。

5. **对角线和反对角线法（Computing Diagonal and Anti-Diagonal Lines）：**
   - **公式：** 对于2阶或3阶矩阵，计算对角线和反对角线上元素的乘积之和。
     $$ \det(A) = a_{11}a_{22} - a_{12}a_{21} $$
   - **方法：** 对角线和反对角线上的元素相乘，并根据符号求和。对于3阶矩阵，还需要重复这个过程。

这些方法提供了计算行列式的多种途径，选择合适的方法取决于具体矩阵的结构和大小。

> [!example]
> **Example 2.1:**
> (a) Find the area of the triangle with vertices $A(1, -1, 2)$, $B(0, 3, 4)$, $C(6, 1, 8)$.
> (b) Find the volume of the tetrahedron with vertices $P(0, 0, 0)$, $Q(1, 2, -1)$, $R(3, 4, 0)$, $S(-1, -3, 4)$.
> 
> **Example 2.2:**
> Let $A$ be a $4 \times 4$ matrix such that
> $$ \text{adj}(A) =
> \begin{bmatrix}
> 2 & 0 & 1 & 0 \newline 0 & 2 & 0 & 0 \newline 4 & 0 & 3 & 2 \newline -2 & 0 & -1 & 2
> \end{bmatrix}
> $$
> Find:
> (1) $\det(A)$;
> (2) $A$.
> 
> **Example 2.3:**
> Evaluate $\det(A_n)$, where
> $$ A_n =
> \begin{bmatrix}
> a & b & b & \ldots & b \newline c & a & b & \ldots & b \newline c & c & a & \ldots & b \newline \vdots & \vdots & \vdots & \ddots & \vdots \newline c & c & c & \ldots & a
> \end{bmatrix}
> $$
> 
> **Example 2.4:**
> Suppose that $x \in \mathbb{R}^4$ is the vector satisfying $Ax = b$, where
> $$ A =
> \begin{bmatrix}
> 2 & 0 & 0 & 4 \newline 0 & 1 & 2 & 0 \newline 2 & 2022 & 1 & 1 \newline 0 & -3 & 2 & 0
> \end{bmatrix}
> $$
> and
> $$ b =
> \begin{bmatrix}
> 0 \newline 0 \newline -1 \newline 2
> \end{bmatrix}
> $$
> Let $v = (0, 1, 2, 0) \in \mathbb{R}^4$. Find $\text{proj}_v x$, the orthogonal projection of $x$ on $v$.

# Chap.03 General Vector Spaces

> [!definition]
> Vector space; subspace.

**概念/定义：向量空间（Vector Space）和子空间（Subspace）**

**向量空间的两个条件和八个公理：**

向量空间的定义包含两个基本条件，其中一个是**加法封闭性**，另一个是**标量乘法封闭性**。这两个条件由八个公理详细说明。

1. **加法封闭性条件：**
   - **条件：** 向量空间中的任意两个向量的和仍然属于该向量空间。
   - **公理：** 对于任意 $u, v$ 属于向量空间 $V$，它们的和 $u + v$ 也属于 $V$。

2. **标量乘法封闭性条件：**
   - **条件：** 向量空间中的任意标量与向量的乘积仍然属于该向量空间。
   - **公理：** 对于任意 $c$ 是实数，$u$ 是向量空间 $V$ 中的向量，它们的乘积 $c \cdot u$ 也属于 $V$。

**八个向量空间公理：**

> 2个加法，3个乘法，3个存在

1. **加法 - 结合律：**
   - **公理：** 对于任意 $u, v, w$ 属于向量空间 $V$，满足 $(u + v) + w = u + (v + w)$。

2. **加法 - 交换律：**
   - **公理：** 对于任意标量 $c$ 和任意 $u, v$ 属于向量空间 $V$，满足 $(c_1 + c_2) \cdot u = c_1 \cdot u + c_2 \cdot u$。

3. **乘法 - 标量乘法结合律：**
   - **公理：** 对于任意 $u, v$ 属于向量空间 $V$，满足 $u + v = v + u$。

4. **乘法 - 分配律1（标量对加法的分配）：**
   - **公理：** 对于任意标量 $c$ 和任意 $u$ 属于向量空间 $V$，满足 $(c_1 \cdot c_2) \cdot u = c_1 \cdot (c_2 \cdot u)$。

5. **乘法 - 分配律2（标量对标量的分配）：**
   - **公理：** 对于任意标量 $c$ 和任意 $u, v$ 属于向量空间 $V$，满足 $c \cdot (u + v) = c \cdot u + c \cdot v$。

6. **存在 - 零向量存在：**
   - **公理：** 存在零向量 $\mathbf{0}$ 属于向量空间 $V$，使得对于任意 $u$ 属于 $V$，满足 $u + \mathbf{0} = u$。

7. **存在 - 逆元存在：**
   - **公理：** 对于每个 $u$ 属于向量空间 $V$，存在逆元素 $-u$，使得 $u + (-u) = \mathbf{0}$。

8. **存在 - 单位元存在：**
   - **公理：** 存在标量 $1$，使得对于任意 $u$ 属于向量空间 $V$，满足 $1 \cdot u = u$。

要想验证一个集合V 是否是一个向量空间，首先我们需要明确V 上的加法和标量积是如何定义；接下来验证V 关于加法的封闭性与V 关于标量积的封闭性，即验证对任何u, v ∈ V 与任何实数c ∈ R，都有u + v ∈ V 以及cv ∈ V ；最后验证V 上的加法与标量积满足以上定义中所提到的性质

**推论**

- $0\mathbf v=\mathbf 0$
- $\lambda\mathbf0=\mathbf0$
- $(-1)\mathbf v = -\mathbf v$
- $\text{If } \lambda \mathbf v = 0\text{, then } \lambda = 0 \text{ or } \mathbf v = \mathbf 0$

---

### 子空间

**成立：** 子空间成立只需要考虑 **对加法/数乘封闭**

**例子：**
- Zero subspace: Only $\mathbf 0$
- Matrix subspace: Sym. / Tri. / Diag.
- Function subspace on $\mathbb{R}$
	- $\small F(-\infty,\infty)\supseteq C(-\infty,\infty)\supseteq C^{1}(-\infty,\infty)\supseteq C^{m}(-\infty,\infty)\supseteq C^{\infty}(-\infty,\infty)\supseteq P_{\infty}\supseteq P_{n}$
	- $C$:连续函数 $C^m$:$m$次连续可导 $C^\infty$:任意阶可导函数 $P_n$:次数小于等于$n$的多项式函数

**反例：**
- 可逆矩阵：$0A=A+(-A)=\mathbf0$不可逆

**性质**

- 交集是子空间
- 加和（$U+W\xlongequal{\Delta}\left\{\mathbf u + \mathbf w:\mathbf u\in U,\mathbf w\in W  \right\}$是子空间
- **并集并不一定是子空间**

> [!definition]
> Linear dependence/independence; linear combination; span; basis; dimension.

### 线性组合

略

### 线性相关/无关

> 当v1, . . . , vr满足何种条件时，这样的线性组合表示是唯一的？

判断给定的一组向量是否线性无关<=>$\sum k_{i}\mathbf v_{i}=\mathbf 0\text{ if and only if }k_{i}=0$<=>$[\mathbf v_{1}|\dots|\mathbf v_{n}]=A\mathbf x=\mathbf 0\text{ only trivival solution}$<=>$A \text{ is invertible}$<=>$\textcolor{orange}{\det(A)\ne0}$

### 线性张成

### 基底

- 1. S张成V ；
- 2. S线性无关，

定义中的(1)指出S中的向量足够多，而(2)指出S中没有冗余的向量

性质

### 标准基

在F-线性空间Mm×n(F)中取集合{Eij : 1 ≤ i ≤ m, 1 ≤ j ≤ n}，其中Eij 表示第i行、第j列的元素为1，其余元素为0的矩阵. 它们构成一组基，称为Mm×n(F)的标准基.

> [!definition]
> Row/Column/Null space of a matrix; rank; nullity

在线性代数中，矩阵的行空间、列空间和零空间是与矩阵相关的一些基本概念，而秩和零度是描述这些空间维数的量。

### 行空间

**定义**: 矩阵的行空间是其所有**行向量的线性组合所构成的空间**。对于一个矩阵$A$，其行空间通常表示为 Row(A) 或$\text{span}(\text{rows of } A)$。

如果矩阵$A$是一个$m \times n$矩阵，那么行空间是$\mathbb{R}^n$中的一个子空间。

**基**: 把矩阵$A$行简化（使用行简化阶梯形或最简行阶梯形），不为零的行将形成行空间的一个基。

### 列空间

**定义**: 矩阵的列空间是其所有列向量的线性组合所构成的空间。对于一个矩阵$A$，其列空间通常表示为 Col(A) 或$\text{span}(\text{columns of } A)$。

列空间也被称为矩阵的值域或范围，是$\mathbb{R}^m$中的一个子空间。

**基**: 通过观察矩阵$A$的行简化形式，可以确定哪些列包含了领导1（即在每个行最左非零项），这些列在原矩阵$A$中对应的列向量将构成列空间的一个基。

### 零空间（Null Space）

**定义**: 矩阵$A$的零空间是所有满足$A \mathbf{x} = \mathbf{0}$的向量$\mathbf{x}$的集合，通常表示为 Null(A)。

零空间即解空间，表示了线性系统$Ax=0$的所有解。零空间是$\mathbb{R}^n$的一个子空间。

**基**: 要找到零空间的基，需解齐次方程$A \mathbf{x} = \mathbf{0}$，并找出自由变量对应的参数向量，这些参数向量就构成了零空间的基。

#### **找基**
**RREF**的**主1**的行向量张成RREF矩阵R的行空间的一组基底
=>==组成A行空间的一组基底==

**RREF**的**主1**的列向量张成RREF矩阵R的列向量的基底
=>**对应原来的**A的列组成A列空间的一组基底

### 秩（Rank）

**定义**: 矩阵$A$的秩是其行空间（等价地，列空间）的维数，表示为 rank(A)。

秩也可以看作是线性独立的行或列的最大数目，给出了矩阵可以“表示”多少维度空间。

**公式**: 如果$A$是一个$m \times n$矩阵，那么$\text{rank}(A) = \text{dimension of Row}(A) = \text{dimension of Col}(A)$

### 零度（Nullity）

**定义**: 矩阵$A$的零度是其零空间的维数，表示为 nullity(A)。

零度给出了线性系统$A\mathbf{x}=\mathbf{0}$解的“自由度”。

**公式**: 对于一个$m \times n$矩阵$A$，$\text{nullity}(A) = \text{dimension of Null}(A)$

### 秩-零度定理（Rank-Nullity Theorem）

$$\text{rank}(A) + \text{nullity}(A) = n$$

其中$n$是矩阵的列数。这个定理说明了$\mathbb{R}^n$中向量空间的维数可以通过矩阵的秩和零度来划分：$n$不仅是列空间的维数（即秩），还是零空间的维数（即零度）之和。

以上就是这些概念的基本描述和相关公式。在实际应用中，了解和使用这些概念可以帮助你解决各种线性代数问题，如求解线性方程组、分析线性变换等。

# Chap.04

## 特征向量与特征值

### 定义

进行线性变换之后仍在同一方向：相当于只进行了伸缩变换

![../res/GIF 2023-12-17 20-01-12.gif](../res/GIF%202023-12-17%2020-01-12.gif)

$$
\underbrace{ A\mathbf{v} }_{ \text{Matrix Product} }=\underbrace{ \lambda \mathbf{v} }_{ \text{Scalar Product} }
$$

也即

$$
A\mathbf{v}=(\lambda I) \mathbf{v}
$$

即

$$
(A-\lambda I)\mathbf{v}=\mathbf{0}
$$


此时 $\mathbf{v}$ 就是一个**特征向量**，且 $\lambda$ 就是这个特征向量的**特征值**

### 求解

#### 行列式为0

![../res/GIF 2023-12-17 19-52-13.gif](../res/GIF%202023-12-17%2019-52-13.gif)

此时 $\lambda$ 有解，即

$$
\det(A-\lambda I)=0
$$

值得注意的是，我们可以直接书写成

$$
\begin{bmatrix}a_{11}-\lambda & a_{12} & a_{13} \\
a_{21} & a_{22}-\lambda & a_{23} \\
a_{31} & a_{32} & a_{33}-\lambda\end{bmatrix}
$$


#### Mean-Product Formula (2x2)

> [!formula] Mean-Product Formula
> $$
> \lambda_{1,2}=m \pm \sqrt{ m^2 -p }
> $$
> 
> 其中
> $m=\frac{\lambda_{1}+\lambda_{2}}{2}=\frac{\text{tr}(A)}{2};$
> $p=\lambda_{1}\lambda_{2}=\det(A)$

