---
share: true
---


# 积分表

![../res/无标题.png](../res/%E6%97%A0%E6%A0%87%E9%A2%98.png)

1. $\displaystyle \int k \mathrm{~d} x=k x+C\quad\left(\int 0 \mathrm{~d} x=C\right)$;
2. $\displaystyle \int x^\alpha \mathrm{d} x=\frac{1}{\alpha+1} x^{\alpha+1}+C \quad(\alpha \neq-1)$;<br>*常用形式：*
	- $\displaystyle \int x\mathrm d x=\frac{1}{2}x^{2}$ 
	- $\displaystyle \int \sqrt{x} \mathrm d  x=\frac{2}{3} x^{\frac{3}{2}}+C$
	- $\displaystyle \int \frac{\mathrm d  x}{\sqrt{x}}=2 x^{\frac{1}{2}}+C=2 \sqrt{x}+C$
	- $\displaystyle \int \frac{\mathrm d  x}{x^2}=-x^{-1}+C=-\frac{1}{x}+C$
3. $\displaystyle \int \frac{1}{x} \mathrm{~d} x=\ln \textcolor{orange}{ |x| }+C$;
    - ***P.S.*** $\ln x$ 的定义域为 $x>0$, $\frac{1}{x}$ 的定义域为 $x\neq 0$ 故需要绝对值
   - $\displaystyle \int \frac1{ax+b}\mathrm dx=\frac{\ln|ax+b|}{a}+C$
5.  $\displaystyle \int a^x \mathrm{~d} x=\frac{a^x}{\ln a}+C \quad(0<a \neq 1)$;
	- ***P.S.*** $(a^x)'=\ln a\cdot a^x$
5. $\displaystyle \int \mathrm{e}^x \mathrm{~d} x=\mathrm{e}^x+C$;
6. $\displaystyle \int \sin x \mathrm{~d} x=-\cos x+C$;
7. $\displaystyle \int \cos x \mathrm{~d} x=\sin x+C$;
8. $\displaystyle \int \sec ^2 x \mathrm{~d} x=\tan x+C$;
   
   - $\displaystyle \int \sec x \mathrm d x=\ln\left|\sec x+\tan x\right|$
   
9. $\displaystyle \int \csc ^2 x \mathrm{~d} x=-\cot x+C$;
   - $\displaystyle \int \csc x \mathrm d x = \ln\left(\tan \frac{x}{2}\right)$
   
10. $\displaystyle \int \frac{\mathrm{d} x}{a^2+x^2}=\frac{1}{a} \arctan \frac{x}{a}+C(a \neq 0)$;
    
    ***P.S.*** $\left(\frac{1}{a} \arctan \frac{x}{a}\right)^{\prime}=\frac{1}{a} \cdot \frac{1}{a} \frac{1}{1+\left(\frac{x}{a}\right)^2}=\frac{1}{a^2+x^2}$
    
    - $\displaystyle \int\frac{\mathrm dx}{1+x^{2}}=\arctan x+C$
	  
11.  $\displaystyle \int \frac{\mathrm{d} x}{x^2-a^2}=\frac{1}{2 a} \ln \left|\frac{x-a}{x+a}\right|+C\quad(a \neq 0)$;
    
     - $\displaystyle \int \frac{d x}{a^2-x^2}=\frac{1}{2 a} \ln \left|\frac{x+a}{x-a}\right|+C$
	  
12. $\displaystyle \int \frac{\mathrm{d} x}{\sqrt{a^2-x^2}}=\arcsin \frac{x}{a}+C(a>0)$;
    
13. $\displaystyle \int \frac{\mathrm{d} x}{\sqrt{x^2 \pm a^2}}=\ln \left|x+\sqrt{x^2 \pm a^2}\right|+C$.

##### 补充不定积分

-  $\int \tan(x) \mathrm d x=\ln(\cos(x))$
- $\int \sqrt{ x^{2}\pm a^{2} } \, dx=\frac{x}{2}\sqrt{ x^{2}\pm a^{2} }\pm \frac{a^{2}}{2}\ln \left| x+\sqrt{ x^{2}\pm a^{2} } \right|+C$
- $\int \sqrt{ a^{2}-x^{2} } \, dx=\frac{x}{2} \sqrt{ a^{2}-x^{2} } +\frac{a^{2}}{2} \arcsin \frac{x}{a} + C$
- $I(m,n)=\int \cos ^{m}x\sin ^{m}x \, dx=\dots$(递推公式)

## 部分积分推导

### $\int \frac{1}{x^2+a^2} \, dx$

> ***Tips*** **"AA"**
> 
> $(\arctan x)'=\frac{1}{1+x^2}$
> 
> $\left(\textcolor{orange}{ \frac{1}{a} } \arctan \frac{x}{\textcolor{Cyan}{ a }}\right)^{\prime}=\textcolor{orange}{ \frac{1}{a} } \cdot \textcolor{Cyan}{ \frac{1}{a} } \frac{1}{1+\left(\frac{x}{a}\right)^2}=\frac{1}{a^2+x^2}$
> 
> ***Solution***
> 
> \begin{align*} 
> \begin{flalign}
> &\text{Assuming } a>0\newline &=\frac{1}{a^{2}}\int \frac{1}{1+\left( \frac{x}{a} \right)^{2} } \, dx \newline &=\frac{1}{a}\int \dfrac{\left( \frac{x}{a} \right)}{1+\left( \frac{x}{a} \right)^{2}}+C 
> \end{flalign}
>  \end{align*}

