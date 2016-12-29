README to accompany Mathematical Programming Computation submission

Authors: Guanglin Xu and Samuel Burer
Date   : December 10, 2015 

================================================================================

QUICK INSTRUCTIONS ON

Generate Instances, Run Tests, and Read Results.

================================================================================

INSTRUCTIONS

1. Instance Generating

To generate test instances, the following files / environments are required:

  Software / Files                                  Version tested
  ---------------------------------------------     --------------
  Matlab                                            7.14.0.739 (R2012a)
  instance_generator/gen_IVQR.m                     0
  instance_generator/script2generateIQR.m           0
  instance_generator/gen_all_instances.m            0

After getting the environment ready and putting the files there,
the reader just need to run gen_all_instances.m in current folder.
The three types of instances containing the Small-IVQR, the Medium-IVQR
and the Large-IVQR instances will be generated under the path
‘instances/’.

2. Test Against Couenne on Small-IVQR instances

  Software / Files                                  Version tested
  ---------------------------------------------     --------------
  Couenne                                           0.4
  CPLEX                                             12.4
  Matlab                                            7.14.0.739 (R2012a)
  AMPL                                              20130117
  vs_couenne/on_small/compare.m                     0
  vs_couenne/on_small/couenne.opt                   0
  vs_couenne/on_small/get_data_from_ampl.m          0
  vs_couenne/on_small/get_opt_val.m                 0
  vs_couenne/on_small/invlp.mod                     0
  vs_couenne/on_small/invlp.run                     0
  vs_couenne/on_small/qp_relaxation.m               0
  vs_couenne/on_small/write_ampl_data.m             0
  instances/small_IVQR.mat                          0

After getting the environment ready, the reader just need to run
the file ‘compare.m’ under the the path ‘vs_couenne/on_small/’.
The testing result will be generated under the path
‘results/result_couenne_small.mat’. The result includes:

  * obj_q : optimal value from QPBB
  * sol_q : optimal solution from QPBB
  * ind_q : solution status from QPBB including 'failure', 'solved', and 'limit'
  * time_q: computation time from QPBB
  * obj_c : optimal value from Couenne
  * sol_c : optimal solution from Couenne
  * ind_c : solution status from Couenne including 'failure', 'solved?', and 'limit'
  * time_c: computation time from Couenne

3. Test Against Couenne on Medium-IVQR instances

  Software / Files                                  Version tested
  ---------------------------------------------     --------------
  Couenne                                           0.4
  CPLEX                                             12.4
  Matlab                                            7.14.0.739 (R2012a)
  AMPL                                              20130117
  vs_couenne/on_medium/compare.m                     0
  vs_couenne/on_medium/couenne.opt                   0
  vs_couenne/on_medium/get_data_from_ampl.m          0
  vs_couenne/on_medium/get_opt_val.m                 0
  vs_couenne/on_medium/invlp.mod                     0
  vs_couenne/on_medium/invlp.run                     0
  vs_couenne/on_medium/qp_relaxation.m               0
  vs_couenne/on_medium/write_ampl_data.m             0
  instances/medium_IVQR.mat                          0


After getting the environment ready, the reader just need to run
the file ‘compare.m’ under the path ‘vs_couenne/on_medium/’.
The testing result will be generated under the path
‘results/result_couenne_medium.mat’. The result includes:

  * obj_q : optimal value from QPBB
  * sol_q : optimal solution from QPBB
  * ind_q : solution status from QPBB including 'failure', 'solved', and 'limit'
  * time_q: computation time from QPBB
  * obj_c : optimal value from Couenne
  * sol_c : optimal solution from Couenne
  * ind_c : solution status from Couenne including 'failure', 'solved?', and 'limit'
  * time_c: computation time from Couenne

