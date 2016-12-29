function [] = write_ampl_data(A1, A2, b)

global fid;
% Capture the dimensions

m  = size(A1,1);
n1 = size(A1,2);
n2 = size(A2,2);


b = b';

[br,bc] = size(b);

% Open file

fid = fopen('invlp.dat','w');

fprintf(fid,('param M := '));
fprintf(fid,'%d', m);
fprintf(fid,'%s\r\n',';');

fprintf(fid,('param N1 := '));
fprintf(fid,'%d', n1);
fprintf(fid,'%s\r\n',';');

fprintf(fid,('param N2 := '));
fprintf(fid,'%d', n2);
fprintf(fid,'%s\r\n',';');

fprintf(fid,('param A1:\r\n'));

for i = 1 : n1
    fprintf(fid,' %d',i);
end
fprintf(fid,'%s\r\n',' :=');

for i = 1:m
    fprintf(fid,'%d',i);
    for j = 1:n1
        fprintf(fid,' %d', A1(i,j));
    end
    fprintf(fid,'\r\n');
end
fprintf(fid,'%s\r\n',';');

fprintf(fid,('param A2:\r\n'));
for i = 1 : n2
    fprintf(fid,' %d',i);
end
fprintf(fid,'%s\r\n',' :=');

for i = 1 : m
    fprintf(fid,'%d',i);
    for j = 1:n2
        fprintf(fid,'%12.6f', A2(i,j));
    end
     fprintf(fid,'\r\n');
end
fprintf(fid,'%s\r\n',';');


fprintf(fid,('param b:\r\n'));
for i = 1 : bc
    fprintf(fid,' %d',i);
end
fprintf(fid,'%s\r\n',' :=');

for i = 1 : br
    fprintf(fid,'%d',i);
    for j = 1:bc
        fprintf(fid,' %12.6f', b(i,j));
    end
     fprintf(fid,'\r\n');
end
fprintf(fid,'%s\r\n',';');


fclose('all');
end