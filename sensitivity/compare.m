clear
clc

addpath('../instances');

load('small_IVQR.mat');
load('small_bigM.mat');


lgth = 100; %length(instances);
% we only compute the results for the first 100 instances in small_IVQR

time_q = zeros(5,lgth);
node_q = zeros(5,lgth);
obj_q = Inf(5,lgth);
ind_q = cell(5,lgth);

time_c = zeros(5,lgth);
obj_c = Inf(5,lgth);
ind_c = cell(5,lgth);


time_limit = 1800;

diary('../results/log_sensitivity_small.txt');

for i = 1 : lgth
  
  % Enforce matlab to run with a single computation thread. 
  maxNumCompThreads(1);
  
  diary on
  i
  fprintf('Now processing on small_IVQR instance %d\n\n', i );


  A1       = instances{i}{1};
  A2       = instances{i}{2};
  A3       = instances{i}{3};
  b        = instances{i}{4};
  
  m  = size(A1, 1);
  n1 = size(A1, 2);
  n2 = size(A2, 2);
  
  x1_L  =           1;  x1_U  =         n1;
  x2_L  =    x1_U + 1;  x2_U  = x1_U  + n2;
  x3p_L =    x2_U + 1;  x3p_U =  x2_U +  m;
  x3m_L =   x3p_U + 1;  x3m_U = x3p_U +  m;
  sp_L  =   x3m_U + 1;  sp_U  = x3m_U +  m;
  sm_L  =    sp_U + 1;  sm_U  =  sp_U +  m;
  
  big_M = Inf;
  
  fprintf('-------running qpbb with big M = Inf -------\n');
  tic
  [fval, x_qp, ret, node] = qp_relaxation( A1, A2, b, big_M, time_limit );
  time_q(1,i) = toc;
  node_q(1,i) = node;
  obj_q(1,i) = fval;
  ind_q{1,i} = ret;
  
  fprintf('## time_qp = %f\n', toc);
  fprintf('## objval_qp = %f\n', fval);
  fprintf('## retcode_qp = %s\n\n', ret);

 
  
  big_M = bigM(i);
  
  fprintf('-------running qpbb with big M = bigM -------\n');
  tic
  [fval, x_qp, ret, node] = qp_relaxation( A1, A2, b, big_M, time_limit );
  time_q(2,i) = toc;
  node_q(2,i) = node;
  obj_q(2,i) = fval;
  ind_q{2,i} = ret;
  
  fprintf('## time_qp = %f\n', toc);
  fprintf('## objval_qp = %f\n', fval);
  fprintf('## retcode_qp = %s\n\n', ret);
  
  fprintf('-------running cplex with big M = bigM -------\n');        
  tic
  [ obj, sol, ret_code ] = mip_cplex( A1, A2, b, big_M, time_limit );
  time_c(2,i) = toc;
  obj_c(2,i) = obj;
  ind_c{2,i} = ret_code;
  
  fprintf('## time_cplex = %f\n', toc);
  fprintf('## objval_cplex = %f\n', obj);
  fprintf('## retcode_cplex = %s\n\n\n', ret_code);
  
  
  big_M = 2*bigM(i);
  
  fprintf('-------running qpbb with big M = 2*bigM -------\n');
  tic
  [fval, x_qp, ret, node] = qp_relaxation( A1, A2, b, big_M, time_limit );
  time_q(3,i) = toc;
  node_q(3,i) = node;
  obj_q(3,i) = fval;
  ind_q{3,i} = ret;
  
  fprintf('## time_qp = %f\n', toc);
  fprintf('## objval_qp = %f\n', fval);
  fprintf('## retcode_qp = %s\n\n', ret);
  
  fprintf('-------running cplex with big M = 2*bigM -------\n');       
  tic
  [ obj, sol, ret_code ] = mip_cplex( A1, A2, b, big_M, time_limit );
  time_c(3,i) = toc;
  obj_c(3,i) = obj;
  ind_c{3,i} = ret_code;
  
  fprintf('## time_cplex = %f\n', toc);
  fprintf('## objval_cplex = %f\n', obj);
  fprintf('## retcode_cplex = %s\n\n\n', ret_code);
  
  
  big_M = 5*bigM(i);
  
  fprintf('-------running qpbb with big M = 5*bigM -------\n');
  tic
  [fval, x_qp, ret, node] = qp_relaxation( A1, A2, b, big_M, time_limit );
  time_q(4,i) = toc;
  node_q(4,i) = node;
  obj_q(4,i) = fval;
  ind_q{4,i} = ret;
  
  fprintf('## time_qp = %f\n', toc);
  fprintf('## objval_qp = %f\n', fval);
  fprintf('## retcode_qp = %s\n\n', ret);
  
  fprintf('-------running cplex with big M = 5*bigM -------\n');        
  tic
  [ obj, sol, ret_code ] = mip_cplex( A1, A2, b, big_M, time_limit );
  time_c(4,i) = toc;
  obj_c(4,i) = obj;
  ind_c{4,i} = ret_code;
  
  fprintf('## time_cplex = %f\n', toc);
  fprintf('## objval_cplex = %f\n', obj);
  fprintf('## retcode_cplex = %s\n\n\n', ret_code);
  
  big_M = 10*bigM(i);
  
  fprintf('-------running qpbb with big M = 10*bigM -------\n'); 
  tic
  [fval, x_qp, ret, node] = qp_relaxation( A1, A2, b, big_M, time_limit );
  time_q(5,i) = toc;
  node_q(5,i) = node;
  obj_q(5,i) = fval;
  ind_q{5,i} = ret;
  
  fprintf('## time_qp = %f\n', toc);
  fprintf('## objval_qp = %f\n', fval);
  fprintf('## retcode_qp = %s\n\n', ret);
  
  fprintf('-------running cplex with big M = 10*bigM -------\n');        
  tic
  [ obj, sol, ret_code ] = mip_cplex( A1, A2, b, big_M, time_limit );
  time_c(5,i) = toc;
  obj_c(5,i) = obj;
  ind_c{5,i} = ret_code;
  
  fprintf('## time_cplex = %f\n', toc);
  fprintf('## objval_cplex = %f\n', obj);
  fprintf('## retcode_cplex = %s\n\n\n', ret_code);
      
  if ~exist('../results', 'dir')
    mkdir('../results');
  end
  
  save('../results/sensitivity_small.mat', 'time_q', 'node_q', 'obj_q', 'ind_q', 'time_c', 'obj_c', 'ind_c');

  diary off
end