### $\int \frac{1}{x^{2}-a^{2}} \, dx$

> ***Tips*** **∓** 
> 
> \begin{align*} 
> {\text{凑2a}\implies} \frac{1}{x-a}-\frac{1}{x+a}\implies \dfrac{x-a}{x+a}
>  \end{align*}
> 
> ***Solution***
> 
> \begin{align*} 
> \begin{flalign}
> &\text{Assuming } a\neq 0\newline &= \int \dfrac{1}{(x+a)(x-a)} \, dx \newline &= \frac{1}{2a}\left( \int \frac{1}{x-a} \, dx - \int \frac{1}{x+a} \, dx  \right)\newline &=\frac{1}{2a}\left( \ln|x-a|-\ln|x+a| \right)+C\newline &=\frac{1}{2a}\ln \left| \dfrac{x-a}{x+a} \right| +C
> \end{flalign}
>  \end{align*}

### $\int \frac{1}{\sqrt{ a^{2}-x^{2} }} \, dx$

> ***Tips***
> 
> $(\arcsin x)'=\frac{1}{\sqrt{ 1-x^{2} }}$
> 
> $\textcolor{lightgray}{ (\arccos x)'=-\frac{1}{\sqrt{ 1-x^{2} }} }$
> 
> ***Solution***
> 类似 $\int \frac{1}{x^2+a^2} \, dx$
> 
> \begin{align*} 
> \begin{flalign}\newline &\text{Assuming } a>0\newline &\int \frac{1}{\sqrt{ a^{2}-x^{2} }}\newline &= \frac{1}{a}\int \frac{1}{\sqrt{ 1-\left( \frac{x}{a} \right)^{2} }} \, dx\newline &=\int \frac{1}{\sqrt{ 1-\left( \frac{x}{a} \right)^{2} }} \, d\left( \frac{x}{a} \right)\newline &=\arcsin\left( \frac{x}{a} \right)+C
> \end{flalign}
>  \end{align*}

### $\int \frac{1}{\sqrt{ x^{2}\pm a^{2} }} \, dx$

#### $\int \frac{1}{\sqrt{ x^{2} + a^{2} }} \, dx$

> ***Tips***
> 
> <b class="md-tag">三角代换</b> 
> 
> 对边：$\sqrt{ x^{2}-a^{2} }$
> 邻边：$a$
> 斜边：$x$
> 
> ***Solution***
> 
> \begin{align*} 
> \begin{flalign}
> &\int \frac{1}{\sqrt{ x^{2}-a^{2} }} \, dx \newline &\xlongequal{ x=a\sec t }\int \frac{1}{a\tan t} \, d\left( a\sec t \right) & 0 < t < \frac{\pi}{2}\newline &=\int \frac{1}{\tan t} t \, d\sec t\newline &=\int \frac{1}{\tan t} \sec t\tan t\, dt \newline &=\int \sec t \, dt \newline &=\ln|\sec t+\tan t| + C\newline &=\ln\left| \frac{x}{a} + \dfrac{\sqrt{ x^{2}-a^{2} }}{a}\right| + C & \bigstar \text{ 还原}
> \end{flalign}
>  \end{align*}

#### $\int \frac{1}{\sqrt{ x^{2} + a^{2} }} \, dx$

> ***Tips***
> 
> <b class="md-tag">三角换元</b>
> 
> 对边：$x$
> 邻边：$a$
> 斜边：$\sqrt{ x^{2}+a^{2} }$
> 
> ***Solution***
> 
> \begin{align*} 
> \begin{flalign}
> &\int \frac{1}{\sqrt{ x^{2} + a^{2} }} \, dx\newline &\xlongequal{ x=a \tan t } \int \frac{1}{a\sec t} \, d(a\tan t)\newline &=\int \frac{1}{\sec t}\sec ^{2}t \, dx \newline &=\int \sec t \, dt \newline &\text{同上}\newline &=\ln\left| \frac{x}{a} + \dfrac{\sqrt{ x^{2}+a^{2} }}{a}\right| + C & \bigstar \text{ 还原}
> \end{flalign}
>  \end{align*}

> **综上**
> 
> \begin{align*} 
> \int \frac{1}{\sqrt{ x^{2}\pm a^{2} }} \, dx = \ln\left| \frac{x}{a} + \dfrac{\sqrt{ x^{2}\pm a^{2} }}{a}\right| + C
>  \end{align*}

### $\int \tan x\, dx$

> ***Solution***
> 
> \begin{align*} 
> \begin{aligned}
> &=\int \dfrac{\textcolor{orange}{ \sin x }}{\cos x} \, dx\newline &=\textcolor{orange}{ - }\int \frac{1}{\cos x} \, d\textcolor{orange}{ \cos x }\newline &=-\ln \left|\cos x\right|+C
> \end{aligned}
>  \end{align*}

### $\int \sec x \, dx$

> ***Solution.I***
> 
> \begin{align*} 
> \begin{aligned}
> &=\int \dfrac{\sec x \textcolor{orange}{ \cdot(\sec x+\tan x) }}{\textcolor{orange}{ \sec x+\tan x }} \, dx\newline \because~&(\sec x + \tan x)'=\dfrac{\sin x}{\cos ^{2}x}+\frac{1}{\cos ^{2}x}=\sec x\cdot(\sec x+\tan x)\newline &=\int \dfrac{d(\sec x+\tan x)}{\sec x+\tan x}\newline &=\ln|\sec x+\tan x|+C
> \end{aligned}
>  \end{align*}
> 
> ***Solution.II***
> 
> \begin{align*} 
> \begin{aligned}
> &=\int \dfrac{\cos x}{\cos ^{2} x} \, dx \newline &=-\int \dfrac{d\sin x}{1-\sin ^{2}x} \, dx \newline &=-\frac{1}{2}\ln\left( \frac{1+\sin x}{1-\sin x} \right)+C
> \end{aligned}
>  \end{align*}

### $\int \csc x \, dx$

> ***Solution.I***
> 
> \begin{align*} 
> \begin{aligned}
> &=\int \textcolor{orange}{ - }\dfrac{\csc x\textcolor{orange}{ \cdot-(\csc x+\cot x) }}{\textcolor{orange}{ \csc x+\cot x }} \, dx \newline \because~&\left( \csc x+\cot x \right)'=-\csc x\cdot(\csc x+\cot x)\newline &=-\int \dfrac{d(\csc x+\cot x)}{\csc x+\cot x} \, dx \newline &=-\ln|\csc x+\cot x|+C\newline &\textcolor{Gray}{ =-\ln \left| \tan \frac{x}{2} \right|  }
> \end{aligned}
>  \end{align*}
> 
> ***Solution.II***
> 
> 同上，$\displaystyle=-\frac{1}{2}\ln \left( \dfrac{1+\cos x}{1-\cos x} \right)$

### $I(m,n)=\int \cos ^{m}x\sin ^{m}x \, dx$

\begin{align*} 
\begin{flalign}
I(m,n)&=-\frac{1}{m+1}\int \sin ^{\textcolor{orange}{ n-1 }}x \, d(\cos ^{\textcolor{orange}{ m+1 }}x)\\
&=-\frac{1}{m+1}\left( \sin ^{n-1}x\cos ^{m+1}x-\int \cos ^{m+1}x \, d\sin ^{n-1}x  \right) \dots\text{分部积分}\\
&=-\frac{1}{m+1}\sin ^{n-1}x\cos ^{m+1}x + \dfrac{n-1}{m+1}\int \sin ^{n-2}x \cos ^{m\textcolor{red}{ +2 }}x \, dx \\
&=-\frac{1}{m+1}\sin ^{n-1}x\cos ^{m+1}x + \dfrac{n-1}{m+1}\sin ^{n-2}x\cos ^{m}x\textcolor{red}{ (1-\sin ^{2}x) }\,dx\\
&=-\frac{1}{m+1}\sin ^{n-1}x\cos ^{m+1}x + \dfrac{n-1}{m+1}\sin ^{n-2}x\cos ^{m}x\,dx\\&\qquad+\dfrac{1-n}{m+1}\int \sin ^{n}x\cos ^{m}x \, dx \\
\therefore~ \frac{m+n}{m+1}I(m,n)&=-\frac{1}{m+1}\sin ^{n-1}x\cos ^{m+1}x+ \dfrac{n-1}{m+1}I(m,n-2)\\
\implies I(m,n)&=-\frac{1}{m+n}\sin ^{n-1}x\cos ^{m+1}x+ \dfrac{n-1}{m+n}I(m,n-2)\quad(m\geq 0,n\geq 2)\\
\text{同理: } I(m,n)&=-\frac{1}{m+n}\cos ^{m-1}x\sin ^{n+1}x+ \dfrac{m-1}{m+n}I(m-2,n)\quad(m\geq 2,n\geq 0)
\end{flalign}
 \end{align*}

## 典题整理

### $\int_0^{\frac{\pi}{2}}\sqrt{\tan x}{\mathrm d}x$

\begin{align*} 
\begin{align*} \int_0^{\frac{\pi}{2}}\sqrt{\tan x}{\mathrm d}x&=2\left(\int_0^1+\int_1^{+\infty}\right)\frac{x^2}{1+x^4}{\mathrm d}x\\ &=2\int_0^1\frac{x^2}{1+x^4}{\mathrm d}x+2\int_0^{1}\frac{1}{1+x^4}{\mathrm d}x\\ &=2\int_0^1 \frac{{\mathrm d}\left(x-\frac{1}{x}\right)}{\left(x-\frac{1}{x}\right)^2+2}\\ &=2\int_{-\infty}^0\frac{{\mathrm d}x}{x^2+2}\\ &=\frac{\pi}{\sqrt{2}}. \end{align*}
 \end{align*}