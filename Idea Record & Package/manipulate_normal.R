library(manipulate)

#Calculate the likelihood of normal distribution
MLE <- function(n, param1, param2, probability, estimate, seed){
  if(seed){
    set.seed(0)
  }
  data <- rnorm(n, param1, param2)
  hist(data, main="Histogram of Normal Distribution", prob=probability)
  abline(v=estimate, col="red")
  loglikeli <- sum(dnorm(data, estimate, param2, log=TRUE))
  string <- paste("Loglikelihood:", round(loglikeli, 4))
  text(quantile(data, 0.9), quantile(dnorm(data), 0.9), string)
}

#Manipulate: slider, checkbox, picker(not shown)
manipulate(
  MLE(n, p1, p2, check, estimate, seed),
  n=slider(0, 1000, initial=100, step=100, label="Sample Size"),
  p1=slider(-10, 10, initial=0, label="First parameter"),
  p2=slider(1, 10, initial=1, label="Second parameter"),
  estimate=slider(-10, 10, initial=0, step=0.01, "estimate of mu"),
  check=checkbox(TRUE, label="Probability"),
  seed=checkbox(TRUE, label="Set seed")
)
