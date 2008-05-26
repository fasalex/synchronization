function [Mean Median Weighty WeightyP] = weight(y)
const = 32768 ;
max_drift = const*30*1e-6 ;
y = sort(y);
pos = y(find( y>=0 )) ;
neg = y(find( y<0 ));

######### Compare the values of the timing
len = length(y) ;
len_pos = length(pos) ;
len_neg = length(neg) ;
Median = median(y) ;

Mean = mean(y) ;
diff = abs(y - Median);
diff2 = abs((y - Median).^2);
diff_sum2 = sum(diff2) ;
diff_sum = sum(diff) ;
if(len != 1)&&(diff_sum2 !=0) &&( diff_sum != 0) 
wei = (1 - diff ./ diff_sum) ./ (len-1);
wei2 = (1 - diff2 ./ diff_sum2) ./ (len-1);
else 
wei = 1 ;
wei2 = 1 ;
endif 

yy = wei.*y ;
uu = wei2.*y ;
%WeightyP = sum(yy) ;
Weighty = sum(uu) ;

%[Mean Median] = calculate_weight(pos,neg);

######### Reference value
######### for(h=1:len_neg)
######### neg(h) = neg(h) + (max_drift/len_neg)* h ;
######### endfor 
######### for(t=1:len_pos)
######### pos(t) = pos(t) - (max_drift/len_pos)* (t-1) ;
######### endfor 
######### [Weighty WeightyP] = calculate_weight(pos,neg);
n = length(y);
x = 1:length(y) ;
offset = y(1) ;
if(offset < 0) 
y = y - offset ;
endif 

y = sort(y);

temp1 = n*sum(y.*log(x)) - sum(y*sum(log(x))) ;
temp2 = (n*sum((log(x)).^2) - sum(log(x)).^2) ;

b = temp1 / temp2 ;
a = ( sum(y) - b*sum(log(x))) / n ;

WeightyP = (a + b.*log(n/2)) + offset ;

