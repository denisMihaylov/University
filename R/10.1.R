library(Simple)
data(vacation)
qqnorm(vacation)
qqline(vacation)

t.test(vacation, mu=24)