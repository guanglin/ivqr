%%%%% Authors: Guanglin Xu and Samuel Burer
%%%%% Date: 2015-05-06
%%%%% Description: This file is to run the test for the paper of "A Branch-
%%%%% and-Bound Algorithm for Instrumental Variable Quantile Regression"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% We generate three types of instances: small_IVQR,
%%%%% medium_IVQR, and large_IVQR instances stored in small_IVQR.mat,
%%%%% medium_IVQR.mat, and large_IVQR.mat. For the user's convenience,
%%%%% we also provide these instances under the folder of
%%%%% ../codes_submitted/instances. The generator function is

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     gen_IVQR(no_instance, M, N1, N2, type_instance).  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% no_instance: nubmer of instances generated
%%%%% M: the number of observations
%%%%% N1: the number of endogenous variables
%%%%% N2: the number of instuments

%%%%% Parameters for small_IVQR
%%%%% no_instance = 500
%%%%% M = 50
%%%%% N1 = 5
%%%%% N2 = 5
%%%%% type_instance = 1 indicating small-size instances

clear
clc
no_instance =500;
M = 50;
N1 = 5;
N2 = 5;
type_instance = 1;
gen_IVQR(no_instance, M, N1, N2, type_instance);

% %%%%% Parameters for medium_IVQR
% %%%%% no_instance = 300
% %%%%% M = 100
% %%%%% N1 = 5
% %%%%% N2 = 5
% %%%%% type_instance = 2 indicating medium-size instances
clear
clc
no_instance = 300;
M = 100;
N1 = 5;
N2 = 5;
type_instance = 2;
gen_IVQR(no_instance, M, N1, N2, type_instance);

% %%%%% Parameters for large_IVQR
% %%%%% no_instance = 100
% %%%%% M = 150
% %%%%% N1 = 5
% %%%%% N2 = 5
% %%%%% type_instance = 3 indicating large-size instances
clear
clc
no_instance = 100;
M = 150;
N1 = 5;
N2 = 5;
type_instance = 3;
gen_IVQR(no_instance, M, N1, N2, type_instance);