4. Test Against Couenne on Large-IVQR instances

  Software / Files                                  Version tested
  ---------------------------------------------     --------------
  Couenne                                           0.4
  CPLEX                                             12.4
  Matlab                                            7.14.0.739 (R2012a)
  AMPL                                              20130117
  vs_couenne/on_large/compare.m                     0
  vs_couenne/on_large/couenne.opt                   0
  vs_couenne/on_large/get_data_from_ampl.m          0
  vs_couenne/on_large/get_opt_val.m                 0
  vs_couenne/on_large/invlp.mod                     0
  vs_couenne/on_large/invlp.run                     0
  vs_couenne/on_large/qp_relaxation.m               0
  vs_couenne/on_large/write_ampl_data.m             0
  instances/large_IVQR.mat                          0


After getting the environment ready, the reader just need to run
the file ‘compare.m’ under the the path ‘vs_couenne/on_large/’. The
testing result will be generated under the path ‘results/result_couenne_large.mat’.
The result includes:

  * obj_q : optimal value from QPBB
  * sol_q : optimal solution from QPBB
  * ind_q : solution status from QPBB including 'failure', 'solved', and 'limit'
  * time_q: computation time from QPBB
  * obj_c : optimal value from Couenne
  * sol_c : optimal solution from Couenne
  * ind_c : solution status from Couenne including 'failure', 'solved?', and 'limit'
  * time_c: computation time from Couenne

5. Test Against CPLEX on Small-IVQR instances

  Software / Files                                  Version tested
  ---------------------------------------------     --------------
  CPLEX                                             12.4
  Matlab                                            7.14.0.739 (R2012a)
  vs_cplex/on_small/compare.m                                0
  vs_cplex/on_small/mip_cplex.m                              0
  vs_cplex/on_small/qp_relaxation.m                          0
  instances/small_IVQR.mat                                   0

After getting the environment ready, the reader just need to run
the file ‘compare.m’ under the the folder of ‘vs_cplex/on_small’. The
testing result will be generated under the folder ‘results/result_cplex_small.mat’.
The result includes:

  * obj_q : optimal value from QPBB
  * sol_q : optimal solution from QPBB
  * ind_q : solution status from QPBB including 'failure', 'solved', and 'limit'
  * time_q: computation time from QPBB
  * obj_c : optimal value from CPLEX
  * sol_c : optimal solution from CPLEX
  * ind_c : solution status from CPLEX including 'failure', 'solved?', and 'limit'
  * time_c: computation time from CPLEX

6. Test Against CPLEX on Medium-IVQR instances

  Software / Files                                  Version tested
  ---------------------------------------------     --------------
  CPLEX                                             12.4
  Matlab                                            7.14.0.739 (R2012a)
  vs_cplex/on_medium/compare.m                                0
  vs_cplex/on_medium/mip_cplex.m                              0
  vs_cplex/on_medium/qp_relaxation.m                          0
  instances/medium_IVQR.mat                                   0

After getting the environment ready, the reader first just need to run
the file ‘compare.m’ under the the folder of ‘vs_cplex/on_medium’. The
testing result will be generated under the folder ‘results/result_cplex_medium.mat’.
The result includes:

  * obj_q : optimal value from QPBB
  * sol_q : optimal solution from QPBB
  * ind_q : solution status from QPBB including 'failure', 'solved', and 'limit'
  * time_q: computation time from QPBB
  * obj_c : optimal value from CPLEX
  * sol_c : optimal solution from CPLEX
  * ind_c : solution status from CPLEX including 'failure', 'solved?', and 'limit'
  * time_c: computation time from CPLEX

7. Test Against CPLEX on Large-IVQR instances

  Software / Files                                  Version tested
  ---------------------------------------------     --------------
  CPLEX                                             12.4
  Matlab                                            7.14.0.739 (R2012a)
  vs_cplex/on_medium/compare.m                                0
  vs_cplex/on_medium/mip_cplex.m                              0
  vs_cplex/on_medium/qp_relaxation.m                          0
  instances/large_IVQR.mat                                    0

After getting the environment ready, the reader first just need to run
the file ‘compare.m’ under the the folder of ‘vs_cplex/on_large’. The
testing result will be generated under the folder ‘results/result_cplex_large.mat’.
The result includes:

  * obj_q : optimal value from QPBB
  * sol_q : optimal solution from QPBB
  * ind_q : solution status from QPBB including 'failure', 'solved', and 'limit'
  * time_q: computation time from QPBB
  * obj_c : optimal value from CPLEX
  * sol_c : optimal solution from CPLEX
  * ind_c : solution status from CPLEX including 'failure', 'solved?', and 'limit'
  * time_c: computation time from CPLEX

