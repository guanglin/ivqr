%%% This is for the median 
%%
%%  seed: the initialization for the seed of a random generator
%%  m: sample size 
%%  n1: number of endogeneous 
%%  n2: number of instruments
%%
%% function [ b, A1, A2, c1plus, c1minus ] = script2generateIQR ( m, n1, n2, seed )
 

function [ b, A1, A2, c1plus, c1minus ] = script2generateIQR( m, n1, n2, seed )

if ( m < n1 || n2 < n1)            %%%% some typical numbers
    printf('Not enough instruments or sample size \n Reverting to different parameters')
    m = 100;
    n1 = 5;
    n2 = 5;           
end

tau = 0.5;

alpha0 = ones(n1, 1);  


alpha = (1:1:n1)';
beta  = 2*alpha;

% We only consider the case where n1 = n2.

% Structural Equation:
%
%   b = A1*alpha(U)    where U|A2 ~ Uniform(0,1)
%   A1 = U*beta + A2
%   A2 ~ N(0,I)^2
% 
% where alpha(U) := (1-U)*alpha0 + U*alpha
%

% Note! When the instruments are nonnegative, the theory is guaranteed.

randn('state',seed);
rand('state', seed);

A2 = randn(m, n2);
A2 = A2 .* A2 ;

U = rand(m, 1);                                 
A1 = A2 + U*beta';   


% Calculate alphaU
alphaU = (1-U)*alpha0' + U*alpha';

% Calculate b
b = alphaU .* A1;
b = sum(b, 2);

c1plus = tau * ones(m,1);
c1minus = (1-tau) * ones(m,1);

end