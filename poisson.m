function [y] = poisson(x)
lambda = 4;
n = length(x);
for (i=1:n)
y(i) = exp(-lambda).*(lambda.^x(i))./fact(x(i)) ;
endfor
