data {
  int<lower=0> sum_rows;
  int<lower=0> max_possibilities;
  int possible_sums[sum_rows, 4];
}

parameters {
  vector<lower=0>[3] lambda;
}

model {
  vector[max_possibilities] acc;
  int k;
  int which_observation;
  which_observation = 1;
  k = 1;
  for (i in 1:sum_rows) {
    if (which_observation != possible_sums[i,4]) {
      target += log_sum_exp(acc[1:(k-1)]);
      k = 1;
      which_observation = possible_sums[i,4];
    } 
    acc[k] = poisson_lpmf(possible_sums[i, 1]| lambda[1]) +  
             poisson_lpmf(possible_sums[i, 2]| lambda[2]) +  
             poisson_lpmf(possible_sums[i, 3]| lambda[3]);
    k += 1;
  }
  lambda ~ uniform(0,10);
}
