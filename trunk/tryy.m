clf; 
x = 1:100 ;
y =0:99;
n = length(x) ;
b = (n*sum(y.*log(x)) - sum(y)*sum(log(x)))/(n*sum(log(x).*log(x))- sum(log(x))*sum(log(x))) ;
a = (sum(y) - b*sum(log(x))) / n;
plot(y,'*');
hold on;
plot(a + b*log(x));
