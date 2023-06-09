functions{
  // computes the solution of the system of ODEs, given the model paramters, initial conditions, and requested solution times
  
  vector cell_population_dynamics(real t,             // Time at which derivatives are evaluated
                                  vector N,           // System state at which derivatives are evaluated
                                  real[] params, 
                                  real[] x_r, int[] x_i){         // Integer constants for system that are not fit ??what is this for??
    //Parameters for multistep models (a,b) are for subphases
    real alpha = params[1];                           // rate from G2M -> G0G1
    //real alpha_b = params[2];                            // rate from G2M -> G0G1
    //real b_A = params[2];
    real b_P = params[2];
    //real b_F = params[3];
    //real c_A = params[5];
    real c_P = params[3];
    //real c_F = params[5];
    //real a_FP = params[6];
    //real a_FA = params[9];
    real alpha_max = params[4];
    real gamma = params[5];
    real delta = params[6];
    //real Beta = params[8];                            // rate from each limiting step within G0G1 and G0G1 -> S-a
    //real Beta_b = params[10];                         // rate from G0G1 -> S
    //real Gamma = params[9];                           // rate from S-b -> G2M-a
    //real Gamma_b = params[12];
    //real alpha_zero = params[10];
    //real a_PF = params[8];
    //real K = params[11]*1e5;
    
    real drugF = 1e8*x_r[1];
    //real drugF = 1e4*x_r[1];
    real drugP = 1e2*x_r[2];
    real drugA = 1e4*x_r[3];
    

    //real drugF_eff = drugF * (1 + 0.1*a_FP * ((drugP/c_P)/(1 + (drugP/c_P))))^(-1) ; //* (1 + a_FA * ((drugA/c_A)/(1 + (drugA/c_A))))^(-1);
    //real drugP_eff = drugP * (1 + a_PF * ((drugF/c_F)/(1 + (drugF/c_F))))^(-1) ;
    
    
    // real Beta = b*(1/(1 + (drugA/c_A)^b_A))*(1/(1 + (drugP/c_P)^b_P))*(1/(1 + (drugF_eff/c_F)^b_F));
    //real alpha_drug = alpha_max + (alpha - alpha_max)*exp(-(drugP/c_P)^b_P)*exp(-(drugF_eff/c_F)^b_F);    
     real alpha_drug = 0.1*alpha_max + (alpha - 0.1*alpha_max)*(1/(1 + (drugP/c_P)^b_P));
     //real alpha_drug = alpha*(1/(1 + (drugP/c_P)^b_P))*(1/(1 + (drugF_eff/c_F)^(0.1*b_F)));
    //real alpha_drug = alpha_max + (alpha - alpha_max)*(1/(1 + (drugP/c_P)^b_P))*(1/(1 + (drugF_eff/c_F)^b_F)); origial formula
    //real alpha_drug = alpha + (alpha_max - alpha)*((drugP)^b_P/((c_P)^b_P + (drugP)^b_P))*((drugF_eff)^b_F/((c_F)^b_F + (drugF_eff)^b_F)); 
    // assume no drug for now
    real total;  
    //real logistic_term;  
    //vector[3] dN_dt;                                    // 3 compartments -- correspond to cell cycle phases
    vector[24] dN_dt;
    //vector[3] NN;
    vector[24] NN;
    NN[1] = N[1];
    NN[2] = N[2];
    NN[3] = N[3];
    NN[4] = N[4];
    NN[5] = N[5];
    NN[6] = N[6];
    NN[7] = N[7];
    NN[8] = N[8];
    NN[9] = N[9];
    NN[10] = N[10];
    NN[11] = N[11];
    NN[12] = N[12];
    NN[13] = N[13];
    NN[14] = N[14];
    NN[15] = N[15];
    NN[16] = N[16];
    NN[17] = N[17];
    NN[18] = N[18];
    NN[19] = N[19];
    NN[20] = N[20];
    NN[21] = N[21];
    NN[22] = N[22];
    NN[23] = N[23];
    NN[24] = N[24];
  
  
    //print(params);
    
    //?? Why do we need to put those conditions??
    if (N[1] < 0){
      NN[1] = 0;
    }
    if (N[2] < 0){
      NN[2] = 0;
    }
    if (N[3] < 0){
      NN[3] = 0;
    }
    if (N[4] < 0){
      NN[4] = 0;
    }
    if (N[5] < 0){
      NN[5] = 0;
    }
    if (N[6] < 0){
      NN[6] = 0;
    }
    if (N[7] < 0){
      NN[7] = 0;
    }
    if (N[8] < 0){
      NN[8] = 0;
    }
    if (N[9] < 0){
      NN[9] = 0;
    }
    if (N[10] < 0){
      NN[10] = 0;
    }
    if (N[11] < 0){
      NN[11] = 0;
    }
    if (N[12] < 0){
      NN[12] = 0;
    }
    if (N[13] < 0){
      NN[13] = 0;
    }
    if (N[14] < 0){
      NN[14] = 0;
    }
    if (N[15] < 0){
      NN[15] = 0;
    }
    if (N[16] < 0){
      NN[16] = 0;
    }
    if (N[17] < 0){
      NN[17] = 0;
    }
    if (N[18] < 0){
      NN[18] = 0;
    }
    if (N[19] < 0){
      NN[19] = 0;
    }
    if (N[20] < 0){
      NN[20] = 0;
    }
    if (N[21] < 0){
      NN[21] = 0;
    }
    if (N[22] < 0){
      NN[22] = 0;
    }
    if (N[23] < 0){
      NN[23] = 0;
    }
    if (N[24] < 0){
      NN[24] = 0;
    }
    //print(NN);
    //total = NN[1] + NN[2] + NN[3];
    total = NN[1] + NN[2] + NN[3] + NN[4] + NN[5] + NN[6]+ NN[7] + NN[8] + NN[9] + NN[10] + NN[11] + NN[12] + NN[13] + NN[14] + NN[15] + NN[16] + NN[17] + NN[18] + NN[19] + NN[20] + NN[21] + NN[22] + NN[23] + NN[24];
    //logistic_term = (1 - total/K);
    //dN_dt[1] = 2*alpha*NN[3]*logistic_term - Beta*NN[1]*logistic_term - delta*NN[1]; // G0G1 compartment
    //dN_dt[2] = Beta*NN[1]*logistic_term - Gamma*NN[2]*logistic_term - delta*NN[2];                 // S compartment
    //dN_dt[3] = Gamma*NN[2]*logistic_term - alpha*NN[3]*logistic_term - delta*NN[3];   // G2M compartment
    // multistep model ODEs
    dN_dt[1] = 2*delta*NN[24] - alpha*NN[1]; // G0G1-a compartment
    dN_dt[2] = alpha*NN[1] - alpha*NN[2];   // G0G1-b compartment
    dN_dt[3] = alpha*NN[2] - alpha*NN[3];    // S-a compartment
    dN_dt[4] = alpha*NN[3]  - alpha*NN[4];  // S-b compartment
    dN_dt[5] = alpha*NN[4] - alpha*NN[5];   // G2M-a compartment
    dN_dt[6] = alpha*NN[5] - alpha*NN[6];   // G2M-b compartment
    dN_dt[7] = alpha*NN[6] - alpha*NN[7]; // G0G1-a compartment
    dN_dt[8] = alpha*NN[7] - alpha_drug*NN[8];   // G0G1-b compartment
    dN_dt[9] = alpha_drug*NN[8] - gamma*NN[9];    // S-a compartment
    dN_dt[10] = gamma*NN[9]  - gamma*NN[10];  // S-b compartment
    dN_dt[11] = gamma*NN[10] - gamma*NN[11];   // G2M-a compartment
    dN_dt[12] = gamma*NN[11] - gamma*NN[12];   // G2M-b compartment
    dN_dt[13] = gamma*NN[12] - gamma*NN[13]; // G0G1-a compartment
    dN_dt[14] = gamma*NN[13] - gamma*NN[14];   // G0G1-b compartment
    dN_dt[15] = gamma*NN[14] - gamma*NN[15];    // S-a compartment
    dN_dt[16] = gamma*NN[15] - gamma*NN[16];
    dN_dt[17] = gamma*NN[16] - delta*NN[17];
    dN_dt[18] = delta*NN[17] - delta*NN[18];
    dN_dt[19] = delta*NN[18] - delta*NN[19];
    dN_dt[20] = delta*NN[19] - delta*NN[20];
    dN_dt[21] = delta*NN[20] - delta*NN[21];
    dN_dt[22] = delta*NN[21] - delta*NN[22];
    dN_dt[23] = delta*NN[22] - delta*NN[23];
    dN_dt[24] = delta*NN[23] - delta*NN[24];
   // print(dN_dt);
    return dN_dt;
  }
  
  real[,] cell_count_dynamics(real[] times, real[] obs_times, 
                              real[] tx_times, real[,] tx_doses,
                              real t0, vector y0,
                              real[] params, real[,] x_r, int[] x_i,
                              data real rel_tol,
                              data real abs_tol,
                              data int max_num_steps){
    
    // times = vector of observation and treatment/passaging times

    //real N_int[size(times),3]; // matrix contains estimates at all times (real observations and treatment administration) 
    real N_int[size(times),24]; // matrix contains estimates at all times (real observations and treatment administration) 
    //real y_hat[size(obs_times),3]; // only contains estimates at observation times
    real y_hat[size(obs_times),24]; // only contains estimates at observation times
    int tx_index[size(tx_times)]; // index of treatment times in times vector
    int obs_index[size(obs_times)]; // index of observation times in times vector
    
    vector[24] y0_local = y0; 
    real t0_local = t0;

    for (t in 1:size(times)){
      // determine indicies of treatment administrations in times array
      for (a in 1:size(tx_times)){
        if (times[t] == tx_times[a]){
          tx_index[a] = t;
        }
      }
      // determine indicies of observations in times array
      for (a in 1:size(obs_times)){
        if (times[t] == obs_times[a]){
          obs_index[a] = t;
        }
      }
    }


    // pre-treatment tumor growth
    
    // print("tx_times:", tx_times);
    for (a in 1:size(tx_times)-1){ 
      // each treatment/passaging time
      int tx_index_start = tx_index[a]; 
      int tx_index_end = tx_index[a+1]-1;
      //real N_int_tmp[size(times[tx_index_start:tx_index_end]),3]; 
      vector[24] N_int_tmp[size(times[tx_index_start:tx_index_end])]; 
      
      real passage_fraction = tx_doses[a,4];

      //if (a < size(tx_times)){
      //  tx_index_end = tx_index[a+1]-1; // index before next treatment
      //} else{
      //  tx_index_end = size(times);
      //}

      //print("tx_index_start: ", tx_index_start);
      //print("tx_index_end: ", tx_index_end);
      //print(times[tx_index_start:tx_index_end]);
      //print(size(times[tx_index_start:tx_index_end]));

      // implement drug/passaging effect
      // note: x_r = {drugF, drugP, drugA}
      // note: tx_doses = {drugF, drugP, drugA, passaging}

      // account for passaging (default fraction is 1) 
      // print("pre passage y0:", y0_local);
      // print("passage fraction:", passage_fraction);
      y0_local[1] = passage_fraction*y0_local[1]; 
      y0_local[2] = passage_fraction*y0_local[2];
      y0_local[3] = passage_fraction*y0_local[3];
      y0_local[4] = passage_fraction*y0_local[4]; 
      y0_local[5] = passage_fraction*y0_local[5];
      y0_local[6] = passage_fraction*y0_local[6];
      y0_local[7] = passage_fraction*y0_local[7]; 
      y0_local[8] = passage_fraction*y0_local[8];
      y0_local[9] = passage_fraction*y0_local[9];
      y0_local[10] = passage_fraction*y0_local[10]; 
      y0_local[11] = passage_fraction*y0_local[11];
      y0_local[12] = passage_fraction*y0_local[12];
      y0_local[13] = passage_fraction*y0_local[13]; 
      y0_local[14] = passage_fraction*y0_local[14];
      y0_local[15] = passage_fraction*y0_local[15];
      y0_local[16] = passage_fraction*y0_local[16]; 
      y0_local[17] = passage_fraction*y0_local[17];
      y0_local[18] = passage_fraction*y0_local[18];
      y0_local[19] = passage_fraction*y0_local[19]; 
      y0_local[20] = passage_fraction*y0_local[20];
      y0_local[21] = passage_fraction*y0_local[21];
      y0_local[22] = passage_fraction*y0_local[22]; 
      y0_local[23] = passage_fraction*y0_local[23];
      y0_local[24] = passage_fraction*y0_local[24];
      
      
      // y0_local = y0_local * tx_doses[a,4];

      // add drug (default drug amount is 0)
      //x_r_local[1] = x_r_local[1] + tx_doses[a,1]; // fulvestrant
      //x_r_local[2] = x_r_local[2] + tx_doses[a,2]; // palbociclib
      //x_r_local[3] = x_r_local[3] + tx_doses[a,3]; // abemaciclib

      // print("tx_index_start: ",tx_index_start,"; tx_index_end: ", tx_index_end);
      // print("drug doses:", x_r[a,1:3]);
      // print("y0: ", y0_local);
      N_int_tmp = ode_bdf_tol(cell_population_dynamics, y0_local, t0_local,
                                times[tx_index_start:tx_index_end],
                                rel_tol, abs_tol, max_num_steps,
                                params, x_r[a,1:3], x_i);   

      for (compartment in 1:size(y0_local)) {
        N_int[tx_index_start:tx_index_end, compartment] = N_int_tmp[1:size(N_int_tmp), compartment];
      }  

      // update initial starting values
      y0_local[1] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 1];
      y0_local[2] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 2];
      y0_local[3] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 3];
      y0_local[4] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 4];
      y0_local[5] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 5];
      y0_local[6] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 6];
      y0_local[7] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 7];
      y0_local[8] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 8];
      y0_local[9] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 9];
      y0_local[10] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 10];
      y0_local[11] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 11];
      y0_local[12] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 12];
      y0_local[13] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 13];
      y0_local[14] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 14];
      y0_local[15] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 15];
      y0_local[16] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 16];
      y0_local[17] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 17];
      y0_local[18] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 18];
      y0_local[19] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 19];
      y0_local[20] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 20];
      y0_local[21] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 21];
      y0_local[22] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 22];
      y0_local[23] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 23];
      y0_local[24] = N_int_tmp[size(times[tx_index_start:tx_index_end]), 24];
      


      // update initial time
      t0_local = times[tx_index_end];
      }
      for (j in 1:size(times)){
        for (k in 1:24){
          N_int[j,k] = N_int[j,k] + 1;
        }
      } 
    // extract measurements at observation times only
    for (compartment in 1:size(y0)){
      y_hat[1:size(obs_index), compartment] = N_int[obs_index, compartment];
    }
  return y_hat;
  }
}

