# Identification by Long-Run Restrictions:
# Real and Nominal Exchange Rate Shocks
# ch10_ex2.R
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
library(forecast,   warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(tsDyn,      warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(mcompanion, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library(corpcor,    warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)


# 2. Data ----

var.db = read_excel(path = "/Users/victorhugoramirezhunter/Desktop/ch10_ex2.xlsx", 
                    sheet = "Data", range = "B1:C295", col_names = TRUE)
var.ts = ts(var.db, start = 2000, frequency = 12)
colnames(var.ts) = c("ITCER","FX")

var.plot.ts = var.ts
names.vec = c("ITCER (GTM-US)",
              "FX (Q/US$)")
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

stl.1.g = stl(var.ts[,1], s.window = "periodic") %>% autoplot
stl.2.g = stl(var.ts[,2], s.window = "periodic") %>% autoplot

var.ts = cbind(
  stl(var.ts[,1], s.window = "periodic") %>% seasadj,
  stl(var.ts[,2], s.window = "periodic") %>% seasadj
)
colnames(var.ts) = c("ITCER (GTM-US)",
                     "FX (Q/US$)")

# 3. Example 2.1: VEC form ----

# Time series:
var1.ts = var.ts

# y-vector dimension:
KK = dim(var1.ts)[2]

VARselect(var1.ts, lag.max = 14)

pp = 2

vec1.mod = ca.jo(x = var1.ts,
                 type = "trace", 
                 ecdet = "none", 
                 K = pp, 
                 spec = "transitory")
vecm.1 = VAR(y = diff(var1.ts), type = "const", p = (pp-1))
Gamma.1 = Acoef(vecm.1)[[1]] %>% unname

Gamma.inv = solve(diag(2) - Gamma.1)

Sigma.u = resid(vecm.1) %>% var %>% unname

Upsilon = (Gamma.inv%*%Sigma.u%*%t(Gamma.inv)) %>% chol %>% t

B.0.inv = solve(Gamma.inv)%*%t(chol(Upsilon%*%t(Upsilon)))

# 4. Example 2.2: VAR form ----

var2.ts = diff(var1.ts)
var2.ts = na.omit(var2.ts)

colnames(var2.ts) = c("ITCER (GTM-US)",
                      "FX (Q/US$)")

var2.mod = VAR(var2.ts, p = 1, type = "const")

var2.bq = BQ(var2.mod)

# Comparing results:
var2.bq
B.0.inv

# IRFs (I have to construct them manually)

B.mat = var2.bq$B %>% unname # This is B_0^{-1}
A.mat = (Acoef(var2.mod))[[1]] %>% unname

Theta.array = array(data = NA, dim = c(KK,KK,49))
IRF.array = Theta.array
for(hh in 1:49){
  Theta.array[,,hh] = (A.mat%^%(hh-1))%*%B.mat
}
IRF.array[1,1,] = cumsum(Theta.array[1,1,]) #FX - Real
IRF.array[2,1,] = cumsum(Theta.array[2,1,]) #ITCER - Real
IRF.array[1,2,] = cumsum(Theta.array[1,2,]) #FX - Nominal
IRF.array[2,2,] = cumsum(Theta.array[2,2,]) #ITCER - Nominal

IRF.ts = ts(t(IRF.array[,1,]), start = 0, frequency = 12)
colnames(IRF.ts) = colnames(var1.ts)
temp.IRF.ts = IRF.ts

IRF.ts = melt(IRF.ts)
IRF.ts = cbind(IRF.ts,
               temp.IRF.ts %>% time %>% rep( dim(temp.IRF.ts)[2] ))
colnames(IRF.ts) = c("Obs","Variable","Value","Period")

irf2.g = ggplot(IRF.ts) +
  geom_line(mapping = aes(x = Period, y = Value)) +
  facet_wrap(~Variable, scales = "free", ncol = 1) +
  labs(x = "Period (years)", y = "", title = "Real shock") +
  geom_abline(intercept = 0, slope = 0, lty = 3)


IRF.ts = ts(t(IRF.array[,2,]), start = 0, frequency = 12)
colnames(IRF.ts) = colnames(var1.ts)
temp.IRF.ts = IRF.ts

IRF.ts = melt(IRF.ts)
IRF.ts = cbind(IRF.ts,
               temp.IRF.ts %>% time %>% rep( dim(temp.IRF.ts)[2] ))
colnames(IRF.ts) = c("Obs","Variable","Value","Period")

irf3.g = ggplot(IRF.ts) +
  geom_line(mapping = aes(x = Period, y = Value)) +
  facet_wrap(~Variable, scales = "free", ncol = 1) +
  labs(x = "Period (years)", y = "", title = "Nominal shock") +
  geom_abline(intercept = 0, slope = 0, lty = 3)

grid.arrange(irf2.g,irf3.g, ncol = 2)


# 5. Long-run effects of the structural shocks ----
# This is based on the Granger Representation of the VECM

B.0 = solve(B.0.inv)
w.mat = B.0%*%t(resid(vecm.1)) %>% t
lr.ts = (Upsilon%*%t(apply(w.mat, MARGIN = 2, FUN = cumsum)))%>% t
colnames(lr.ts) = names.vec
lr.ts = ts(lr.ts, start = c(2000,2), frequency = 12)
lr.ts %>% autoplot(facets = T) +
  labs(title = "Long-run effects of structural shocks")

# Only real exchange rate shocks:
w.r.mat = w.mat
w.r.mat[,2] = 0
lr.r.ts = (Upsilon%*%t(apply(w.r.mat, MARGIN = 2, FUN = cumsum)))%>% t
colnames(lr.r.ts) = names.vec
lr.r.ts = ts(lr.r.ts, start = c(2000,2), frequency = 12)
lr.r.ts %>% autoplot(facets = T) +
  labs(title = "Long-run effects of real exchange rate shocks")

# Only nominal exchange rate shocks:
w.n.mat = w.mat
w.n.mat[,1] = 0
lr.n.ts = (Upsilon%*%t(apply(w.n.mat, MARGIN = 2, FUN = cumsum)))%>% t
colnames(lr.n.ts) = names.vec
lr.n.ts = ts(lr.n.ts, start = c(2000,2), frequency = 12)
lr.n.ts %>% autoplot(facets = T) +
  labs(title = "Long-run effects of nominal exchange rate shocks")





