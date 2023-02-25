library(rstan)
options(mc.cores = parallel::detectCores())
lambda1 <- 1.5
lambda2 <- 0.7
lambda3 <- 2.5

n <- 20
common <- rpois(n, lambda3)
Y <- cbind(
  rpois(n, lambda1) + common,
  rpois(n, lambda2) + common 
)
max_of_mins_per_component = max(apply(Y, 1, min))

model <- stan_model("main/stan/model.stan")

data <-  list(
    N = n,
    y1 = Y[,1],
    y2 = Y[,2],
    max_of_mins_per_component = max_of_mins_per_component
)
samples <- sampling(model,  data = data, chains=4)
lambda_samples <- rstan::extract(samples, "lambda")[[1]]


