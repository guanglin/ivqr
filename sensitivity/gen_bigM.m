clear
clc

addpath('../instances');

load('small_IVQR.mat');


lgth = length(instances);


bigM = Inf(1, lgth);


time_limit = 3600;

for i = 1 : lgth
    i

  A1       = instances{i}{1};
  A2       = instances{i}{2};
  A3       = instances{i}{3};
  b        = instances{i}{4};
  c1_plus  = instances{i}{5};
  c1_minus = instances{i}{6}; 

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
  
  %tic
  [fval, x_qp, ret] = qp_relaxation( A1, A2, b, c1_plus, c1_minus, big_M, time_limit );
  
  big_M = max(abs(x_qp(x3p_L:x3m_U))) + 1.0e-6;
  
  bigM(i) = big_M;
  
  if ~exist('../instances', 'dir')
    mkdir('../instances');
  end
  
  save('../instances/small_bigM.mat', 'bigM');
  

end
