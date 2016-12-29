addpath('../results');

load result_couenne_small


lgth = length(time_q);

fig = figure('Units','inches','Position',[50 50 4.0 4.0]);

%%
LB = 0.1;
UB = 1.0e3;   
tmp = [LB; UB];
time_limit = 900;


loglog(time_q, time_c,'*',tmp,tmp,'k', 'MarkerEdgeColor', 'b', 'MarkerSize', 8);

xlabel('QPBB (sec)','FontSize',12,'FontWeight','bold');
ylabel('Couenne(sec)'   ,'FontSize',12,'FontWeight','bold');

axis equal;
xlim([LB,UB]);
ylim([LB,UB]);
        
set(fig, 'PaperPositionMode', 'auto');  % Use screen size
print(fig,'-dpsc','../figures/compare_small_couenne.ps');  
% !ps2pdf compare_small_couenne.ps
% !pdfcrop compare_small_couenne.pdf
% !mv compare_small_couenne-crop.pdf compare_small_couenne.pdf
% 
% !rm -rf compare_small_cplex.ps
    





