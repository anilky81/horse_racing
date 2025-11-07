# install.packages("stats")
library(stats)
num_of_samples = 100000
y <- rpois(num_of_samples, lambda = log(1000))
result = ks.test(x[1:10000], y)
result

chisq.test(log(x[1:100000]), y)

poisson.test()