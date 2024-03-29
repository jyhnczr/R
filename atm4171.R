# ---
# title: "ATM4171 Introduction to Machine Learning for Atmospheric and Earth System"
# author: ""
# output: pdf_document
# ---
#   ```{r setup, include = FALSE}
# knitr::opts_chunk$set(echo = TRUE)
# ```

## Problem 1  
### Task a

# ```{r eval = TRUE, prompt = FALSE, comment = '', fig.width = 5, fig.height = 3,fig.align='center'}  

file_path <- paste('',
                   '.csv',sep = "/")  # file path
x <- read.csv(file_path, header = TRUE)  # read source data, list
Vx_variance <- apply(x, 2, var)  # compute column variance, double
sorted_indices <- order(Vx_variance, decreasing=TRUE)  # sort variance in descending order
largest2 <- sorted_indices[1:2]  # find the largest two, int
print(largest2)

library(ggplot2)  # load plot package
data <- x[ ,largest2] 
scatter_plot <- ggplot(data, aes(x = data[,1])) + 
  geom_point(aes(y = data[,2]), color = "navy",shape = 20, size = 1) +
  labs(title = "scatter plot of variables", x = "V4", y = "V26") +
  theme(plot.title = element_text(hjust = 0.5)) 
print(scatter_plot)

# ```
# \newpage

## Problem 2
### Task a

# ```{r eval = TRUE, prompt = FALSE, comment = ''}  

A <- matrix(0,nrow = 2, ncol = 2)
A[1,1] <- 1
A[1,2] <- 2
A[2,1] <- A[1,2]
A[2,2] <- 3.14159

# Q.1
eigenv <- eigen(A)  # eigenvalues & eigenvectors
vec <- eigenv$vectors
norm2 <- apply(vec^2, 2, sum)  # norm^2
print(vec)
print(norm2)
# Norms of eigenvectors are 1. 

# Q.2
vec <- eigenv$vectors
orthonormal_criterion <- vec[,1]%*%vec[,2]  # dot product of eigenvectors
print(orthonormal_criterion)  
# Eigenvectors are orthonormal, as their norms are 1 and inner product is zero.

# Q.3
A_verify <- eigenv$value[1]*outer(vec[,1],vec[,1]) +
  eigenv$value[2]*outer(vec[,2],vec[,2])
print(A_verify)
print(all(abs(A-A_verify) < 1e-6))

# ```

# For calculation accuracy reasons, margin of error (e.g. 1e-6) should be set when comparing ***A*** and ***A_verify*** ($\sum_{i=1}^{2}\lambda_ix_ix_i^T$).

# \newpage

## Problem 3
### Task a

# ```{r eval = TRUE, prompt = FALSE, comment = ''} 

############################## FUNCTION ############################## 

XProbability <- function(X,num_omega){
  
  counts <- table(X)  # X elements' frequency, int
  prob <- counts/num_omega  # double
  X <- sort(X)  # x in ascending order, because prob. is in ascending order
  X <- unique(X)  # remove repeated x
  result <- list(X = X, prob = prob)
  return(result)  
}

Expectation <- function(X,prob,k,r,i){
  # EX = Expectation(random variable, probability, coefficient, random value, index)
  
  EX <- sum(prob*(k*(X+r)^i))
  return(EX)
  
}

############################## MAIN ############################## 

num_omega <- 10 # number of outcomes omega in finite sample space OMEGA
# random variable X associates with omega
# assuming X are real numbers chosen from 1:100
R <- 1:100
X1 <- sample(R, num_omega, replace = TRUE)  # int
X2 <- sample(R, num_omega, replace = TRUE)
Xprob1 <- XProbability(X1, num_omega)  # list
Xprob2 <- XProbability(X2, num_omega)

# E is linear operator if the following pairs of output are equal
# E(X1+X2) = E(X1) + E(X2)
k <- 1  # coefficient
r <- 0  # real number  
i <- 1  # index
EX1 <- Expectation(Xprob1$X,Xprob1$prob,k,r,i)  # E(X1)
EX2 <- Expectation(Xprob2$X,Xprob2$prob,k,r,i)  # E(X2)
# E(X1+X2)
Ex1X2 <- Expectation(c(Xprob1$X,Xprob2$X),c(Xprob1$prob,Xprob2$prob),k,r,i)  
# printed values are only for this specific case
print(Ex1X2)  
print(EX1 + EX2)  

