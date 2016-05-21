library("Simple")
n = 100
func <- function(n=100, p=.5)
{
    S <- rbinom(1,n,p)
    (S - n*p)/sqrt(n*p*(1-p))
}
p25 <- simple.sim(1000,func,n,.25)
p05 <- simple.sim(1000,func,n,.05)
p01 <- simple.sim(1000,func,n,.01)
par(mfrow=c(1,3), oma=c(0,0,2,0))
hist(p25, prob=T, main="p=.25")
lines(density(p25))
hist(p05, prob=T, main="p=.05")
lines(density(p05))
hist(p01, prob=T, main="p=.01")
lines(density(p01))
title("Bernoulli Simulations - p=.25, .05, .01", outer=T)
