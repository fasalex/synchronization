x = [1 2 3 5 3 1 2 10 45] ;
summ = 0 ;
off = 0 ;
factor = 1 ;
for ( i=1:9)
summ = summ + abs(x(i));
endfor
for (i=1:9)
w(i) = (summ-factor*x(i))/(summ *(9-factor)) ;
off = off + w(i) * x(i) ;
endfor
off 
mean(x)
median(x)
