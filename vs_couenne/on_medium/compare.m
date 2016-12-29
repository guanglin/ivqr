clear
clc

addpath('../../instances');

load('medium_IVQR.mat');


lgth = length(instances);

time_q = zeros(1,lgth);
time_c = zeros(1,lgth);

obj_q = Inf(1,lgth);
obj_c = Inf(1,lgth);

sol_q = cell(1,lgth);
sol_c = cell(1,lgth);

ind_q = cell(1,lgth);
ind_c = cell(1,lgth);


time_limit = 1800;

diary('../../results/log_couenne_medium.txt');

for i = 1 : lgth
    
  % Enforce matlab to run with a single computation thread. 
  maxNumCompThreads(1);
  
    
  diary on
  i
  fprintf('Now comparing on medium_IVQR instance %d\n\n', i );

  A1       = instances{i}{1};
  A2       = instances{i}{2};
  A3       = instances{i}{3};
  b        = instances{i}{4};

  big_M = Inf;
  
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
    
  fprintf('-------running couenne-------\n');
      
  m  = size(A1,1);
  n1 = size(A1,2);
  n2 = size(A2,2);
  write_ampl_data(A1, A2, b);
  strAmplSystemCall = sprintf('ulimit -t 1801; ampl invlp.run');
  tic;
  system(strAmplSystemCall);
  time_c(i) = toc;
  
  [x1, x2, x3_plus, x3_minus, s_plus, s_minus, ret_code] = get_data_from_ampl(m, n1, n2);
  obj_c(i) = get_opt_val(A1, A2, b, x1, x2, x3_plus, x3_minus, s_plus, s_minus, ret_code);
  ind_c{i} = ret_code;
  sol_c{i} = [x1; x2; x3_plus; x3_minus; s_plus; s_minus];

  fprintf('## time_couenne = %f\n', toc);
  fprintf('## objval_couenne = %f\n', obj_c(i));
  fprintf('## retcode_couenne = %s\n\n\n', ret_code);
  
  if ~exist('../../results', 'dir')
    mkdir('../../results');
  end
  
  save('../../results/result_couenne_medium.mat', 'obj_q', 'sol_q', 'ind_q', 'time_q',  'obj_c', 'sol_c', 'ind_c', 'time_c');
  
  diary off
end


