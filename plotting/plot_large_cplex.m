addpath('../results');

load result_cplex_large


lgth = length(time_q);

fig = figure('Units','inches','Position',[50 50 4.0 4.0]);

%%
LB = 1;
UB = 1.0e4;   
tmp = [LB; UB];
time_limit = 7200;

[r2, c2] = find(time_c >= time_limit & strcmp(ind_c, 'failure'));
time_c2 = time_c(c2);
time_q2 = time_q(c2);

[r3, c3] = find(time_c < time_limit & strcmp(ind_c, 'failure'));

time_c3 = time_c(c3);
time_q3 = time_q(c3);

c = 1 : 1 : lgth;
c1 = setdiff(c, c2);
c1 = setdiff(c1, c3);
time_c1 = time_c(c1);
time_q1 = time_q(c1);

loglog(time_q1, time_c1,'*',tmp,tmp,'k', 'MarkerEdgeColor', 'b', 'MarkerSize', 8);
hold on;
loglog(time_q2, time_c2,'s',tmp,tmp,'k','MarkerEdgeColor','b', 'MarkerSize', 8);
hold on;
loglog(time_q3, time_c3,'o',tmp,tmp,'k','MarkerEdgeColor','b', 'MarkerSize', 7);
xlabel('QPBB (sec)','FontSize',12,'FontWeight','bold');
ylabel('CPLEX(sec)'   ,'FontSize',12,'FontWeight','bold');

axis equal;
xlim([0,UB]);
ylim([0,UB]);
        
set(fig, 'PaperPositionMode', 'auto');  % Use screen size
print(fig,'-dpsc','../figures/compare_large_cplex.ps');  
% !ps2pdf compare_large_cplex.ps
% !pdfcrop compare_large_cplex.pdf
% !mv compare_large_cplex-crop.pdf compare_large_cplex.pdf
% % 
% % !rm -rf compare_small_cplex.ps


    





