param M;
param N1;
param N2;

param A1{1..M,1..N1};
param A2{1..M,1..N2};
param b{1..1,1..M};

var x1{1..N1};
var x2{1..N2};
var x3_plus{1..M} >= 0;
var x3_minus{1..M} >= 0;
var s_plus{1..M} >=0;
var s_minus{1..M} >=0;


minimize objective: sum {i in 1..N2}  (x2[i]*x2[i]);
  
subject to C1{i in 1..M}: x3_plus[i]-x3_minus[i] + sum {j in 1..N1} A1[i,j]*x1[j] + sum {j in 1..N2} A2[i,j]*x2[j] = b[1,i]; 

subject to C2{i in 1..M}: s_plus[i] + s_minus[i] = 2;
 
subject to C3{i in 1..N2}: sum{j in 1..M} A2[j,i]*(1-s_plus[j]) = 0;

subject to C4{i in 1..M}: x3_plus[i]*s_plus[i] = 0;

subject to C5{i in 1..M}: x3_minus[i]*s_minus[i] = 0;

