function [ obj ] = get_opt_val(A1, A2, b, x1, x2, x3_plus, x3_minus, s_plus, s_minus, ret_code )

   cons1 = x3_plus - x3_minus + A1*x1 + A2*x2 - b;  
   m = size(s_plus,1);
   cons2 = A2'*(ones(m,1) - s_plus);
   cons3 = x3_plus .* s_plus;
   cons4 = x3_minus .* s_minus;
   cons5 = x3_plus .* x3_minus;
   
   max1 = max(abs(cons1));
   max2 = max(abs(cons2));
   max3 = max(abs(cons3));
   max4 = max(abs(cons4));
   max5 = max(abs(cons5));
   
   
if  strcmp(ret_code, 'solved') || strcmp(ret_code, 'solved?')
    obj = x2'*x2;
elseif strcmp(ret_code, 'limit')
    if max1 >= 1e-5 || max2 >= 1e-5 || max3 >= 1e-5 || max4 >= 1e-5 || max5 >= 1e-5 || max6 >= 1e-5 || max7 >= 1e-5
        obj = Inf;
    else
        obj = x2'*x2;
    end
elseif strcmp(ret_code, 'failure')
    obj = Inf;
elseif strcmp(ret_code, 'infeasible')
    obj = Inf;
elseif strcmp(ret_code, 'unbounded')
    obj = -Inf; 
end

end

