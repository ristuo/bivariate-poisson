library(dplyr)
library(rstan)
options(mc.cores = parallel::detectCores())
lambda1 <- 1.5
lambda2 <- 0.7
lambda3 <- 2.5

n <- 500
common <- rpois(n, lambda3)
Y <- cbind(
  rpois(n, lambda1) + common,
  rpois(n, lambda2) + common 
)

possible_sums <- as.data.frame(Y) %>%
  mutate(index = 1:nrow(Y)) %>%
  group_by(index) %>%
  do((function(d) {
    possibilities <- expand.grid(0:d$V1[1], 0:d$V2[1], 0:min(d$V1[1],d$V2[1]))
    res <- possibilities %>% filter(Var1 + Var3 == d$V1[1] & Var2 + Var3 == d$V2[1]) %>%
      mutate(index = d$index)
    res
  })(.))

possible_sums_mat <- as.matrix(possible_sums)
model <- stan(
  "src/main/stan/model.stan", 
  data = list(
    possible_sums = possible_sums_mat, 
    max_possibilities = max(table(possible_sums$index)),
    sum_rows = nrow(possible_sums)),
  chains = 4)
summary(model)
