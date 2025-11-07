summary(training_set$hRaceTime[training_set$xino4==1400])
sd(training_set$hRaceTime[training_set$xino4==1400])
mean(training_set$hRaceTime[training_set$xino4==1000])
median(training_set$hRaceTime[training_set$xino4==1000])

hist(training_set$hRaceTime[training_set$xino4==1000&training_set$hRaceTime<1.04], breaks = 150, probability = TRUE)

plot(1000/x,1/dnorm(x,700,28), type = 'l')


x = seq(700,1500,2)

plot(1000/x,1/dnorm(x,700,28), type = 'l')

x = seq(500/1000,1500/1000,2/1000)
xdata= dnorm(x,1,0.05)
xdata = xdata[x<1.5]
xdata = rnorm(1000,1.5,.05)
xdata=xdata[xdata<]

plot(dnorm(1/x,1.3,0.04))
plot(x,1/dnorm(1/x,1.3,0.04), type = 'l')

xdata = training_set$hRaceTime[training_set$xino4==2800&training_set$hRaceTime<3.9]
fgn = fitdist(xdata, "gamma")
fln =  fitdist(xdata, "lnorm")
flln =  fitdist(xdata, "exp")
fl0n =  fitdist(xdata, "llogis")
fnorm =  fitdist(xdata, "norm")


gofstat(list(fgn,fln,flln,fl0n,fnorm))
denscomp(list(fgn,fln,flln,fl0n,fnorm)) 


xdata = training_set$hRaceTime[training_set$xino4==1200&training_set$hRaceTime<1.5]
fgn = fitdist(xdata, "gamma")
fln =  fitdist(xdata, "lnorm")
flln =  fitdist(xdata, "weibull")
fl0n =  fitdist(xdata, "llogis")
fnorm =  fitdist(xdata, "norm")


gofstat(list(fgn,fln,flln,fl0n,fnorm))
denscomp(list(fgn,fln,flln,fl0n,fnorm)) 
