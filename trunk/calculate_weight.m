function [Weighty WeightyP] = calculate_weight(pos,neg)

len_pos = length(pos) ;
len_neg = length(neg) ;
len = len_pos + len_neg ;

pos_sq = pos.^2 ;
neg_sq = neg.^2 ;
##### With the probability
 
if(sum(pos)!=0)
weight_pos = sort(pos./sum(pos) , 'descend');
else 
weight_pos = 0 ;
endif
if(sum(pos_sq)!=0)
weight_pos_sq = sort(pos_sq./sum(pos_sq) , 'descend');
else 
weight_pos_sq = 0 ;
endif
if(sum(neg)!=0)
weight_neg = sort(neg./sum(neg) );
else
weight_neg = 0 ;
endif 
if(sum(neg_sq)!=0)
weight_neg_sq = sort(neg_sq./sum(neg_sq))  ;
else
weight_neg_sq = 0 ;
endif

Weight_pos = sum(weight_pos .* pos );
Weight_pos_sq = sum(weight_pos_sq .* pos) ;
Weight_neg = sum(weight_neg .* neg ); 
Weight_neg_sq = sum(weight_neg_sq .* neg) ;

if(len!=0)
Weighty = ((len_pos * Weight_pos) + (len_neg * Weight_neg)) / len ;
WeightyP = ((len_pos * Weight_pos_sq) + (len_neg * Weight_neg_sq)) / len ;
endif
