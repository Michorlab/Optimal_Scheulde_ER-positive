library(ggplot2)
library(cmdstanr)
#library(bayesplot)
library(reshape2)
library(dplyr)
library(rstan)
#library(tidyr)
#library(loo)
#library(deSolve)

set.seed(123456)

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

theme_set(theme_classic())

saveit <- function(..., file) {
	x <- list(...)
	save(list=names(x), file=file, envir=list2env(x))
}

load("stan_input_include_longterm_data_resistance.RData")


stan_data_ND = list(T_obs_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$T_obs, #palbo cell cycle
                    t_obs_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$t_obs,
                    y_obs_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$y_obs,
                    T_tx_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$T_tx,
                    tx_times_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$tx_times,
                    tx_doses_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$tx_doses,
                    T_times_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$T_times,
                    times_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$times,
                    n_drug_combos_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$n_drug_combinations,
                    start_times_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$start_times,
                    end_times_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$end_times,
                    n_times_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$n_times,
                    start_obs_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$start_obs,
                    end_obs_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$end_obs,
                    n_obs_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$n_obs,
                    start_tx_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$start_tx,
                    end_tx_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$end_tx,
                    n_tx_cc_p = stan_input_include_longterm_data_3$palbo_cc_ND_input$n_tx,
                    
                    T_obs_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$T_obs, # palbo cell total
                    t_obs_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$t_obs,
                    y_obs_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$y_obs,
                    T_tx_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$T_tx,
                    tx_times_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$tx_times,
                    tx_doses_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$tx_doses,
                    T_times_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$T_times,
                    times_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$times,
                    n_drug_combos_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$n_drug_combinations,
                    start_times_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$start_times,
                    end_times_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$end_times,
                    n_times_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$n_times,
                    start_obs_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$start_obs,
                    end_obs_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$end_obs,
                    n_obs_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$n_obs,
                    start_tx_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$start_tx,
                    end_tx_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$end_tx,
                    n_tx_ct_p = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$n_tx,
                    
                    T_obs_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$T_obs, #abema cell cycle
                    t_obs_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$t_obs,
                    y_obs_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$y_obs,
                    T_tx_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$T_tx,
                    tx_times_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$tx_times,
                    tx_doses_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$tx_doses,
                    T_times_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$T_times,
                    times_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$times,
                    n_drug_combos_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$n_drug_combinations,
                    start_times_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$start_times,
                    end_times_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$end_times,
                    n_times_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$n_times,
                    start_obs_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$start_obs,
                    end_obs_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$end_obs,
                    n_obs_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$n_obs,
                    start_tx_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$start_tx,
                    end_tx_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$end_tx,
                    n_tx_cc_a = stan_input_include_longterm_data_3$abema_cc_ND_input$n_tx,
                    T_obs_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$T_obs, # abema cell total
                    t_obs_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$t_obs,
                    y_obs_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$y_obs,
                    T_tx_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$T_tx,
                    tx_times_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$tx_times,
                    tx_doses_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$tx_doses,
                    T_times_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$T_times,
                    times_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$times,
                    n_drug_combos_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$n_drug_combinations,
                    start_times_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$start_times,
                    end_times_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$end_times,
                    n_times_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$n_times,
                    start_obs_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$start_obs,
                    end_obs_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$end_obs,
                    n_obs_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$n_obs,
                    start_tx_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$start_tx,
                    end_tx_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$end_tx,
                    n_tx_ct_a = stan_input_include_longterm_data_3$abema_ct_ND_input$n_tx,
                    
                    t_obs_ODE_ct = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$t_obs_ODE,
                    start_obs_ODE_ct = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$start_obs_ODE,
                    end_obs_ODE_ct = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$end_obs_ODE,
                    n_obs_ODE_ct = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$n_obs_ODE,
                    T_obs_ODE_ct = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$T_obs_ODE,
                    times_ODE_ct = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$times_ODE,
                    start_times_ODE_ct = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$start_times_ODE,
                    end_times_ODE_ct = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$end_times_ODE,
                    T_times_ODE_ct = stan_input_include_longterm_data_3$palbo_ct_ND_input_r$T_times_ODE,
                    
                    t_obs_ODE_cc = stan_input_include_longterm_data_3$palbo_cc_ND_input$t_obs_ODE,
                    start_obs_ODE_cc = stan_input_include_longterm_data_3$palbo_cc_ND_input$start_obs_ODE,
                    end_obs_ODE_cc = stan_input_include_longterm_data_3$palbo_cc_ND_input$end_obs_ODE,
                    n_obs_ODE_cc = stan_input_include_longterm_data_3$palbo_cc_ND_input$n_obs_ODE,
                    T_obs_ODE_cc = stan_input_include_longterm_data_3$palbo_cc_ND_input$T_obs_ODE,
                    times_ODE_cc = stan_input_include_longterm_data_3$palbo_cc_ND_input$times_ODE,
                    start_times_ODE_cc = stan_input_include_longterm_data_3$palbo_cc_ND_input$start_times_ODE,
                    end_times_ODE_cc = stan_input_include_longterm_data_3$palbo_cc_ND_input$end_times_ODE,
                    T_times_ODE_cc = stan_input_include_longterm_data_3$palbo_cc_ND_input$T_times_ODE,
                    t0 = 0,
                    K = 1e5,
                    rel_tol = 1e-7,#1e-10,
                    abs_tol = 1e-4,#1e-10,
                    max_num_steps = 1e3)




