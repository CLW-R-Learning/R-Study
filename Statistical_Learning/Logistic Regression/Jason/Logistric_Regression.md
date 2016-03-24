# Logistic Regression
Chih-Hui Wang (Jason)  
Tuesday, April 21, 2015; Revised: March 24, 2016  


### 1. Introduction to Generalized Linear Models(GLM)

There are three components in the GLM:    

* Random Component: the response variable $Y$ and an associated probability distribution.

* Systematic Component: the explanatory variables $x_{1},...,x_{p}$

* Link Function: the functional relationship between $x_{1},...,x_{p}$ and $E(Y)$

 $Y$ | Link function 
 ------------- | ------------- 
$N(\mu,\sigma^2)$ | $E(Y)$ 
$Poisson(\lambda)$ | $log(E(Y))$ 
$Binomial(n, p)$ | $log \frac{E(Y)}{n-E(Y)}$ 

### 2. Logistic Regression

First, we introduce the logistic function or sigmoid function.
$$s(x) = \dfrac{e^{\alpha + \beta x}}{1+e^{\alpha + \beta x}}$$


```r
logistic <- function(x, alpha, beta){
    exp(alpha + beta*x)/(1 + exp(alpha + beta*x))
}

# plot
x <- seq(-10, 10, by=0.1)

# Beta < 0
plot(x, logistic(x, 0, -1), type="l", main="Logistic Function", col="darkorange",
     xlab="x", ylab="probability", lwd=4)

# Beta > 0
lines(x, logistic(x, 0, 1), type="l", col="dodgerblue", lwd=4)

# Beta = 0
lines(x, logistic(x, 0, 0), type="l", lwd=4)

# Add text
text(8, 0.9, expression(beta), cex=1.5)
text(-8, 0.9, expression(beta), cex=1.5)
text(9, 0.9, "  > 0", cex=1.5); text(-7, 0.9, "  < 0", cex=1.5)
text(1.5, 0.55, expression(beta), cex=1.5)
text(2.5, 0.55, "  = 0", cex=1.5)
```

<img src="Logistric_Regression_files/figure-html/logistic_function-1.png" title="" alt="" style="display: block; margin: auto;" />

If $\beta$ is bigger than 0, then the probability will increase as x goes up; on the other hand, if $\beta$ is less than 0, the probability will decrease as x goes up. Finally, when $\beta$ is equal to 0, the probability will always be 0.5 given $\alpha$ is 0.

Since the function can map any real value to the interval $[0, 1]$, it gives us a thought that perhaps we can utilize this property to fit a model to the binary response data, which is the idea of logistic regression.

$$E(y|X) = 1 \times P(y=1|X) + 0 \times P(y=0|X) = P(y=1|X)$$

We model $E(y|X)$ using the logistic function:
$$p = E(y|X) = \dfrac{e^{\alpha + \beta_{1}x_{1} + \beta_{2}x_{2} + ... + \beta_{p}x_{p}}}{1+e^{\alpha + \beta_{1}x_{1} + \beta_{2}x_{2} + ... + \beta_{p}x_{p}}}$$

With some manipulation, we can get
$$\frac{p}{1-p} = e^{\alpha + \beta_{1}x_{1} + \beta_{2}x_{2} + ... + \beta_{p}x_{p}}$$

$\frac{p}{1-p}$ is called the odds and take on any value from 0 to $\infty$. If the odds is high, the probability is high, and vice versa.

Take log for both side

$$log(\dfrac{p}{1-p}) = \alpha + \beta_{1}x_{1} + \beta_{2}x_{2} + ... + \beta_{p}x_{p}$$

From the left-hand side, we get a function called *logit* function. $logit(p) = log(\frac{p}{1-p})$. The logit function is exactly the **link function** between $E(Y)$ and $x_{1},...,x_{p}$.

#### ● Interpretation of Logistic Regression

The interpretation of the coefficients $x_{i}$ is entirely different from the linear regression. In the logistic regression, the interpretation is that given other variables constant, increasing $x_{i}$ by one unit change the log-odds of $E(Y)$ or $p$ by $\beta_{i}$ unit or, equivalently, multiplies the odds of $p$ by $e^{\beta_{i}}$. Most importantly, The amount that $p$ changes due to a one-unit change in $x_{i}$ will depend on the current value of $x_{i}$.