data {
  // cell cycle counts - palbociclib experiment
  int<lower = 1> T_obs_cc_p;                                // number of observations
  real<lower = 0> t_obs_cc_p[T_obs_cc_p];                       // measurement times 
  real<lower = 0> y_obs_cc_p[T_obs_cc_p,3];                     // measurment observations

  int<lower = 1> T_tx_cc_p;                                 // number of treatment/passaging times
  real<lower = 0> tx_times_cc_p[T_tx_cc_p];                 // treatment/passaging times
  real<lower = 0> tx_doses_cc_p[T_tx_cc_p, 4];              // passaging fractions and dose amounts

  int<lower = 1> T_times_cc_p;                              // number of times where something occurs (treatment/passaging and/or observation)
  real<lower = 0> times_cc_p[T_times_cc_p];                 // times where something occurs (treatment/passaging and/or observations)

  int<lower = 1> n_drug_combos_cc_p;                        // number of drug combos

  int<lower = 1> start_obs_cc_p[n_drug_combos_cc_p];        // index of where each drug combo starts in y_obs
  int<lower = 1> end_obs_cc_p[n_drug_combos_cc_p];          // index of where each drug combo ends in y_obs 
  int<lower = 1> n_obs_cc_p[n_drug_combos_cc_p];            // number of observation per drug combination

  int<lower = 1> start_tx_cc_p[n_drug_combos_cc_p];         // index of where each drug combo start in tx_doses
  int<lower = 1> end_tx_cc_p[n_drug_combos_cc_p];           // index of where each drug combo ends in tx_doses
  int<lower = 0> n_tx_cc_p[n_drug_combos_cc_p];             // number of treatment/passaging occurances per drug combination   

  int<lower = 1> start_times_cc_p[n_drug_combos_cc_p];      // index of where each drug combo starts in times_cc_p
  int<lower = 1> end_times_cc_p[n_drug_combos_cc_p];        // index of where each drug combo ends in times_cc_p
  int<lower = 0> n_times_cc_p[n_drug_combos_cc_p];          // number of times tx/passaging OR observation occurs per drug combination

  //cell total counts -- Palbociclib experiment
  int<lower = 1> T_obs_ct_p;                                // number of observations
  real<lower = 0> t_obs_ct_p[T_obs_ct_p];                       // measurement times 
  real<lower = 0> y_obs_ct_p[T_obs_ct_p];                     // measurment observations

  int<lower = 1> T_tx_ct_p;                                 // number of treatment/passaging times
  real<lower = 0> tx_times_ct_p[T_tx_ct_p];                 // treatment/passaging times
  real<lower = 0> tx_doses_ct_p[T_tx_ct_p, 4];              // passaging fractions and dose amounts

  int<lower = 1> T_times_ct_p;                              // number of times where something occurs (treatment/passaging and/or observation)
  real<lower = 0> times_ct_p[T_times_ct_p];                 // times where something occurs (treatment/passaging and/or observations)

  int<lower = 1> n_drug_combos_ct_p;                        // number of drug combos

  int<lower = 1> start_obs_ct_p[n_drug_combos_ct_p];        // index of where each drug combo starts in y_obs
  int<lower = 1> end_obs_ct_p[n_drug_combos_ct_p];          // index of where each drug combo ends in y_obs 
  int<lower = 1> n_obs_ct_p[n_drug_combos_ct_p];            // number of observation per drug combination

  int<lower = 1> start_tx_ct_p[n_drug_combos_ct_p];         // index of where each drug combo start in tx_doses
  int<lower = 1> end_tx_ct_p[n_drug_combos_ct_p];           // index of where each drug combo ends in tx_doses
  int<lower = 0> n_tx_ct_p[n_drug_combos_ct_p];             // number of treatment/passaging occurances per drug combination   

  int<lower = 1> start_times_ct_p[n_drug_combos_ct_p];      // index of where each drug combo starts in times_cc_p
  int<lower = 1> end_times_ct_p[n_drug_combos_ct_p];        // index of where each drug combo ends in times_cc_p
  int<lower = 0> n_times_ct_p[n_drug_combos_ct_p];          // number of times tx/passaging OR observation occurs per drug combination 

 // cell cycle counts - palbociclib experiment-modified
  int<lower=1> n_obs_ODE_cc;
  int<lower=1> T_obs_ODE_cc;
  real<lower=0> t_obs_ODE_cc[T_obs_ODE_cc];
  int<lower=1> start_obs_ODE_cc[n_drug_combos_cc_p];
  int<lower=1> end_obs_ODE_cc[n_drug_combos_cc_p];
  int<lower=1> T_times_ODE_cc;
  int<lower=1> start_times_ODE_cc[n_drug_combos_cc_p];
  int<lower=1> end_times_ODE_cc[n_drug_combos_cc_p];
  real<lower=0> times_ODE_cc[T_times_ODE_cc];
  
  //cell total counts -- Palbociclib experiment-modified
  int<lower=1> n_obs_ODE_ct;
  int<lower=1> T_obs_ODE_ct;
  real<lower=0> t_obs_ODE_ct[T_obs_ODE_ct];
  int<lower=1> start_obs_ODE_ct[n_drug_combos_ct_p];
  int<lower=1> end_obs_ODE_ct[n_drug_combos_ct_p];
  int<lower=1> T_times_ODE_ct;
  int<lower=1> start_times_ODE_ct[n_drug_combos_ct_p];
  int<lower=1> end_times_ODE_ct[n_drug_combos_ct_p];
  real<lower=0> times_ODE_ct[T_times_ODE_ct];
  
  // cell cycle counts - Abemaciclib experiment
//  int<lower = 1> T_obs_cc_a;                                // number of observations
//  real<lower = 0> t_obs_cc_a[T_obs_cc_a];                       // measurement times 
//  real<lower = 0> y_obs_cc_a[T_obs_cc_a,3];                     // measurment observations

//  int<lower = 1> T_tx_cc_a;                                 // number of treatment/passaging times
//  real<lower = 0> tx_times_cc_a[T_tx_cc_a];                 // treatment/passaging times
//  real<lower = 0> tx_doses_cc_a[T_tx_cc_a, 4];              // passaging fractions and dose amounts

//  int<lower = 1> T_times_cc_a;                              // number of times where something occurs (treatment/passaging and/or observation)
//  real<lower = 0> times_cc_a[T_times_cc_a];                 // times where something occurs (treatment/passaging and/or observations)

//  int<lower = 1> n_drug_combos_cc_a;                        // number of drug combos

//  int<lower = 1> start_obs_cc_a[n_drug_combos_cc_a];        // index of where each drug combo starts in y_obs
//  int<lower = 1> end_obs_cc_a[n_drug_combos_cc_a];          // index of where each drug combo ends in y_obs 
//  int<lower = 1> n_obs_cc_a[n_drug_combos_cc_a];            // number of observation per drug combination

//  int<lower = 1> start_tx_cc_a[n_drug_combos_cc_a];         // index of where each drug combo start in tx_doses
//  int<lower = 1> end_tx_cc_a[n_drug_combos_cc_a];           // index of where each drug combo ends in tx_doses
//  int<lower = 0> n_tx_cc_a[n_drug_combos_cc_a];             // number of treatment/passaging occurances per drug combination   

//  int<lower = 1> start_times_cc_a[n_drug_combos_cc_a];      // index of where each drug combo starts in times_cc_p
//  int<lower = 1> end_times_cc_a[n_drug_combos_cc_a];        // index of where each drug combo ends in times_cc_p
//  int<lower = 0> n_times_cc_a[n_drug_combos_cc_a];          // number of times tx/passaging OR observation occurs per drug combination
 
  //cell total counts -- Abemaciclib experiment
//  int<lower = 1> T_obs_ct_a;                                // number of observations
//  real<lower = 0> t_obs_ct_a[T_obs_ct_a];                       // measurement times 
//  real<lower = 0> y_obs_ct_a[T_obs_ct_a];                     // measurment observations

//  int<lower = 1> T_tx_ct_a;                                 // number of treatment/passaging times
//  real<lower = 0> tx_times_ct_a[T_tx_ct_a];                 // treatment/passaging times
//  real<lower = 0> tx_doses_ct_a[T_tx_ct_a, 4];              // passaging fractions and dose amounts

//  int<lower = 1> T_times_ct_a;                              // number of times where something occurs (treatment/passaging and/or observation)
//  real<lower = 0> times_ct_a[T_times_ct_a];                 // times where something occurs (treatment/passaging and/or observations)

//  int<lower = 1> n_drug_combos_ct_a;                        // number of drug combos

//  int<lower = 1> start_obs_ct_a[n_drug_combos_ct_a];        // index of where each drug combo starts in y_obs
//  int<lower = 1> end_obs_ct_a[n_drug_combos_ct_a];          // index of where each drug combo ends in y_obs 
//  int<lower = 1> n_obs_ct_a[n_drug_combos_ct_a];            // number of observation per drug combination

//  int<lower = 1> start_tx_ct_a[n_drug_combos_ct_a];         // index of where each drug combo start in tx_doses
//  int<lower = 1> end_tx_ct_a[n_drug_combos_ct_a];           // index of where each drug combo ends in tx_doses
//  int<lower = 0> n_tx_ct_a[n_drug_combos_ct_a];             // number of treatment/passaging occurances per drug combination   

//  int<lower = 1> start_times_ct_a[n_drug_combos_ct_a];      // index of where each drug combo starts in times_cc_p
//  int<lower = 1> end_times_ct_a[n_drug_combos_ct_a];        // index of where each drug combo ends in times_cc_p
//  int<lower = 0> n_times_ct_a[n_drug_combos_ct_a];          // number of times tx/passaging OR observation occurs per drug combination 

  // longterm passaging cell total counts -- palbociclib
//  int<lower = 1> T_obs_pass_p;                                // number of observations
//  real<lower = 0> t_obs_pass_p[T_obs_pass_p];                       // measurement times 
//  real<lower = 0> y_obs_pass_p[T_obs_pass_p];                     // measurment observations
  
//  int<lower = 1> T_tx_pass_p;                                 // number of treatment/passaging times
//  real<lower = 0> tx_times_pass_p[T_tx_pass_p];                 // treatment/passaging times
//  real<lower = 0> tx_doses_pass_p[T_tx_pass_p, 4];              // passaging fractions and dose amounts
  
//  int<lower = 1> T_times_pass_p;                              // number of times where something occurs (treatment/passaging and/or observation)
//  real<lower = 0> times_pass_p[T_times_pass_p];                 // times where something occurs (treatment/passaging and/or observations)
  
//  int<lower = 1> n_drug_combos_pass_p;                        // number of drug combos
  
//  int<lower = 1> start_obs_pass_p[n_drug_combos_pass_p];        // index of where each drug combo starts in y_obs
//  int<lower = 1> end_obs_pass_p[n_drug_combos_pass_p];          // index of where each drug combo ends in y_obs 
//  int<lower = 1> n_obs_pass_p[n_drug_combos_pass_p];            // number of observation per drug combination
  
//  int<lower = 1> start_tx_pass_p[n_drug_combos_pass_p];         // index of where each drug combo start in tx_doses
//  int<lower = 1> end_tx_pass_p[n_drug_combos_pass_p];           // index of where each drug combo ends in tx_doses
//  int<lower = 0> n_tx_pass_p[n_drug_combos_pass_p];             // number of treatment/passaging occurances per drug combination   
  
//  int<lower = 1> start_times_pass_p[n_drug_combos_pass_p];      // index of where each drug combo starts in times_cc_p
//  int<lower = 1> end_times_pass_p[n_drug_combos_pass_p];        // index of where each drug combo ends in times_cc_p
//  int<lower = 0> n_times_pass_p[n_drug_combos_pass_p];          // number of times tx/passaging OR observation occurs per drug combination


  // longterm passaging cell total counts -- abemaciclib
//  int<lower = 1> T_obs_pass_a;                                // number of observations
//  real<lower = 0> t_obs_pass_a[T_pass_a];                       // measurement times 
//  real<lower = 0> y_obs_pass_a[T_pass_a,3];                     // measurment observations
  
//  int<lower = 1> T_tx_pass_a;                                 // number of treatment/passaging times
//  real<lower = 0> tx_times_pass_a[T_tx_pass_a];                 // treatment/passaging times
//  real<lower = 0> tx_doses_pass_a[T_tx_pass_a, 4];              // passaging fractions and dose amounts
  
//  int<lower = 1> T_times_pass_a;                              // number of times where something occurs (treatment/passaging and/or observation)
//  real<lower = 0> times_pass_a[T_times_pass_a];                 // times where something occurs (treatment/passaging and/or observations)
  
//  int<lower = 1> n_drug_combos_pass_a;                        // number of drug combos
  
//  int<lower = 1> start_obs_pass_a[n_drug_combos_pass_a];        // index of where each drug combo starts in y_obs
//  int<lower = 1> end_obs_pass_a[n_drug_combos_pass_a];          // index of where each drug combo ends in y_obs 
//  int<lower = 1> n_obs_pass_a[n_drug_combos_pass_a];            // number of observation per drug combination
  
//  int<lower = 1> start_tx_pass_a[n_drug_combos_pass_a];         // index of where each drug combo start in tx_doses
//  int<lower = 1> end_tx_pass_a[n_drug_combos_pass_a];           // index of where each drug combo ends in tx_doses
//  int<lower = 0> n_tx_pass_a[n_drug_combos_pass_a];             // number of treatment/passaging occurances per drug combination   
  
//  int<lower = 1> start_times_pass_a[n_drug_combos_pass_a];      // index of where each drug combo starts in times_cc_p
//  int<lower = 1> end_times_pass_a[n_drug_combos_pass_a];        // index of where each drug combo ends in times_cc_p
//  int<lower = 0> n_times_pass_a[n_drug_combos_pass_a];          // number of times tx/passaging OR observation occurs per drug combination

  real t0; 
  real rel_tol;
  real abs_tol;
  int max_num_steps;
}

