figure;
hold on;
x=1:number_of_nodes;
for(i=1:sim_time_limit)
y = reshape(barplotter(:,i,:),number_of_nodes,4);
y = y./30;
clf;
bar(y);
axis([0 number_of_nodes+1 0 20]);
tit = strcat(int2str(i), "seconds");
title(tit);
pause(0.05);
endfor