#### ● Estimation of Coefficients

In logistic regression, we use *maximum likelihood estimation* to estimate coefficients. Recall that our $Y$ is from the binomial distribution, assuming $n$ data, we can use the *likelihood function*:

\begin{align}
l(\alpha, \beta_{1}, \beta_{2},..., \beta_{p}) &= \prod_{i=1}^{n} p(y_{i}|x_{i}) \\
  &= \prod_{i=1}^{n} [\dfrac{e^{\alpha + \beta_{1}x_{1i} + \beta_{2}x_{2i} + ... + \beta_{p}x_{pi}}}{1+e^{\alpha + \beta_{1}x_{1i} + \beta_{2}x_{2i} + ... + \beta_{p}x_{pi}}}]^{y_{i}} [\dfrac{1}{1+e^{\alpha + \beta_{1}x_{1i} + \beta_{2}x_{2i} + ... + \beta_{p}x_{pi}}}]^{1-y_{i}}
\end{align}

and our goal is to find out the coefficients $\alpha, \beta_{1}, \beta_{2},...,\beta_{p}$ which maximize the likelihood function. Usually, we will use log likelihood function:

$$l = \sum_{i=1}^{n} y_{i}log(p_{i}) + \sum_{i=1}^{n} (1-y_{i})log(1-p{i})$$
where　$p_{i} = \dfrac{e^{\alpha + \beta_{1}x_{1i} + \beta_{2}x_{2i} + ... + \beta_{p}x_{pi}}}{1+e^{\alpha + \beta_{1}x_{1i} + \beta_{2}x_{2i} + ... + \beta_{p}x_{pi}}}$

1. Gradient Ascent

So now we have a optimization problem: we need to find the $\alpha, \beta$ that maximize the log likelihood. We can use gradient ascent. We rewrite the log likelihood function into matrix form

$$l = \sum_{i=1}^{n} y_{i} \log{s(X_i\beta) + (1 - y_{i})\log{(1 - s(X_i\beta))}}$$
where $\beta$ is a vector with length $n + 1$ (including $\alpha$) and $X_i$ is the obervation $i$. We need to find the gradient of the log-likelihood function, let $s_i = s(X_i \beta)$,

\begin{align}
  \Delta l &= \sum_{i=1}^{n} y_{i}\frac{\Delta s_i}{s_i} - (1 - y_{i})\frac{\Delta s_i}{1 - s_i} \\
  &= \sum_{i=1}^{n} (\frac{y_i}{s_i} - \frac{1-y_i}{1-s_i})s_i(1 - s_i)X_i \\
  &= \sum_{i=1}^{n}(y_i - s_i)X_i = X^T(y - s)
\end{align}

Note that $s'(x) = s(x)(1 - s(x))$. Therefore, the gradient ascent rule is 
$$\beta_{t + 1} = \beta_{t} + \epsilon\sum_{i=1}^{n} (y_i - s(X_i \beta_{t}))X_i$$
Keep updating the parameters until the difference is smaller than a certain threshold.

2. Newton Method  

Idea: You are at point $v$. Approximate the function near $v$ by a quadratic function and jump to its unique critical point. Repeat until convergence.    
We use Taylor series: $\Delta l(\beta) = \Delta l(v) + (\Delta^2 l(v))(\beta - v) + O(|\beta - v|^2)$ and find the critical point by setting $\Delta l(\beta) = 0$. We get $w = v - (\Delta^2 l(v))^{-1} \Delta l(v))$. Here is the summary of the algorithm:

```r
# Algorithm: picking starting point w
# repeat until convergence:
#       e <- solution to the linear system (\Delta^2 l(\beta)e=-\Delta l(\beta)) 
#       beta <- beta + e 
```
In logistic regression, we need to calculate the hessian of the log likelihood function. 
$$\Delta^2 l = - \sum_{i=1}^{n}s_i(1-s_i)X_iX_{i}^{T}=-X^T\Omega X$$
we solve $e$ in the normal equation $(X^{T} \Omega X)e = X^T(y-s)$ where $\Omega$ is a diagonal matrix with components $s_i(1-s_i)$. 

