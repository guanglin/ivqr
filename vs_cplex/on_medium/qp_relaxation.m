function [ fval , x, ret ] = qp_relaxation( A1, A2, b, big_M, time_limit )

%% ----------------
%% Set user options
%% ----------------
my_tol = 1.0e-6; % Fathoming and branching tolerance

b1 = b;

%% -------------------------------
%% Ensure Matlab uses only one CPU
%% -------------------------------
%% maxNumCompThreads(1);

%% ----------------------------------
%% Setup constants that do not change
%% ----------------------------------
m  = size(A1, 1);
n1 = size(A1, 2);
n2 = size(A2, 2);

H = [ zeros(n1, 4*m + n1 + n2);...
      zeros(n2, n1) 2*eye(n2) zeros(n2, 4*m);...   
      zeros(4*m, 4*m + n1 + n2) ];    
f = zeros(1 , 4*m + n1 + n2);
A = [ A1           A2           eye(m)        -eye(m)    zeros(m)  zeros(m);...
      zeros(m,n1)  zeros(m,n2)  zeros(m)      zeros(m)   eye(m)    eye(m) ;...
      zeros(n2,m)  zeros(n2,m)  zeros(n2,n1)  zeros(n2)  A2'       zeros(n2,m) ];
b = [ b; 2*ones(m,1); A2'*ones(m,1) ];

ub = big_M;
L =  [ -Inf(n1+n2,1);  zeros(2*m,1);     zeros(2*m,1) ];
Uc = [  Inf(n1+n2,1);  ub*ones(2*m,1);   2*ones(2*m,1)  ];



%% ---------------------------------------------------------------------------------
%% Setup index positions for pinpointing the corresponding invervals of the variable
%% ---------------------------------------------------------------------------------
    x1_L  =           1;  x1_U  =         n1;
    x2_L  =    x1_U + 1;  x2_U  = x1_U  + n2;
    x3p_L =    x2_U + 1;  x3p_U =  x2_U +  m;
    x3m_L =   x3p_U + 1;  x3m_U = x3p_U +  m;
    sp_L  =   x3m_U + 1;  sp_U  = x3m_U +  m;
    sm_L  =    sp_U + 1;  sm_U  =  sp_U +  m;

%% ----------------------------------
%% Setup constant for timing the code
%% ----------------------------------

tic;
ret = 'solved';
%% --------------------------------------
%% Initialize Branch and Bound structures
%% --------------------------------------
LBLB = -Inf;
LBLB1 = [];

% Initialize starting point for the root node

FxpFxp {1} = [];
FxmFxm {1} = [];
FspFsp {1} = [];
FsmFsm {1} = [];

RowRow {1} = [];
ColCol {1} = [];



FxpFxp1 {1} = [];
FxmFxm1 {1} = [];
FspFsp1 {1} = [];
FsmFsm1 {1} = [];

RowRow1 {1} = [];
ColCol1 {1} = [];
 
%% -------------------
%% Setup CPLEX options
%% -------------------

cpx = Cplex();
cpx.Model.sense = 'minimize';
cpx.Model.lb = L;
cpx.Model.A  = A;
cpx.Model.lhs = b;
cpx.Model.rhs = b;
cpx.Model.obj = f;
cpx.Model.Q = H;
% cpx.Param.timelimit.Cur = iter_timelmt;

cpx.Param.qpmethod.Cur = 2;
cpx.Param.feasopt.tolerance.Cur = 0.1; 
cpx.DisplayFunc = [];

MasterModel = cpx.Model;
%% ------------------------------------------------------------------
%% Calculate first global upper bound and associated fathoming target
%% ------------------------------------------------------------------


% Calculate a x1 and fix it in the primal and dual problems
x1 = lsqlin(A1,b1);

% Solve the primal problem
f_primal = [zeros(1, n1) ones(m,1)' ones(m,1)'];
Aeq_primal = [A2 eye(m) -eye(m)];
beq_primal = b1 - A1*x1;
lb_primal = [-Inf(n2,1); zeros(2*m,1)];
ub_primal = Inf(2*m+n2,1);
x_primal = cplexlp(f_primal, [], [], Aeq_primal, beq_primal, lb_primal, ub_primal);

% Solve the dual problem
f_dual = [(b1 - A1*x1)' zeros(1, m)];
Aeq_dual = [A2' zeros(n2, m); eye(m, m) eye(m, m)];
beq_dual = [A2'*ones(m,1); 2*ones(m, 1)];
lb_dual = zeros(2*m, 1);
ub_dual = 2*ones(2*m, 1);
x_dual = cplexlp(f_dual, [], [], Aeq_dual, beq_dual, lb_dual, ub_dual);

%get a temporary x2 to calculate a globalUB
x2_temp = x_primal(1:n2, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize x3+, s+, x3-, and s-
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


globalx = [x1; x_primal; x_dual];
globalUB = norm(x2_temp)*norm(x2_temp);%+ 1.1*my_tol;

num_gub_upd = 1;


% New experiment end

if isinf(globalUB)
  LB_target = Inf;
else
  LB_target = globalUB - my_tol * max(1, abs(globalUB));
end


%% ----------------------
%% Begin Branch-and-Bound
%% ----------------------
nodes_created         = 1;
nodes_solved          = 0;
nodes_solved_fully    = 0;
nodes_solved_fathomed = 0;
nodes_infeasible      = 0; 
nodes_pruned          = 0;


%% ---------------------------------------
%% While there are still nodes in the tree
%% ---------------------------------------

iter = 0;

while ~(isempty(LBLB)&&isempty(LBLB1))
    %% ------------
    %% Print status
    %% ------------
    
    iter = iter + 1;

   if mod(iter,5000) == -1
      fprintf('\n');
      fprintf('STATUS 1: (gUB, gLB, gap) = (%.8e, %.8e, %.3f) \n', ...
          globalUB, min(LBLB), 100 * (globalUB - min(LBLB)) / max([1, abs(globalUB)]));
      fprintf('STATUS 2: (created, solved, pruned, infeas, left) = (%d, %d, %d, %d, %d) \n', ...
          nodes_created, nodes_solved, nodes_pruned, nodes_infeasible, length(LBLB));
      fprintf('STATUS 3: solved = fully + fathomed : %d = %d + %d \n', ...
          nodes_solved, nodes_solved_fully, nodes_solved_fathomed);
      fprintf('STATUS 4: # of gub updated = %d \n', num_gub_upd);
      fprintf('STATUS 5: time = %f\n', toc);
    end
    
    
    %% -----------------------------------------------
    %% Sort nodes for 'bi-priority' node-selection rule
    %% -----------------------------------------------
    
    %% ---------------------------------------------------
    %% If the higher priority list LBLB is not empty, we retrieve
    %% the end node problem from this list; otherwise, LBLB is
    %% empty, we retrieve the node problem from the list of lower priority
    %% by using 'best-bound' node selection rule
    %% ---------------------------------------------------
    
    if ~isempty(LBLB)
        LB = LBLB(end);
        
        Fxp = FxpFxp(end); Fxp = Fxp {1};
        Fxm = FxmFxm(end); Fxm = Fxm {1};
        Fsp = FspFsp(end); Fsp = Fsp {1};
        Fsm = FsmFsm(end); Fsm = Fsm {1};
            
        Row = RowRow(end); Row = Row {1};
        Col = ColCol(end); Col = Col {1};
        
        
    else
        [ LBLB1, I ] = sort(LBLB1, 2, 'descend');
        LB = LBLB1(end);

        FxpFxp1 = FxpFxp1(I);
        FxmFxm1 = FxmFxm1(I);
        FspFsp1 = FspFsp1(I);
        FsmFsm1 = FsmFsm1(I);
        
        RowRow1 = RowRow1(I);
        ColCol1 = ColCol1(I);
        
        
        Fxp = FxpFxp1(end); Fxp = Fxp {1};
        Fxm = FxmFxm1(end); Fxm = Fxm {1};
        Fsp = FspFsp1(end); Fsp = Fsp {1};
        Fsm = FsmFsm1(end); Fsm = Fsm {1};
        
            
        Row = RowRow1(end); Row = Row {1};
        Col = ColCol1(end); Col = Col {1};
    end
     
   
    
    %% ---------------------------------
    %% Delete that problem from the tree
    %% ---------------------------------
    if ~isempty(LBLB)
        LBLB = LBLB(1:end-1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        FxpFxp = FxpFxp(1:end-1);
        FxmFxm = FxmFxm(1:end-1);
        FspFsp = FspFsp(1:end-1);
        FsmFsm = FsmFsm(1:end-1);
        
        RowRow = RowRow(1:end-1);
        ColCol = ColCol(1:end-1);
    else
        LBLB1 = LBLB1(1:end-1);
        
        FxpFxp1 = FxpFxp1(1:end-1);
        FxmFxm1 = FxmFxm1(1:end-1);
        FspFsp1 = FspFsp1(1:end-1);
        FsmFsm1 = FsmFsm1(1:end-1);
        
        RowRow1 = RowRow1(1:end-1);
        ColCol1 = ColCol1(1:end-1);
    end
    
    

    
    %% ------------------
    %% Begin to handle single node
    %% ------------------
    
    %% ----------------------------
    %% Prepare problem to be solved 
    %% ----------------------------
    U              = Uc;
    U(Fxp + x2_U)  =  0;
    U(Fxm + x3p_U) =  0; 
    U(Fsp + x3m_U) =  0;
    U(Fsm + sp_U)  =  0;

    MasterModel.ub = U;
    cpx.Model = MasterModel;

    if ~isempty(Col)
        cpx.Start.basis.rowstat = Row;
        cpx.Start.basis.colstat = Col;
    end
    
    cpx.solve;
    
    solution = cpx.Solution;
    exitflag = solution.status;
    msg = solution.statusstring;
 
    
    if exitflag == 1 || exitflag == 5      
    %% ------------
    %% Post-process
    %% ------------
    
    tempx = solution.x;
    tempval = solution.objval;
    
    if tempval > LB
        LB = tempval;
    end
    
    
    %% ------------------------------------
    %% Calculate complementarity violations
    %% ------------------------------------
    pvio = tempx(x3p_L:x3p_U) .* tempx(sp_L:sp_U);
    mvio = tempx(x3m_L:x3m_U) .* tempx(sm_L:sm_U);
    
    vio = max([ pvio; mvio ]);
    
    %% --------------------
    %% Branch (if necessary)
    %% --------------------
    if vio > my_tol
        %% Determine branch type
        if max(pvio) == vio 
            [tmp, index] = max(pvio);
            branch_case = 'p'; % for x1+ .* s1+ = 0
        else
            [tmp, index] = max(mvio);
            branch_case = 'm'; % for x1- .* s1- = 0
        end
        
        %% -------------------------
        %% Actually do the branching
        %% -------------------------
        if branch_case == 'p'
            Fxpa = union(Fxp, index);
            Fxma = Fxm;
            Fspa = Fsp;
            Fsma = Fsm;
            
            Fxpb = Fxp;
            Fxmb = union(Fxm, index);
            Fspb = union(Fsp, index);
            Fsmb = Fsm;
        else
            Fxpa = Fxp;
            Fxma = union(Fxm, index);
            Fspa = Fsp;
            Fsma = Fsm;
            
            Fxpb = union(Fxp, index);
            Fxmb = Fxm;
            Fspb = Fsp;
            Fsmb = union(Fsm, index);
        end

        Start = cpx.Start;
        Row = Start.basis.rowstat;
        Col = Start.basis.colstat;
        
        if LB < my_tol
            LBLB = [ LBLB, LB, LB ];  
            
            
            FxpFxp{length(FxpFxp)+1} = Fxpa;
            FxmFxm{length(FxmFxm)+1} = Fxma;
            FspFsp{length(FspFsp)+1} = Fspa;
            FsmFsm{length(FsmFsm)+1} = Fsma;
        
            FxpFxp{length(FxpFxp)+1} = Fxpb;
            FxmFxm{length(FxmFxm)+1} = Fxmb;
            FspFsp{length(FspFsp)+1} = Fspb;
            FsmFsm{length(FsmFsm)+1} = Fsmb;   
            
            RowRow{length(RowRow)+1} = Row;
            RowRow{length(RowRow)+1} = Row;
            ColCol{length(ColCol)+1} = Col;
            ColCol{length(ColCol)+1} = Col;
        else
            LBLB1 = [ LBLB1, LB, LB ];
            
            FxpFxp1{length(FxpFxp1)+1} = Fxpa;
            FxmFxm1{length(FxmFxm1)+1} = Fxma;
            FspFsp1{length(FspFsp1)+1} = Fspa;
            FsmFsm1{length(FsmFsm1)+1} = Fsma;
        
            FxpFxp1{length(FxpFxp1)+1} = Fxpb;
            FxmFxm1{length(FxmFxm1)+1} = Fxmb;
            FspFsp1{length(FspFsp1)+1} = Fspb;
            FsmFsm1{length(FsmFsm1)+1} = Fsmb;
            
            RowRow1{length(RowRow1)+1} = Row;
            RowRow1{length(RowRow1)+1} = Row;
            ColCol1{length(ColCol1)+1} = Col;
            ColCol1{length(ColCol1)+1} = Col;
        end
        
        nodes_created = nodes_created + 2;
        
        nodes_solved_fully = nodes_solved_fully + 1;
        %% ----------------------
        %% End branching decision
        %% ----------------------
        
    else
        if tempval < LB_target
            globalUB = tempval;
            globalx = tempx;
            
            if isinf(globalUB)
                LB_target = Inf;
            else
                LB_target = globalUB - my_tol * max(1, abs(globalUB));
            end
            
            nodes_solved_fully = nodes_solved_fully + 1;
            num_gub_upd = num_gub_upd + 1;
        else
            nodes_solved_fathomed = nodes_solved_fathomed + 1;
        end       
    end
    nodes_solved = nodes_solved + 1;
    elseif exitflag == 3 || exitflag == 6 %|| exitflag == 6 || exitflag == 5
        
       nodes_infeasible = nodes_infeasible + 1;
       
    else
        exitflag
        msg
        error('Got unknown code');
    end
    
    %% ----------------------
    %% Prune tree by globalUB
    %% ----------------------
    tmpsz = length(LBLB);
    
    I = find(LBLB < LB_target);
    
    LBLB = LBLB(I);
    
    
    FxpFxp = FxpFxp(I);
    FxmFxm = FxmFxm(I);
    FspFsp = FspFsp(I);
    FsmFsm = FsmFsm(I);
    
    RowRow = RowRow(I);
    ColCol = ColCol(I);
    
    I1 = find(LBLB1 < LB_target);
    
    LBLB1 = LBLB1(I1);
    
    FxpFxp1 = FxpFxp1(I1);
    FxmFxm1 = FxmFxm1(I1);
    FspFsp1 = FspFsp1(I1);
    FsmFsm1 = FsmFsm1(I1);
    
    RowRow1 = RowRow1(I1);
    ColCol1 = ColCol1(I1);
    
    nodes_pruned = nodes_pruned + (tmpsz - length(LBLB));
   
%     fprintf('\n---------------------- done! -----------------------------\n');
%     fprintf('\n==========================================================\n\n');

    %% ---------------------------
    %% End handling of single node
    %% ---------------------------
    
   %% -------------------------------
   %% End loop over nodes in the tree
   %% -------------------------------
if toc >= time_limit
    ret = 'limit';
    break;
end
end

%% -----------------
%% Print final stats
%% -----------------

if strcmp(ret, 'solved')
    fprintf('\n');
    fprintf('FINAL STATUS 1: optimal value = %.8e\n', globalUB);
    fprintf('FINAL STATUS 2: (created, solved, pruned, infeas, left) = (%d, %d, %d, %d, %d)\n',...
        nodes_created, nodes_solved, nodes_pruned, nodes_infeasible, length(LBLB));
    fprintf('FINAL STATUS 3: solved = fully + fathomed : %d = %d + %d\n', ...
        nodes_solved, nodes_solved_fully, nodes_solved_fathomed);
    fprintf('FINAL STATUS 4: time = %f\n', toc);
end

%% ------
%% Return
%% ------
fval = globalUB;
x    =  globalx;

   
end