transformed data {
  // palbociclib experiment
  //real logy_obs_cc_p[T_obs_cc_p,3]; // cell count observations (cell cycle)
  real logy_obs_ct_p[T_obs_ct_p]; // cell count observations (cell total)
//  real logy_obs_pass_p[T_obs_pass_p]; // cell count observations (cell passaging totals)

  // abemaciclib experiment
//  real logy_obs_cc_a[T_obs_cc_a,3];
//  real logy_obs_ct_a[T_obs_ct_a];
 // real logy_obs_pass_p[T_obs_pass_a]; // cell count observations (cell passaging totals)

  // cell cycle counts - palbociclib experiment
  //logy_obs_cc_p = log(y_obs_cc_p);        // log observed measurements
  
  // cell total counts - palbociclib experiment
  logy_obs_ct_p = log(y_obs_ct_p);        // log observed measurements

  // longterm passaging cell total counts -- palbociclib experiment
//  logy_obs_pass_p = log(y_obs_pass_p);
  
  // cell cycle counts - abemaciclib experiment
//  logy_obs_cc_a = log(y_obs_cc_a);        // log observed measurements
  
  // cell total counts - abemaciclib experiment
//  logy_obs_ct_a = log(y_obs_ct_a);        // log observed measurements
  
  // longterm passaging cell total counts -- abemaciclib experiment
//  logy_obs_pass_a = log(y_obs_pass_a)
}