When you fit the GLM in the statistical software, they will output the deviance for you which is defined as $D=-2l$.  (Note: In R, its output is -2log($l$), i.e. Deviance, while in SAS, the output is log($l$), i.e. Log likelihood function) The idea of deivance is really similar to sum of square in regression:
$$\mbox{Regression model} \rightarrow \mbox{analysis of variance (compare "sum of square")}$$
$$\mbox{Generalized linear model} \rightarrow \mbox{analysis of deviance (compare "deviance")}$$

#### ● Hypothesis Testing: three Main Types of Statistical Tests for GLMs

1. Wald test    
The Wald test statsitic　$$Z = \dfrac{\hat \beta}{ASE} \xrightarrow[ ]{D} N(0, 1)$$
The summary function to glm will automatically provide us the Wald test.

```r
# Simulated Data
y <- rbinom(100, 1, 0.8)
x <- rnorm(100)
model <- glm(y ~ x, family=binomial)

coef(summary(model))
```

```
             Estimate Std. Error  z value     Pr(>|z|)
(Intercept) 1.5461923  0.2820321 5.482327 4.197674e-08
x           0.5328224  0.2573481 2.070435 3.841163e-02
```

2. Likelihood ratio test    
The likelihood-ratio statistic
$$l = -2log(\dfrac{l_{o}}{l_{1}}) = -2(log l_{0} - log l_{1}) = -2(L_{0} - L_{1}) \xrightarrow[ ]{D} \chi^2_{1}$$


```r
library(lmtest)
# Likelihood ratio test
lrtest(model)
```

```
Likelihood ratio test

Model 1: y ~ x
Model 2: y ~ 1
  #Df  LogLik Df Chisq Pr(>Chisq)  
1   2 -47.726                      
2   1 -50.040 -1 4.629    0.03144 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The log likelihood function here is equal to the deviance divided by 2. Also we can use the anova function to do likelihood ratio test.


```r
anova(model, test="LRT")
```

```
Analysis of Deviance Table

Model: binomial, link: logit

Response: y

Terms added sequentially (first to last)

     Df Deviance Resid. Df Resid. Dev Pr(>Chi)  
NULL                    99    100.080           
x     1    4.629        98     95.451  0.03144 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

3. Score (Rao) test
The efficient score statistics　$$S \xrightarrow[ ]{D}\chi^2_{1}$$

We can use the anova function to do likelihood ratio test.

```r
anova(model, test="Rao")
```

```
Analysis of Deviance Table

Model: binomial, link: logit

Response: y

Terms added sequentially (first to last)

     Df Deviance Resid. Df Resid. Dev   Rao Pr(>Chi)  
NULL                    99    100.080                 
x     1    4.629        98     95.451 4.508  0.03374 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

In generally, the three test would give you the same conclusion for significance. If it is not, the suggestion is to collect more data. However, if you cannot get more data, then take the likelihood ratio test because LR test is more conservative.

### 3. Linear Discriminant Analysis vs. Logistic Regression

Advantage of LDA:    
a. For well separated data, LDA is stable while logistic regression is relatively unstable.    
b. For more than two classes, LDA is easy and elegant to generalize; logistic regression needs modifying.    
c. Slighly more accurate when classes are nearly normal, especially if $n$ is small.

Advantage of logistic regression:    
a. More emphasis on the decision boundary.    
b. Less sensitive to outliers.    
c. More robust on some non-Gaussian distribution.

### 4. Example on the Textbook

```r
library(ISLR)
summary(Default)
```

```
 default    student       balance           income     
 No :9667   No :7056   Min.   :   0.0   Min.   :  772  
 Yes: 333   Yes:2944   1st Qu.: 481.7   1st Qu.:21340  
                       Median : 823.6   Median :34553  
                       Mean   : 835.4   Mean   :33517  
                       3rd Qu.:1166.3   3rd Qu.:43808  
                       Max.   :2654.3   Max.   :73554  
