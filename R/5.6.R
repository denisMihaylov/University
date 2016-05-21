library("Simple")
data(babies)
attach(babies)
pairs(babies)

#Има линейна зависимост между височината и теглото на бебето
plot(height, weight)
abline(lm(weight ~ height))

#Както и между Parity и Age
plot(parity, age)
abline(lm(age ~ parity))

plot(bwt ~ gestation)
tmp = levels(factor(smoke))
points(bwt ~ gestation, pch=smoke)
