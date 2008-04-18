function [Mean Median Weighty WeightyP] = weight(y)
const = 32768 ;
max_drift = const*30*1e-6 ;
y = sort(y);
pos = y(find( y>=0 )) ;
neg = y(find( y<0 ));

######### Compare the values of the timing

Median = median(y) ;
Mean = mean(y) ;

len = length(y) ;
len_pos = length(pos) ;
len_neg = length(neg) ;
%[Mean Median] = calculate_weight(pos,neg);

######### Reference value
 
for(h=1:len_neg)
neg(h) = neg(h) + (max_drift/len_neg)* h ;
endfor 
for(t=1:len_pos)
pos(t) = pos(t) - (max_drift/len_pos)* (t-1) ;
endfor 
[Weighty WeightyP] = calculate_weight(pos,neg);