```


```r
with(Default, plot(balance, income, type="n", xlab="Balance", ylab="Income"))
split_data <- split(Default, Default$default)

no_df <- split_data[[1]]
df <- split_data[[2]]

with(no_df, points(balance, income, pch=1, cex=0.8, col="dodgerblue"))
with(df, points(balance, income, pch="+", cex=1.2, col="darkorange"))
```

<img src="Logistric_Regression_files/figure-html/unnamed-chunk-2-1.png" title="" alt="" style="display: block; margin: auto;" />


```r
library(car)
Default$default <- as.numeric(as.character(
    recode(Default$default, "'Yes'='1'; 'No'='0'")))
```


```r
#Page 131
#Regression
model1 <- lm(default ~ balance, data=Default)

#Logistic Regression
model2 <- glm(default ~ balance, data=Default, family=binomial)
```


```r
par(mfrow=c(1, 2))
with(Default, plot(balance, default, col="darkorange",
                   pch="|", cex=0.5, main="Regression",
                   xlab="Balance", ylab="Probability Default"))
abline(h=c(1, 0), lty=2)
abline(model1, col="dodgerblue", lwd=2)


with(Default, plot(balance, default, col="darkorange",
                   pch="|", cex=0.5, main="Logistic Regression",
                   xlab="Balance", ylab="Probability Default"))
abline(h=c(1, 0), lty=2)

curve(predict(model2, data.frame(balance=x), type="resp"),
      add=TRUE, lwd=2, col="dodgerblue")
```

<img src="Logistric_Regression_files/figure-html/unnamed-chunk-5-1.png" title="" alt="" style="display: block; margin: auto;" />



```r
#balance
model2 <- glm(default ~ balance, data=Default, family=binomial)
#student
model3 <- glm(default ~ student, data=Default, family=binomial)
#all
model4 <- glm(default ~ balance + income + student, data=Default, family=binomial)
```


```r
Default$student <- as.numeric(as.character(recode(Default$student, "'Yes'='1'; 'No'='0'")))

fit_p <- fitted(model4)
D <- cbind(Default, fit_p)
D <- D[order(D$balance), ]
average <- tapply(Default$default, Default$student, mean)
plot(D$balance[D$student == 1], D$fit_p[D$student == 1],
     main="Student vs. Non Student",
     xlab="Balance", ylab="Probability",
     type="l", col="dodgerblue", lwd=2)
lines(D$balance[D$student == 0], D$fit_p[D$student == 0],
      type="l", col="darkorange", lwd=2)
abline(h=average[1], col="darkorange", lty=2, lwd=2)
abline(h=average[2], col="dodgerblue", lty=2, lwd=2)
legend(500, 0.8, lty=1, lwd=2, col=c("dodgerblue","darkorange"),
       legend=c("Student", "Nonstudent"))
```

<img src="Logistric_Regression_files/figure-html/unnamed-chunk-7-1.png" title="" alt="" style="display: block; margin: auto;" />


```r
boxplot(balance ~ student, data=Default,
        main="Balance for student & non student",
        xlab="Student", ylab="Balance")