# E(tX) = tE(X)
t <- runif(1)  # generate a random number, here is (0,1), but don't have to
EtX <- Expectation(Xprob1$X,Xprob1$prob,t,r,i)
print(EtX)  
tEX <- t*EX1
print(tEX)  

# ```

### Task b

# ```{r eval = TRUE, prompt = FALSE, comment = ''}

############################## FUNCTION ############################## 

Variance <- function(X, prob){
  # VarX = Variance(random variable, probability)
  # EX = Expectation(random variable, probability, coefficient, real number, index)  
  
  miu <- Expectation(X,prob,1,0,1)
  VarX <- Expectation(X,prob,1,-miu,2)
  return(VarX)
  
}

############################## MAIN ############################## 

# Var[X] = E[X^2] - E[X]^2 holds if the following pair of output is equal
VarX <- Variance(Xprob1$X,Xprob1$prob)
print(VarX)
rhs <- Expectation(Xprob1$X,Xprob1$prob,k,r,2) - (EX1)^2  
print(rhs) 

# ```
# \newpage

## Problem 4
### Task a

# ```{r eval = TRUE, prompt = FALSE, comment = ''}

# Bayes' rule, P(X|Y) = P(Y|X)*P(X)/P(Y)
# whether X and Y are independent events is unknown
pX <- runif(1)  # prob X
pY <- runif(1)  # prob Y
pXandY <- runif(1)  # prob X and Y

pXgivenY <- pXandY/pY  # prob X given Y, definition of conditional probability
pYandX <-pXandY
pYgivenX <- pYandX/pX
print(pXgivenY)
print(pYgivenX*pX/pY)

# ```

### Task b

# ```{r eval = TRUE, prompt = FALSE, comment = ''}

# X people not-/allergic+ to pollen
# Y +/- allergic test
pYgivennegX <- 0.23  # +test in -population, P(Y|-X), unused
pnegYgivenX <- 0.15  # -test in +population, P(-Y|X)
pX <- 0.2  # +population, P(X)

# randomly find a pollen allergic person to test, and test result is + (known), P(X|Y)
# Bayes's rule, P(X|Y) = P(Y|X)*P(X)/P(Y)
# P(Y|X) = 1-P(-Y|X)
# P(Y) = P(X^Y)+P(-X^Y), P(X^Y) = P(Y|X)*P(X), P(-X^Y) = P(Y|-X)*P(-X), P(-X) = 1-P(X)

pnegX <- 1 - pX  # P(-X) = 1-P(X)
pnegXandY <- pYgivennegX * pnegX  # P(-X^Y) = P(Y|-X)*P(-X) 
pYgivenX <- 1 - pnegYgivenX  # P(Y|X) = 1-P(-Y|X)
pXandY <- pYgivenX * pX  # P(X^Y) = P(Y|X)*P(X)
pY <- pXandY + pnegXandY  # P(Y) = P(X^Y)+P(-X^Y)
pXgivenY <- pYgivenX * pX / pY  # P(X|Y) = P(Y|X)*P(X)/P(Y)
print(pXgivenY)

# ```
# \newpage

## Problem 5
### Task a

# ```{r eval = TRUE, prompt = FALSE, comment = ''}

library(Ryacas)  # for symbolic operations
x <- c(ysym("x1"), ysym("x2"), ysym("x3"))  # list
y <- c(ysym("y1"), ysym("y2"), ysym("y3"))
b <- ysym("b")  
fb <- sum((b * x - y)^2)  
dfb <- deriv(fb, "b")  # first derivation
print(dfb$yacas_cmd)
ddfb <- deriv(dfb, "b")   # second derivation
print(ddfb$yacas_cmd)

# ```

# The second derivative of $f(b)$ is always constant and positive, so the first derivative is monotonically increasing, the minimum of $f(b)$ is reached at the point where first derivative is zero. This inference can be further verified with the expression of the function, $f(b)=\sum_{i=1}^3(bx_i-y_i)^2$, the second derivation is $2\cdot\sum_{i=1}^3x_i^2$, which is positive (except all three elements in $x_i$ are zero, which is very unlikely if they are picked randomly from $\mathbb{R}$).

# ```{r eval = TRUE, prompt = FALSE, comment = ''}

b_value <- solve(dfb,"b")
print(b_value)

# ```

### Task b

# According to the explanation in *Task a*, condition is $x_i$ should not all be zero.
