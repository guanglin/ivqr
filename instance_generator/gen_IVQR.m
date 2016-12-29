function gen_IVQR(no_instance, M, N1, N2, type_instance)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The following code was used to generate 100 random instances based on
%% different features.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% to set the number of instances
INSTANCE_NUMBER = no_instance;

if type_instance == 1
    start_seed_val = 1;
elseif type_instance == 2
    start_seed_val = 1100;
else
    start_seed_val = 2000;
end

seed      =   start_seed_val;
instances = cell(1, no_instance);

for i = 1: INSTANCE_NUMBER

    % m : number of observations 
    % n1: number of endogenous variables 
    % n2: number of instuments 
    m  =  M;
    n1 =  N1;
    n2 =  N2;

    [b,A1,A2,c1plus,c1minus] = script2generateIQR(m,n1,n2,seed);
    seed = seed + 1;
    A3 = eye(m);
    elements{1} =       A1;
    elements{2} =       A2;
    elements{3} =       A3;
    elements{4} =        b;
    elements{5} =  c1plus;
    elements{6} = c1minus;
    
    instances{i} = elements;
end

% save('ivqr2.mat', 'instances');
if type_instance == 1
    savefile = '../instances/small_IVQR.mat';
    save (savefile, 'instances');
elseif type_instance == 2
    savefile = '../instances/medium_IVQR.mat';
save (savefile, 'instances');
elseif type_instance == 3
    savefile = '../instances/large_IVQR.mat';
    save (savefile, 'instances');
else
    error('Opoos! Got an error: type_instance should be 1, 2, or 3');
end


end
