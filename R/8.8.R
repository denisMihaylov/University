library("Simple")
results = c()
for (i in 1:200) results[i]=length(simple.chutes(sim=T))
hist(results)
#Percentage of results > 100:
sum(results>100)/n*100
#Comparing median with mean
summary(results)
plot(simple.chutes(1))