parameters{
   vector<lower=0>[4] sigma;
  real<lower=0> alpha;
//  real<lower=0> b_A;
  real<lower=0> b_P;
  //real<lower=0> b_F;
  //real<lower=0> b_P;
  //real<lower=0> b_F;
//  real<lower=0> c_A;
  real<lower=0> c_P;
  //real<lower=0> c_F;
  real<lower=0> alpha_max;
  real<lower=0> gamma;
  real<lower=0> delta;
  //real<lower=0> alpha_zero;
  //real<lower=0> Beta;
  //real a_FP;
  //real<lower=-1, upper=0> a_FP;
  //real<upper=0> a_PF;
//  real a_FA;
  //real<lower=0> Gamma;
  //real<lower=0> delta;
  //real<lower=0> K;
  //vector<lower=0>[3] y0_cc_p; // initial state for cell cycle experiment -- palbo
  vector<lower=0>[3] y0_ct_p; // initial state for cell total experiment -- palbo
 // real<lower=0> y0_pass_p[3]; // initial state for cell passaging experiment -- palbo
//  real<lower=0> y0_cc_a[3]; // initial state for cell cycle experiment -- abema
//  real<lower=0> y0_ct_a[3]; // initial state for cell total experiment -- abema
  // real<lower=0> y0_pass_a[3]; // intial state for cell passaging experiment -- abema
}

