addpath('../results');

load result_cplex_small


lgth = length(time_q);

fig = figure('Units','inches','Position',[50 50 4.0 4.0]);

%%
LB = 0.1;
UB = 1.0e3;   
tmp = [LB; UB];
time_limit = 900;

[r2, c2] = find(time_c >= time_limit & strcmp(ind_c, 'failure'));
time_c2 = time_c(c2);
time_q2 = time_q(c2);

[r3, c3] = find(time_q >= time_limit & strcmp(ind_q, 'limit'));

time_c3 = time_c(c3);
time_q3 = time_q(c3);

c = 1 : 1 : lgth;
c1 = setdiff(c, c2);
c1 = setdiff(c1, c3);
time_c1 = time_c(c1);
time_q1 = time_q(c1);

loglog(time_q1, time_c1,'*',tmp,tmp,'k', 'MarkerEdgeColor', 'b', 'MarkerSize', 8);
hold on;
loglog(time_q2, time_c2,'s',tmp,tmp,'k','MarkerEdgeColor','b', 'MarkerSize', 5);
hold on;
loglog(time_q3, time_c3,'o',tmp,tmp,'k','MarkerEdgeColor','b', 'MarkerSize', 5);
xlabel('QPBB (sec)','FontSize',12,'FontWeight','bold');
ylabel('CPLEX(sec)'   ,'FontSize',12,'FontWeight','bold');

axis equal;
xlim([LB,UB]);
ylim([LB,UB]);
        
set(fig, 'PaperPositionMode', 'auto');  % Use screen size
print(fig,'-dpsc','../figures/compare_small_cplex.ps');  
% !ps2pdf compare_small_cplex.ps
% !pdfcrop compare_small_cplex.pdf
% !mv compare_small_cplex-crop.pdf compare_small_cplex.pdf
% 
% !rm -rf compare_small_cplex.ps
    