8. Sensitivity analysis on big_M (for small_IVQR instances)

  Software / Files                                  Version tested
  ---------------------------------------------     --------------
  CPLEX                                             12.4
  Matlab                                            7.14.0.739 (R2012a)
  sensitivity/compare.m                             0
  sensitivity/gen_bigM.m                            0
  instances/small_IVQR.mat                          0
  instances/small_bigM.mat                          0
  sensitivity/mip_cplex.m                           0
  sensitivity/qp_relaxation.m                       0

After getting the environment ready, first the reader need to run
the file 'gen_bigM.m' under the folder of 'sensitivity' to get the tightest bigM
values for all small_IVQR instances. The generated bigM values are stored in
'small_bigM.mat' under the folder of 'instances/'. Then, the reader need to
run the file ‘compare.m’ under the the folder of ‘sensitivity/’. The
testing result will be generated under the folder ‘results/sensitivity_small.mat’.
The result includes:

  * obj_q : optimal value from QPBB
  * sol_q : optimal solution from QPBB
  * node_q: number of nodes solved by QPBB
  * time_q: computation time from QPBB
  * obj_c : optimal value from CPLEX
  * ind_c : solution status from CPLEX including 'failure', 'solved?', and 'limit'
  * time_c: computation time from CPLEX

9. Plot comparison results

  Software / Files                                  Version tested
  ---------------------------------------------     --------------
  Matlab                                            7.14.0.739 (R2012a)
  plotting/plotting.m                               0
  plotting/plot_small_couenne.m                     0
  plotting/plot_medium_couenne.m                    0
  plotting/plot_large_couenne.m                     0
  plotting/plot_small_cplex.m                       0
  plotting/plot_medium_cplex.m                      0
  plotting/sensitivity_plot.m                       0
  results/result_couenne_small.mat                  0
  results/result_couenne_medium.mat                 0
  results/result_couenne_large.mat                  0
  results/result_cplex_small.mat                    0
  results/result_cplex_medium.mat                   0
  results/result_cplex_large.mat                    0
  results/sensitivity_small.mat                     0

After getting the environment ready, the reader just need to run
the file ‘plotting.m’ under the the path ‘plotting/’. All the figures can
be generated under the path 'figures/'. The figures include:

  * compare_small_couenne : comparison of QPBB and Couenne on Small-IVQR instances
  * compare_medium_couenne : comparison of QPBB and Couenne on Medium-IVQR instances
  * compare_large_couenne : comparison of QPBB and Couenne on Large-IVQR instances
  * compare_small_cplex : comparison of QPBB and CPLEX on Small-IVQR instances
  * compare_medium_cplex : comparison of QPBB and CPLEX on Medium-IVQR instances
  * compare_large_cplex : comparison of QPBB and CPLEX on Large-IVQR instances
  * bigM : comparison of QPBB and CPLEX on 100 Small-IVQR instances with setting big M to be bigM
  * 2bigM : comparison of QPBB and CPLEX on 100 Small-IVQR instances with setting big M to be 2bigM
  * 5bigM : comparison of QPBB and CPLEX on 100 Small-IVQR instances with setting big M to be 5bigM
  * 10bigM : comparison of QPBB and CPLEX on 100 Small-IVQR instances with setting big M to be 10bigM
  * box : the box plot of the number of nodes solved by QPBB on the 100 small-IVQR instances with bigM, 
          2bigM, 5bigM, 10bigM, and Inf


It is suspected that relatively recent prior versions of the above
software / environments should work.

================================================================================

NOTES

1) As the codes is developing for research not for commerical purpose, we
don't provide generic way to set feasible, fathoming, and optimality
tolerance. We don't recommend the reader to change the tolerance and
just keep them as what they are shown in the paper.
2) If the reader wants to change the time limit for the solvers, s/he can
just change the value of time_limit in the file of compare.m for QPBB or CPLEX and open
the file couenne.opt and change the value of time_limit in it. 
