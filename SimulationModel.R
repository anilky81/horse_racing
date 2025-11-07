endsign <- function(f, sign = 1) {
  b <- sign
  while (sign * f(b) < 0) b <- 10 * b
  return(b)
}


samplepdf <- function(n, pdf, ..., spdf.lower = -Inf, spdf.upper = Inf) {
  vpdf <- function(v) sapply(v, pdf, ...)  # vectorize
  cdf <- function(x) integrate(vpdf, spdf.lower, x)$value
  invcdf <- function(u) {
    subcdf <- function(t) cdf(t) - u
    if (spdf.lower == -Inf) 
      spdf.lower <- endsign(subcdf, -1)
    if (spdf.upper == Inf) 
      spdf.upper <- endsign(subcdf)
    return(uniroot(subcdf, c(spdf.lower, spdf.upper))$root)
  }
  -sapply(runif(n), invcdf)
}


h <- function(t,a) {
  
  val = sqrt(2/pi)*1/(a^3)*(t^2)*exp(-t^2/(2*(a^2)))
  return(val)
}
a = c(700,800,900,1000,1100,1200)
sim_length = 1000
df_simTimes = matrix(nrow = sim_length,ncol = length(a),data = 0)
for( i in c(1:length(a))){
  df_simTimes[,i] <- samplepdf(sim_length, h, a = a[i] )
}
order_mat = 0*df_simTimes
for( i in c(1:nrow(df_simTimes)))
{
  order_mat[i,] = order(df_simTimes[i,])
}


# rpois(1000,1000)



# a = c(700,800,900,1000,1100,1200)
sim_length = 100000
df_simTimes = matrix(nrow = sim_length,ncol = length(a),data = 0)
for( i in c(1:length(a))){
  df_simTimes[,i] <- rpois(sim_length, as.numeric(a[i] ))
}
order_mat = 0*df_simTimes
for( i in c(1:nrow(df_simTimes)))
{
  order_mat[i,] = order(df_simTimes[i,])
}
