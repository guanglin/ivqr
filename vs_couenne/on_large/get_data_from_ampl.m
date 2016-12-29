function [x1, x2, x3_plus, x3_minus, s_plus, s_minus, ret_code] = get_data_from_ampl(m, n1, n2)

    try 

      fid = fopen('ampl_output.txt');
      tline = fgetl(fid);
      
      if tline ~= -1 
         data = dlmread('ampl_output.txt');
         x1 = data(1, 1:n1)';
         x2 = data(2, 1:n2)';
         x3_plus = data(3,1:m)';
         x3_minus = data(4,1:m)';
         s_plus = data(5,1:m)';
         s_minus = data(6,1:m)';
         tmp = data(7, 1:1);
         
         if tmp >=0 && tmp <= 99
            ret_code = 'solved';
         elseif tmp >= 100 && tmp <= 199
            ret_code = 'solved?';
         elseif tmp >= 200 && tmp <= 299
            ret_code = 'infeasible';
         elseif tmp >= 300 && tmp <= 399
            ret_code = 'unbounded';
         elseif tmp >= 400 && tmp <= 499
            ret_code = 'limit';
         else
            ret_code = 'failure';
         end
      else
         x1 = zeros(1, n1)';
         x2 = zeros(1, n2)';
         x3_plus = zeros(1, m)';
         x3_minus = zeros(1, m)';
         s_plus = zeros(1, m)';
         s_minus = zeros(1, m)';
         ret_code = 'failure';
      end
      fclose(fid);
      
      fid = fopen('ampl_output.txt', 'w');
      fclose(fid);

    catch MYME

    warning('Got error');
      
         x1 = zeros(1, n1)';
         x2 = zeros(1, n2)';
         x3_plus = zeros(1, m)';
         x3_minus = zeros(1, m)';
         s_plus = zeros(1, m)';
         s_minus = zeros(1, m)';
         ret_code = 'failure';
    end

end