```

<img src="Logistric_Regression_files/figure-html/unnamed-chunk-8-1.png" title="" alt="" style="display: block; margin: auto;" />

### 5. Multinomial Logistic Regression

Also, we can generalize the method to multinomial situation. Assume that we have $g$ possible outcomes with probabilities $P[y=k]=p_{k}, k=1, 2,..., g.$

\begin{align}
p_{1}=p[y=1] &= \dfrac{1}{1+\sum_{i=2}^{g}e^{\alpha_{i}+x\beta_{i}}} \\
p_{k}=p[y=k] &= \dfrac{e^{\alpha_{k}+x\beta_{k}}}{1+\sum_{i=2}^{g}e^{\alpha_{i}+x\beta_{i}}} for k=2,..., g
\end{align}

The sum of $p_{1}, p_{2},..., p_{g}$ is equal to 1. The category 1 here is our standard category while any other group could be use instead. The log odds interpretation of the logistic regression model still applies, as
$$log(\dfrac{p_{k}}{p_{1}})=\alpha_{k}+x\beta_{k} for k=2, ...g$$

However, the interpretation become more complicated. Changing the the explanatory variable $x_{i}$ by on unit changes the odds of getting an outcome from group $k$ relative to getting an outcome from gropu 1. (Note the log odds now become $p_{k}$ v.s. $p_{1}$) For instance, if $\beta_{k}$ = 1.5, per unit change in variable $x_{i}$ increase the odds by mutiplying by $e^{1.5}$ = 4.48. Similarly, per unit change in x changes the odds of getting an outcome from group $k$ relative to getting an outcome from group $r$ by factor $e^{\beta_{k}-\beta_{r}}$ because

\begin{align}
\frac{p_{k}}{p_{r}} &= \dfrac{e^{\alpha_{k}+x\beta_{k}}}{e^{\alpha_{r}+x\beta_{r}}}=e^{\alpha{k}-\alpha{r}+x(\beta_{k}-\beta{r})}\\
log(\dfrac{p_{k}}{p_{1}}) &= \alpha_{k}-\alpha_{r}+x(\beta_{k}-\beta{r})
\end{align}

The interpreation is so complex, which may be the reason why the textbook skips this session. We generate a fictional data to run the multinomail logistic regression.

```r
# 5 categories
y <- gl(5, 20)
# normal which increases the mean
x <- rnorm(100, rep(1:5, each=20))

#Package that can run multinomial logistic regression
library(VGAM)

m_model <- vglm(y ~ x, multinomial)
summary(m_model)
```

```

Call:
vglm(formula = y ~ x, family = multinomial)

Pearson residuals:
                       Min      1Q   Median         3Q   Max
log(mu[,1]/mu[,5]) -0.9829 -0.2916 -0.02059 -0.0002813 6.491
log(mu[,2]/mu[,5]) -1.4233 -0.4828 -0.11801 -0.0079672 2.641
log(mu[,3]/mu[,5]) -1.8116 -0.4331 -0.21230 -0.0475515 3.125
log(mu[,4]/mu[,5]) -1.7402 -0.4738 -0.20762 -0.0105889 3.256

Coefficients:
              Estimate Std. Error z value Pr(>|z|)    
(Intercept):1  12.8295     2.2566   5.685 1.30e-08 ***
(Intercept):2  11.0146     2.1775   5.058 4.23e-07 ***
(Intercept):3   7.9210     1.9831   3.994 6.49e-05 ***
(Intercept):4   4.5966     1.7142   2.682  0.00733 ** 
x:1            -4.3382     0.7230  -6.000 1.97e-09 ***
x:2            -3.1711     0.6070  -5.224 1.75e-07 ***
x:3            -1.9549     0.4783  -4.087 4.37e-05 ***
x:4            -1.0111     0.3685  -2.744  0.00607 ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Number of linear predictors:  4 

Names of linear predictors: 
log(mu[,1]/mu[,5]), log(mu[,2]/mu[,5]), log(mu[,3]/mu[,5]), log(mu[,4]/mu[,5])

Dispersion Parameter for multinomial family:   1

Residual deviance: 209.3107 on 392 degrees of freedom

Log-likelihood: -104.6553 on 392 degrees of freedom

Number of iterations: 7 
```


```r
# Probability in each group
head(round(fitted(m_model), 2))
```

```
     1    2    3    4 5
1 0.55 0.37 0.07 0.01 0
2 0.50 0.39 0.09 0.01 0
3 0.86 0.14 0.01 0.00 0
4 0.97 0.03 0.00 0.00 0
5 0.77 0.21 0.02 0.00 0
6 0.52 0.39 0.09 0.01 0
```


```r
# Prediction
fit <- unlist(apply(round(fitted(m_model), 2), 1,
             function(x) as.numeric(which(x == max(x))[1])))

table(true=y, predict=fit)
```

```
    predict
true  1  2  3  4  5
   1 15  2  3  0  0
   2  6  9  5  0  0
   3  0  8  7  4  1
   4  0  3  4  6  7
   5  0  0  1  6 13
```

