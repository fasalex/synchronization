figure;
x = 1:100;
y = zeros(1,100);
y(89:99)=1 ;
for k = 1:100
plot(x,y);
axis([0 100 0 10]);
hold on;
plot(x,y+3);
hold off;
for(i=1:99)
y(i)=y(i+1);
end
N(k) = getframe;
end