transformed parameters{
  //matrix<lower=0>[T_obs_ODE_cc,3] y_hat_cc_p ;
  matrix<lower=0>[T_obs_ODE_ct,3] y_hat_ct_p ;
  real params[6];
  params[1] = alpha;
//  params[2] = b_A;
  params[2] = b_P;
  //params[3] = b_F;
//  params[5] = c_A;
  params[3] = c_P;
  //params[5] = c_F;
  //params[6] = a_FP;
//  params[9] = a_FA;
  params[4] = alpha_max;
  params[5] = gamma;
  params[6] = delta;

     

     
     vector[24] y0_ct_pp;
     for (h in 1:3){
        int h_temp; 
        h_temp = 8*h - 7;
        y0_ct_pp[h_temp] = y0_ct_p[h]/8;
        y0_ct_pp[h_temp + 1] =  y0_ct_pp[h_temp];
        y0_ct_pp[h_temp + 2] =  y0_ct_pp[h_temp];
        y0_ct_pp[h_temp + 3] =  y0_ct_pp[h_temp];
        y0_ct_pp[h_temp + 4] =  y0_ct_pp[h_temp];
        y0_ct_pp[h_temp + 5] =  y0_ct_pp[h_temp];
        y0_ct_pp[h_temp + 6] =  y0_ct_pp[h_temp];
        y0_ct_pp[h_temp + 7] =  y0_ct_pp[h_temp];
     }
  for (i in 1:n_drug_combos_ct_p){
    real y_hat_temp[n_obs_ODE_ct,24];
     int x_i[3];
    x_i = {0, 0, 0};
    y_hat_temp = cell_count_dynamics(times_ODE_ct[start_times_ODE_ct[i]:end_times_ODE_ct[i]],
                                    t_obs_ODE_ct[start_obs_ODE_ct[i]:end_obs_ODE_ct[i]],
                                    tx_times_ct_p[start_tx_ct_p[i]:end_tx_ct_p[i]],
                                    tx_doses_ct_p[start_tx_ct_p[i]:end_tx_ct_p[i]],
                                    t0, y0_ct_pp, params, 
                                    tx_doses_ct_p[start_tx_ct_p[i]:end_tx_ct_p[i], 1:4],
                                    x_i,
                                    rel_tol, abs_tol, max_num_steps);
                            
        y_hat_ct_p[start_obs_ODE_ct[i]:end_obs_ODE_ct[i], 1] = to_vector(y_hat_temp[1:n_obs_ODE_ct, 1]);
      for (iter in 1:7){
        y_hat_ct_p[start_obs_ODE_ct[i]:end_obs_ODE_ct[i], 1] = y_hat_ct_p[start_obs_ODE_ct[i]:end_obs_ODE_ct[i], 1] + to_vector(y_hat_temp[1:n_obs_ODE_ct, 1 + iter]);
      }
      

       y_hat_ct_p[start_obs_ODE_ct[i]:end_obs_ODE_ct[i], 2] = to_vector(y_hat_temp[1:n_obs_ODE_ct, 9]);
      for (iter in 1:7){
        y_hat_ct_p[start_obs_ODE_ct[i]:end_obs_ODE_ct[i], 2] = y_hat_ct_p[start_obs_ODE_ct[i]:end_obs_ODE_ct[i], 2] + to_vector(y_hat_temp[1:n_obs_ODE_ct, 9 + iter]);
      }
      
  
      y_hat_ct_p[start_obs_ODE_ct[i]:end_obs_ODE_ct[i], 3] = to_vector(y_hat_temp[1:n_obs_ODE_ct, 17]);
      for (iter in 1:7){
        y_hat_ct_p[start_obs_ODE_ct[i]:end_obs_ODE_ct[i], 3] = y_hat_ct_p[start_obs_ODE_ct[i]:end_obs_ODE_ct[i], 3] + to_vector(y_hat_temp[1:n_obs_ODE_ct, 17 + iter]);
      }
    
  }
  
 
}

