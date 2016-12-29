function [ obj_c, sol_c, ret_code] = mip_cplex( A1, A2, b, big_M, time_limit  )

%% We use CPLEX cplexmiqp to sove the IVQR instance in the formulation of
%% (13) in the paper.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The formulation in the paper is as follows:                             %
%                                                                         % 
% min \|x2\|^2                                                            % 
% st. A1*x1 + A2*x2 + x3^+ - x3^- = b, x3^+ >= 0, x3^- >= 0               %
%     A2^T*s^+ = A2^T*e, s^+ + s^- = 2*e, s^+ >= 0, s^- >= 0              %
%     x3^+ <= M*z^+, s^+ <= 2*(e - z^+)                             (13)  %
%     x3^- <= M*z^-, s^- <= 2*(e - z^-)                                   %
%     z^+, z^- \in {0, 1}^m                                               %
% where (x1, x2, x3^+, x3^-, s^+, s^-, z^+, z^-) \in                      %
% \RR^{n1} * \RR^{n2} * \RR^m * \RR^m * \RR^m * \RR^m * \RR^m * \RR^m,    %
% M represents big_M for short, e is the vector of all ones, \|\| is      %
% 2-norm.                                                                 %
% The MIQP formulation required by CPLEX is                               %
%                                                                         %
% min 0.5*x'*H*x + f*x                                                    %
% st.  bl <= Ax <= bu                                                     %
%      L <= x <= U                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Retrieve the size of the instance
m  = size(A1, 1);
n1 = size(A1, 2);
n2 = size(A2, 2);


% Actually do the conversion of the formulations.
% Note that the generic x here has eight components. In fact,
% x = (x1, x2, x3^+, x3^-, s^+, s^-, z^+, z^-) 


% We need to convert the obj func \|x_2\|^2 into the form 0.5*x'*H*x+f*x. 
% Thus, H is given as 
H = [ zeros(n1,n1) zeros(n1,n2) zeros(n1, m) zeros(n1, m) zeros(n1, m) zeros(n1, m) zeros(n1, m) zeros(n1, m) ;...
      zeros(n2,n1) 2*eye(n2,n2) zeros(n2, m) zeros(n2, m) zeros(n2, m) zeros(n2, m) zeros(n2, m) zeros(n2, m) ;...   
      zeros(m, n1) zeros(m, n2) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) ;...
      zeros(m, n1) zeros(m, n2) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) ;...
      zeros(m, n1) zeros(m, n2) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) ;...
      zeros(m, n1) zeros(m, n2) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) ;...
      zeros(m, n1) zeros(m, n2) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) ;...
      zeros(m, n1) zeros(m, n2) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m) zeros(m,  m)];  
% and f is given as
f = zeros(1 , 6*m + n1 + n2);


% Prepare for the generic constraint bl <= A*x <= bu
% Thus, A is given as follows:
A = [ A1           A2           eye(m)      -eye(m)       zeros(m)  zeros(m)      zeros(m)       zeros(m);...
      zeros(m,n1)  zeros(m,n2)  zeros(m)    zeros(m)      eye(m)    eye(m)        zeros(m)       zeros(m);...
      zeros(n2,n1) zeros(n2,n2) zeros(n2,m) zeros(n2, m)  A2'       zeros(n2, m)  zeros(n2, m)   zeros(n2, m);...
      zeros(m,n1)  zeros(m,n2)  eye(m)      zeros(m)      zeros(m)  zeros(m)      -eye(m)*big_M  zeros(m);...
      zeros(m,n1)  zeros(m,n2)  zeros(m)    eye(m)        zeros(m)  zeros(m)      zeros(m)       -eye(m)*big_M;...
      zeros(m,n1)  zeros(m,n2)  zeros(m)    zeros(m)      eye(m)    zeros(m)      eye(m)*2       zeros(m);...
      zeros(m,n1)  zeros(m,n2)  zeros(m)    zeros(m)      zeros(m)  eye(m)        zeros(m)       eye(m)*2 ];
%% NOTE that: 
%  the first row is for A1*x1 + A2*x2 + x3^+ - x3^- = b;
%  the second row is for s^+ + s^- = 2*e;
%  the third row is for A2^T*s^+ = A2^T*e;
%  the fourth row is for x3^+ <= M*z^+;
%  the fifth row is for x3^- <= M*z^-;
%  the sixth row is for s^+ + 2*z^+ <= 2*e
%  the seventh row is for s^- + 2*z^- <= 2*e
%% THe order of the constraints here is slightly different from the one in
%% (13).

% The corresponding bl and bu are devised as follows
bb = [b; 2*ones(m,1); A2'*ones(m,1)]; % bb is corresponding to the equations
bl = [bb; -Inf(4*m,1)];
bu = [bb; zeros(2*m,1); 2*ones(2*m,1)]; 
%% NOte add -Inf(4*m,1)AND [zeros(2*m,1); 2*ones(2*m,1)] for the 4 inequalities

% Prepare for L <= x <= U
L = [ -Inf(n1+n2,1); zeros(2*m,1);       zeros(2*m,1); zeros(2*m,1) ];
U = [ Inf(n1+n2, 1); big_M*ones(2*m, 1); 2*ones(2*m,1);  ones(2*m,1)  ];
%% NOte that we also directly bound s^{+,-} through U. In fact, the third
% term of U is used to force s^+ <= 2*e and s^- <= 2*e

% Let the solver know which are continuous variables and which are binary
% variables. 
str = '';

% Enforce x1, x2, x3^+, x3^-. s^+, and s^- to be continous
for i = 1 : 4*m + n1 + n2
    str = strcat(str,'C');
end

% Enforce z^+ and z^- to be binary
for i = 1 : 2*m
    str = strcat(str,'B');
end
    
%% Setup the parameters of the solver
options = cplexoptimset;
options.Diagnostics = 'on';
options.Display = 'off'; 

cpx = Cplex();
cpx.Model.sense = 'minimize';
cpx.Model.lb = L;
cpx.Model.ub = U;
cpx.Model.A  = A;
cpx.Model.lhs = bl;
cpx.Model.rhs = bu;
cpx.Model.obj = f;
cpx.Model.Q = H;
cpx.Model.ctype = str;
cpx.Param.timelimit.Cur = time_limit;
cpx.DisplayFunc = [];

% Solve the instance
try 
    cpx.solve();
    solution = cpx.Solution;
    exitflag = solution.status;

    tempx = solution.x;
    tempval = solution.objval;
    
catch MYME
    warning('Got error');
    tempx = [];
    tempval = Inf;
    exitflag = -1;
end

% Store the obj val, opt sol, and the returning code
obj_c = tempval;
sol_c = tempx;
flag = exitflag;

%% Postprocess the returning code. Basically simplify
%  the returning code.
%% For the meaning of the code, the reader is referred to
% https://www.tu-chemnitz.de/mathematik/discrete/manuals/cplex/doc/refman/html/appendixB.html
if flag == 101 || flag == 102
    ret_code = 'solved';
elseif flag == 103
    ret_code = 'infeasible';
elseif flag == 118
    ret_code = 'unbounded';
elseif flag == 107 || flag == 108
    ret_code = 'limit';
elseif flag == 119
    ret_code = 'infeasible or unbounded';
else
    if flag == -1 && toc >= time_limit
        ret_code = 'limit';
    else
        ret_code = 'failure';
    end  
end
   
end

