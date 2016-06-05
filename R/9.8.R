library(Simple)
func3 = function(n = 10, p = .95)
{
	y = rexp(n, rate = 1)
	t = (mean(y) - 0) / (sqrt(var(y))/sqrt(n))
}
sample3 = simple.sim(100, func3)
qqplot(sample3, rt(100, df = 9), main = "exponential: sample3 vs. t");qqline(sample3)
qqnorm(sample3, main = "exponential: sample3 vs. normal");qqline(sample3)
hist(sample3)
dev.off()