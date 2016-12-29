clear
clc

addpath('../../instances');

load('small_IVQR.mat');

lgth = length(instances);

time_q = zeros(1,lgth);
time_c = zeros(1,lgth);

obj_q = Inf(1,lgth);
obj_c = Inf(1,lgth);

sol_q = cell(1,lgth);
sol_c = cell(1,lgth);

ind_q = cell(1,lgth);
ind_c = cell(1,lgth);

time_limit = 900;

diary('../../results/log_cplex_small.txt');

for i = 1 : lgth
  
  % Enforce matlab to run with a single computation thread. 
  maxNumCompThreads(1);
  
  diary on
  i
  fprintf('Now comparing on small_IVQR instance %d\n\n', i );

  A1       = instances{i}{1};
  A2       = instances{i}{2};
  A3       = instances{i}{3};
  b        = instances{i}{4};

  big_M = 5*max(abs(b)) + 1.0e-6;
  
  fprintf('-------running qpbb-------\n');
  tic
  [fval, x_qp, ret] = qp_relaxation( A1, A2, b, big_M, time_limit );
  
  time_q(i) = toc;
  obj_q(i) = fval;
  sol_q{i} = x_qp;
  ind_q{i} = ret;
  
  fprintf('## time_qp = %f\n', toc);
  fprintf('## objval_qp = %f\n', fval);
  fprintf('## retcode_qp = %s\n\n', ret);

    
  fprintf('-------running CPLEX-------\n');
          
  tic
  [ obj, sol, ret_code ] = mip_cplex( A1, A2, b, big_M, time_limit );
  time_c(i) = toc;
  obj_c(i) = obj;
  sol_c{i} = sol;
  ind_c{i} = ret_code;
  
  fprintf('## time_cplex = %f\n', toc);
  fprintf('## objval_cplex = %f\n', obj);
  fprintf('## retcode_cplex = %s\n\n\n', ret_code);
      
  if ~exist('../../results', 'dir')
    mkdir('../../results');
  end
  
  save('../../results/result_cplex_small.mat', 'obj_q', 'sol_q', 'ind_q', 'time_q', 'obj_c', 'sol_c', 'ind_c', 'time_c');
  
  diary off
end




