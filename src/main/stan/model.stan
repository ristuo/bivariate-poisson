data {
  int<lower=1> N;
  int<lower=0> y1[N];
  int<lower=0> y2[N];
  int<lower=0> max_of_mins_per_component;
}

transformed data {
  int possible_sums[N, max_of_mins_per_component + 1, 3];
  int possible_sum_sizes[N];
  for (i in 1:N) {
    int rows_needed = min(y1[i], y2[i]) + 1;
    possible_sum_sizes[i] = rows_needed;
  }
  for (i in 1:N) {
    for (j in 1:possible_sum_sizes[i]) {
      possible_sums[i, j, 1] = y1[i] - (j - 1);
      possible_sums[i, j, 2] = y2[i] - (j - 1);
      possible_sums[i, j, 3] = j;
    }
  }
}

parameters {
  vector[3] lambda;
}

model {
  vector[max_of_mins_per_component + 1] acc;
  lambda ~ normal(0, 10);
  for (i in 1:N) {
    for (j in 1:possible_sum_sizes[i]) {
      acc[j] = poisson_log_lpmf(possible_sums[i, j, 1]| lambda[1]) +  
               poisson_log_lpmf(possible_sums[i, j, 2]| lambda[2]) +  
               poisson_log_lpmf(possible_sums[i, j, 3]| lambda[3]);
    }
    target += log_sum_exp(acc[1:possible_sum_sizes[i]]);
  }
}
