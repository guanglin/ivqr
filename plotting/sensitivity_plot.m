addpath('../results');

load sensitivity_small

% the number of instances where QPBB performs better than CPLEX
% when bigM is the tightest (bigM = max(|x3+|, |x3-|))
N1 = numel(find(time_q(2,:) - time_c(2,:) < 0));

% the number of instances where QPBB performs better than CPLEX
% when bigM is 2*max(|x3+|, |x3-|)
N2 = numel(find(time_q(3,:) - time_c(3,:) < 0));

% the number of instances where QPBB performs better than CPLEX
% when bigM is 5*max(|x3+|, |x3-|)
N3 = numel(find(time_q(4,:) - time_c(4,:) < 0));

% the number of instances where QPBB performs better than CPLEX
% when bigM is the 10*max(|x3+|, |x3-|)
N4 = numel(find(time_q(5,:) - time_c(5,:) < 0));

fig = figure('Units','inches','Position',[50 50 4.0 4.0]);

%%

UB = 1.0e3;
LB = 0.1;

tmp = [LB;UB];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loglog(time_q(2,:), time_c(2,:),'*',tmp,tmp,'k', 'MarkerEdgeColor', 'b', 'MarkerSize', 8);

xlabel('QPBB (sec)','FontSize',12,'FontWeight','bold');
ylabel('CPLEX (sec)'   ,'FontSize',12,'FontWeight','bold');

axis equal
xlim([0,UB])
ylim([0,UB])

% title({'QBBB Time vs CPLEX Time';''},'FontSize',16,'FontWeight','bold');

%%

set(fig, 'PaperPositionMode', 'auto')   % Use screen size
print(fig,'-dpsc','../figures/bigM.ps')
% !ps2pdf bigM.ps
% !pdfcrop bigM.pdf
% !mv bigM-crop.pdf bigM.pdf
% !rm -rf bigM.ps

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loglog(time_q(3,:), time_c(3,:),'*',tmp,tmp,'k', 'MarkerEdgeColor', 'b', 'MarkerSize', 8);

xlabel('QPBB (sec)','FontSize',12,'FontWeight','bold');
ylabel('CPLEX (sec)'   ,'FontSize',12,'FontWeight','bold');

axis equal
xlim([0,UB])
ylim([0,UB])

% title({'QBBB Time vs CPLEX Time';''},'FontSize',16,'FontWeight','bold');

%%

set(fig, 'PaperPositionMode', 'auto')   % Use screen size
print(fig,'-dpsc','../figures/2bigM.ps')
% !ps2pdf 2bigM.ps
% !pdfcrop 2bigM.pdf
% !mv 2bigM-crop.pdf 2bigM.pdf
% !rm -rf 2bigM.ps

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loglog(time_q(4,:), time_c(4,:),'*',tmp,tmp,'k', 'MarkerEdgeColor', 'b', 'MarkerSize', 8);

xlabel('QPBB (sec)','FontSize',12,'FontWeight','bold');
ylabel('CPLEX (sec)'   ,'FontSize',12,'FontWeight','bold');

axis equal
xlim([0,UB])
ylim([0,UB])

% title({'QBBB Time vs CPLEX Time';''},'FontSize',16,'FontWeight','bold');

%%

set(fig, 'PaperPositionMode', 'auto')   % Use screen size
print(fig,'-dpsc','../figures/5bigM.ps')
% !ps2pdf 5bigM.ps
% !pdfcrop 5bigM.pdf
% !mv 5bigM-crop.pdf 5bigM.pdf
% !rm -rf 5bigM.ps

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loglog(time_q(5,:), time_c(5,:),'*',tmp,tmp,'k', 'MarkerEdgeColor', 'b', 'MarkerSize', 8);

xlabel('QPBB (sec)','FontSize',12,'FontWeight','bold');
ylabel('CPLEX (sec)'   ,'FontSize',12,'FontWeight','bold');

axis equal
xlim([0,UB])
ylim([0,UB])

% title({'QBBB Time vs CPLEX Time';''},'FontSize',16,'FontWeight','bold');

%%

set(fig, 'PaperPositionMode', 'auto')   % Use screen size
print(fig,'-dpsc','../figures/10bigM.ps')
% !ps2pdf 10bigM.ps
% !pdfcrop 10bigM.pdf
% !mv 10bigM-crop.pdf 10bigM.pdf
% !rm -rf 10bigM.ps

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig = figure('Units','inches','Position',[50 50 4.0 4.0]);
% boxplot([time_q(2,:)',time_q(3,:)',time_q(4,:)',time_q(5,:)',time_q(1,:)'],'labels',{'M','2M', '5M', '10M', 'Inf'})
boxplot([node_q(2,:)', node_q(3,:)', node_q(4,:)', node_q(5,:)', node_q(1,:)'],'labels',{'M','2M', '5M', '10M', 'Inf'})
% Xlabel('')

ylabel('QPBB (# nodes solved)')
% ylim([0,9000])
% ylabel('QPBB (sec)')
ylim([0,4000])

set(fig, 'PaperPositionMode', 'auto')   % Use screen size
print(fig,'-dpsc','../figures/box.ps')
% !ps2pdf box.ps
% !pdfcrop box.pdf
% !mv box-crop.pdf box.pdf
% !rm -rf box.ps



