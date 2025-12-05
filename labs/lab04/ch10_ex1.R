# Identification by Long-Run Restrictions:
# Baseline 3-Variable RBC Model
# ch10_ex1.R
# vhrh@banguat.gob.gt

# 0. Housekeeping ----

rm(list = ls())

# 1. Dependencies ----

library(alabama,    warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(tidyverse,  warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(ggplot2,    warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(vars,       warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(stats,      warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(gridExtra,  warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(reshape2,   warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(readxl,     warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(expm,       warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(tsDyn,      warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(mcompanion, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(corpcor,    warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

# 2. Data ----

var.db = read_excel(path = "/Users/victorhugoramirezhunter/Desktop/ch10_ex1.xlsx", 
                    sheet = "Data", range = "B1:G78", col_names = TRUE)
var.ts = ts(var.db, start = 2005, frequency = 4)
colnames(var.ts) = c("GDP","CONS","INV","RB","I","INF")

var.plot.ts = var.ts
names.vec = c("log GDP",
              "log Consumption",
              "log Investment",
              "log M1 Real Balances",
              "Interbank Rate",
              "Lead q-o-q Inflation")
colnames(var.plot.ts) = names.vec

var.plot.ts = melt(var.plot.ts)
var.plot.ts = cbind(var.plot.ts,
                    var.ts %>% time %>% rep( dim(var.ts)[2] ))
colnames(var.plot.ts) = c("Obs","Variable","Value","Period")

var.ts.g = ggplot(var.plot.ts) +
  geom_line(mapping = aes(x = Period, y = Value)) +
  facet_wrap(~Variable, scales = "free", ncol = 2) +
  labs(x = "", y = "") +
  geom_abline(intercept = 0, slope = 0, lty = 3)

# 3. Example 1.1: Three-variable model ----

# Time series:
var1.ts = var.ts[,c("GDP","CONS","INV")]

# y-vector dimension:
KK = dim(var1.ts)[2]

# VEC model (I had already done some stuff on EViews to determine the
# appropriate specification. Notice that, while there are two cointegrating
# vectors, these are estimated, not imposed)

vec1.mod = ca.jo(x = var1.ts, 
                type = "trace", 
                ecdet = "none", 
                K = 2, 
                spec = "transitory")
# Restricting Beta with package urca
vec1.m = cajorls(vec1.mod, r = 2) # VECM with r = 2
# Restriction matrix on Beta:
H.mat = matrix(c(-1,-1,1,0,0,1), nrow = 3, ncol = 2, byrow = T)
# Restricted VECM estimation
res.vec1.mod = blrtest(vec1.mod, H = H.mat, r = 2)

# Restricting Beta with package tsDyn and 
# constructing the Xi matrix (last can be done better)
vecm.1 = VECM(data = var1.ts, lag = 1, r = 2, beta = H.mat, estim = "ML",
              LRinclude = "none", include = "const", exogen = NULL)
alpha.mat = coefA(vecm.1) %>% unname    # loading matrix
beta.mat  = coefB(vecm.1) %>% unname    # cointegration matrix
alpha.oc = null_complement(alpha.mat)   # alpha orthogonal complement
beta.oc = null_complement(beta.mat)     # beta orthogonal complement
Pi.mat    = alpha.mat%*%t(beta.mat)     # Pi matrix
Gamma.1 = coef(vecm.1)[,4:6] %>% unname # Gamma matrix (p-1 = 1)
Xi.mat = beta.oc %*%                    # Xi matrix
  solve( t(alpha.oc)%*%(diag(3) - Gamma.1)%*%beta.oc ) %*% t(alpha.oc)
rankMatrix(Xi.mat)                      # Checking Xi's rank (should be 1)

# B_0^{-1} restrictions
Rl.mat = cbind( 
  matrix(0, ncol = 3, nrow = 6) ,
  diag(6) 
  ) %*% kronecker(diag(3), Xi.mat)
Rs.mat = matrix( 0 , nrow = 1, ncol = 9)
Rs.mat[,8] = 1
R.mat = rbind(Rl.mat, Rs.mat)
r.mat = rep(0,7) %>% as.matrix

# Checking necessary conditions for just-identification
rankMatrix(R.mat) # Should be K(K-1)/2 = 3*2/2 = 3

# Estimating B_0^{-1} subject to R.mat, r.mat
B.0 = vecm.1 %>% resid %>% cov %>% chol %>% t %>% unname #Starting values
B.0 = B.0 %>% as.numeric # Vectorization of starting B_0^{-1}

obj.fun = function(B.0){
  xx = R.mat%*%as.matrix(B.0) - r.mat
  return(norm(xx, type = "O"))
}

# Optimization routine
opt.output = optim(B.0, fn = obj.fun, method = "BFGS")
# Estimated B_0_^{-1}
B.0.inv = matrix(opt.output$par, nrow = 3, ncol = 3, byrow = F)
# Upsilon matrix
Ups.mat = Xi.mat%*%B.0.inv

round(B.0.inv, 6)
round(Ups.mat, 6)

# Getting back to the VAR(2) representation
A.2 = -Gamma.1
A.1 = Pi.mat + diag(3) - A.2

# Companion form A matrix
A.mat = cbind(A.1,A.2)
A.mat = rbind(A.mat,
              cbind( diag(3), matrix(0 , 3, 3) ))
J.mat = cbind(diag(3), matrix(0, 3, 3))

# IRFs
Theta.array = array( data = NA, dim = c(3,3,17)) 
for(hh in 1:17){
  Theta.array[,,hh] = J.mat%*%(A.mat%^%(hh-1))%*%t(J.mat)%*%B.0.inv
}

# Permanent shock responses:

IRF.ts = ts(t(Theta.array[,1,]), start = 0, frequency = 4)
colnames(IRF.ts) = colnames(var1.ts)
temp.IRF.ts = IRF.ts

IRF.ts = melt(IRF.ts)
IRF.ts = cbind(IRF.ts,
               temp.IRF.ts %>% time %>% rep( dim(temp.IRF.ts)[2] ))
colnames(IRF.ts) = c("Obs","Variable","Value","Period")

irf0.g = ggplot(IRF.ts) +
  geom_line(mapping = aes(x = Period, y = Value)) +
  facet_wrap(~Variable, scales = "free", ncol = 2) +
  labs(x = "Period (years)", y = "") +
  geom_abline(intercept = 0, slope = 0, lty = 3)



# Now, the easy, incorrect way: unrestricted Beta, package vars

# Upsilon matrix LR restrictions
LR = matrix(NA, nrow = 3, ncol = 3)
LR[1:3,2] = 0
LR[1:3,3] = 0

# B_0^{-1} SR restrictions
SR = matrix(NA, nrow = 3, ncol = 3)
SR[2,3] = 0

# Estimated SVEC model
svec1.mod = SVEC(vec1.mod, LR = LR, SR = SR, r = 2, lrtest = F, boot = 100)

# IRFs (I only plot the Balanced-Growth, i.e., permanent shock IRF)
lr.irf = irf(svec1.mod, impulse = "GDP", n.ahead = 32)

colnames(lr.irf$irf$GDP) = names.vec[1:3]
lr.irf.df = melt(lr.irf$irf$GDP)
lr.irf.df = cbind(lr.irf.df,
                  lr.irf$Lower$GDP %>% as.numeric,
                  lr.irf$Upper$GDP %>% as.numeric)
colnames(lr.irf.df) = c("Period","Variable","Response","Lower","Upper")
irf1.g = ggplot(lr.irf.df) +
  geom_ribbon( aes(x = Period, ymax = Upper, ymin = Lower), alpha = 0.25) +
  geom_line( aes(x = Period, y = Response) ) +
  geom_abline( intercept = 0, slope = 0, lty = 3 ) +
  facet_wrap( ~ Variable, scales = "free", ncol = 2 ) +
  labs(x = "Period (quarters)", y = "Response")

# 4. Example 1.2: Three-Variable Model (VAR form) ----

var2.ts = cbind(diff(var1.ts[,"GDP"]),
                var1.ts[,"CONS"]-var1.ts[,"GDP"],
                var1.ts[,"INV"]-var1.ts[,"GDP"])
var2.ts = na.omit(var2.ts)

colnames(var2.ts) = c("GDP","CONS","INV")

var2.mod = VAR(var2.ts, p = 1, type = "const")

var2.bq = BQ(var2.mod)

# IRFs (I have to construct them manually)

B.mat = var2.bq$B %>% unname # This is B_0^{-1}
A.mat = (Acoef(var2.mod))[[1]] %>% unname

Theta.array = array(data = NA, dim = c(KK,KK,33))
IRF.array = Theta.array
for(hh in 1:33){
  Theta.array[,,hh] = (A.mat%^%(hh-1))%*%B.mat
}
IRF.array[1,1,] = cumsum(Theta.array[1,1,]) #Cummulated GDP response
IRF.array[2,1,] = Theta.array[2,1,] + IRF.array[1,1,]
IRF.array[3,1,] = Theta.array[3,1,] + IRF.array[1,1,]

IRF.ts = ts(t(IRF.array[,1,]), start = 0, frequency = 4)
colnames(IRF.ts) = colnames(var1.ts)
temp.IRF.ts = IRF.ts

IRF.ts = melt(IRF.ts)
IRF.ts = cbind(IRF.ts,
                    temp.IRF.ts %>% time %>% rep( dim(temp.IRF.ts)[2] ))
colnames(IRF.ts) = c("Obs","Variable","Value","Period")

irf2.g = ggplot(IRF.ts) +
  geom_line(mapping = aes(x = Period, y = Value)) +
  facet_wrap(~Variable, scales = "free", ncol = 2) +
  labs(x = "Period (years)", y = "") +
  geom_abline(intercept = 0, slope = 0, lty = 3)



















