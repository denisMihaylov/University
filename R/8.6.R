library("Simple")
data(trees)
attach(trees)
summary(trees)
boxplot(Girth, horizontal=T, main="Girth - skewed, regular")
boxplot(Height, horizontal=T, main="Height - slightly-skewed, regular")
boxplot(Volume, horizontal=T, main="Volume - skewed, regular")