model{
   sigma ~ cauchy(0,1);
   alpha ~ normal(16,2); 
   gamma ~ normal(16,2);
   delta ~ normal(16,2);
   b_P ~ normal(1, 1);
   //b_F ~ normal(1 ,1);
  c_P ~ normal(1, 1);
  //c_F ~ normal(1, 1); 
  //a_FP ~ normal(-1,1);
  alpha_max ~ normal(1, 1);

  
  //y0_cc_p[1] ~ normal(3000,300);
  //y0_cc_p[2] ~ normal(300,30);
  //y0_cc_p[3] ~ normal(500,50);
  
  y0_ct_p[1] ~ normal(10000,1000);
  y0_ct_p[2] ~ normal(1000,100);
  y0_ct_p[3] ~ normal(1500,150);




  
  // cell total data
  for (i in 1:n_drug_combos_ct_p){
    for (j in start_obs_ct_p[i]:end_obs_ct_p[i]){
      for (k in 1:n_obs_ODE_ct)
         if (t_obs_ct_p[j] == k){
           logy_obs_ct_p[j] ~ normal(log(y_hat_ct_p[((i-1)*n_obs_ODE_ct + k), 1] + y_hat_ct_p[((i-1)*n_obs_ODE_ct + k), 2] + y_hat_ct_p[((i-1)*n_obs_ODE_ct + k), 3]  ), sigma[4]);
         }
    }
  }

}
generated quantities{  //??Are those qunatities given by the solutions of ODEs??
  //palbociclib
  //real<lower=0> y_pred_cc_p[T_obs_cc_p,3];
  real<lower=0> y_pred_ct_p[T_obs_ct_p];
  //vector[T_obs_cc_p] log_lik_cc_p;
  vector[T_obs_ct_p] log_lik_ct_p;


  for (i in 1:n_drug_combos_ct_p){
    for (j in start_obs_ct_p[i]:end_obs_ct_p[i]){
      for (k in 1:n_obs_ODE_ct)
         if (t_obs_ct_p[j] == k){
           y_pred_ct_p[j] = exp(normal_rng( log(y_hat_ct_p[((i-1)*n_obs_ODE_ct + k), 1] + y_hat_ct_p[((i-1)*n_obs_ODE_ct + k), 2] + y_hat_ct_p[((i-1)*n_obs_ODE_ct + k), 3]  ), sigma[4]));
           log_lik_ct_p[j] = exp(normal_lpdf(logy_obs_ct_p[j] | log(y_hat_ct_p[((i-1)*n_obs_ODE_ct + k), 1] + y_hat_ct_p[((i-1)*n_obs_ODE_ct + k), 2] + y_hat_ct_p[((i-1)*n_obs_ODE_ct + k), 3]  ), sigma[4]));
         }
    }
  }



}