initialParameterValues_ND = function() list(alpha = rlnorm(1,log(16),1), #rlnorm(1,log(8),1),
                                            gamma = rlnorm(1,log(16),1),
                                            delta = rlnorm(1,log(16),1),
                                             b_P = rlnorm(1,log(1),1),
                                             #b_P = rlnorm(1,log(1),1),
                                             #b_F = rlnorm(1,log(1),1),
                                             #b_F_2 = rlnorm(1,log(1),1),
                                             #b_P = rlnorm(1,log(1),1),
                                             #b_F = rlnorm(1,log(1),1),
                                             c_P = rlnorm(1,log(1),1),
                                             #c_F = rlnorm(1,log(1),1),
                                             #c_F_2 = rlnorm(1,log(20),1),
                                             #c_P = rlnorm(1,log(3),1),
                                             #c_F = rlnorm(1,log(12),1),
                                             #a_FP = -rnorm(1, log(1), 1),
                                             #a_FP = -rlnorm(1,log(1), 1),
                                             #a_FP = -rlnorm(1,log(0.5),0.25),
                                             #a_PF = -rnorm(1, 0.5, 0.5),
                                             #a_FP = rnorm(1, 0, 1),
                                             #a_PF = rnorm(1, 0, 1),
                                             #Beta = rlnorm(1,log(7),1),
                                             #Beta = rlnorm(1,log(2),1),
                                             #alpha_max = rlnorm(1,log(1),1),
                                             alpha_max = rlnorm(1,log(0.1),0.1),
                                             #alpha_max_2 = rlnorm(1,log(2),1),
                                             #alpha_max_2 = rlnorm(1,log(0.1),0.1),
                                             #alpha_zero = rlnorm(1,log(3),1),
                                             #K = rlnorm(1,log(1),0.2),
                                             #Gamma = rlnorm(1,log(17),2),
                                             #Gamma = rlnorm(1,log(4),2),
                                             #delta = rlnorm(1,log(0.2),1),
                                             sigma = abs(rnorm(4,1,0.1)),
                                             #y0_cc_p = c(rnorm(5,3000/5,300/5), rnorm(5,300/5,30/5), rnorm(5,500/5,50/5)),
                                             #y0_ct_p = c(rnorm(5,3000/5,300/5), rnorm(5,300/5,30/5), rnorm(5,500/5,50/5))
                                             #y0_cc_p = c(rnorm(1,3000,300), rnorm(1,300,30), rnorm(1,500,50)),
                                             y0_ct_p = c(rnorm(1,10000,1000), rnorm(1,1000,100), rnorm(1,1500,150))
)

library(cmdstanr)
ex_mod <- cmdstan_model('Rescale_ND_singleparameter_24ODES_even_1000iters_resistance.stan')
# Sampling - https://mc-stan.org/cmdstanr/reference/model-method-sample.html
posterior <- ex_mod$sample(data = stan_data_ND,
                           parallel_chains = 1, 
                           chains = 3,
                           iter_warmup = 20,
                           iter_sampling = 20,
                           adapt_delta = 0.65,
                           step_size = 0.01,
                           max_treedepth = 15,
                           init = initialParameterValues_ND)
# To get the samples run this - https://mc-stan.org/cmdstanr/reference/fit-method-draws.html
stanfit_ND <- rstan::read_stan_csv(posterior$output_files())

#list_of_draws <- extract(stanfit)

#posterior$draws(inc_warmup = F)  

saveit(Rescale_ND_singleparameter_24ODES_even_1000iters_3rates_resistance = stanfit_ND, file = "Rescale_ND_singleparameter_24ODES_even_1000iters_3rates_resistance.RData")






