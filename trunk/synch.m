clear all ;

%% ============== Defining Parameters =================== %%

n = input("Enter the number of nodes __  ") ;  % Number of Nodes 

% ================ Assigning the variables ============== %%

TRIAL = 100 ; % Number of periods to be displayed 
REFERENCE_VALUE = 5 ; 
ref = repmat(REFERENCE_VALUE, [1,TRIAL]); 
const = 32768 ;
cycles_per_slot = 29 ; 
tempr = 25 ;
gain = 1.0;
clock_drift = zeros(1,n) ;

clock_drift = (tempr - 25 )* e-6 * 0.5 / 20 ;

%% ================ Delays in the Network =============== %%

d_propagation = 0 ;
d_transmitting = 0 ;
d_decoding = 0 ;
d_refractory = 0 ;

delay = zeros(n,n) ;

for(j=1:n)
	for (i=1:n)
		delay(i,j) = d_propagation + d_transmitting + d_decoding + d_refractory ;
	end
end

%% =============== Calculating the vars ================ %% 

clock_drift =  rand(1,n)  ;  % Clock Drift in the node 

nodes_to_see = n ; % Number of nodes to be displayed on the graph 
for(h = 1:n) 
if(rand()> 0.5)
clock_frequency(h) = const + const*30*1e-6*rand();  
else
clock_frequency(h) = const - const*30*1e-6*rand();  
endif
endfor

wakeup_time = cycles_per_slot * n ; % Wake Up time of the node 

% Temporary variables 

new = zeros(1,n) ; 
temp1 = zeros(1,n) ;
temp2 = zeros(1,n) ;
temp3 = zeros(1,n) ;
temp4 = zeros(1,n) ;

fired = 1 ; % Number of times the nodes fired 

guard_time = (wakeup_time)/(n*3) ; % Guard time of the TDMA slot 

t_float = rand(1,n) * 29 ;
%t_float = ones(1,n) + 1 ;

t = int32(t_float) % Initial time of the nodes --- random number ( ) 

std_t(fired) = std(t_float) ;  % Standard deviation of time distribution

disp("The standard deviation before synchronization is :");

disp(std(t_float));

ta = zeros(n,100) ;

k = zeros(n,1);
std_t1(fired) = std(t_float) ;  % Standard deviation of time distribution
std_t2(fired) = std(t_float) ;  % Standard deviation of time distribution
std_t3(fired) = std(t_float) ;  % Standard deviation of time distribution
std_t4(fired) = std(t_float) ;  % Standard deviation of time distribution

%% ================ Program starts ===================%%
t1 = t ;
t2 = t ;
t3 = t ;
t4 = t ;
while (1) 
	if(mod(fired,1) != 0)
		temp1(:) = 0 ;
		temp2(:) = 0 ;
		temp3(:) = 0 ;
		temp4(:) = 0 ;
	endif

	for(j=1:n)
		t1(j) = t1(j) + gain*temp1(j) + clock_frequency(j) + clock_drift(j) ;
		t2(j) = t2(j) + gain*temp2(j) + clock_frequency(j) + clock_drift(j) ;	
		t3(j) = t3(j) + gain*temp3(j) + clock_frequency(j) + clock_drift(j) ;	
		t4(j) = t4(j) + gain*temp4(j) + clock_frequency(j) + clock_drift(j) ;		
	end
	for (i = 1:n ) 

		CALC1(1:n-1) = t1(i) ;
		new_time1 = t1 + int32(delay(i,:)) ;
		new_time1(i) = [] ;
		PHASE_ERROR1 = new_time1 - CALC1 ;

		CALC2(1:n-1) = t2(i) ;
		new_time2 = t2 + int32(delay(i,:)) ;
		new_time2(i) = [] ;
		PHASE_ERROR2 = new_time2 - CALC2 ;

		CALC3(1:n-1) = t3(i) ;
		new_time3 = t3 + int32(delay(i,:)) ;
		new_time3(i) = [] ;
		PHASE_ERROR3 = new_time3 - CALC3 ;

		CALC4(1:n-1) = t4(i) ;
		new_time4 = t4 + int32(delay(i,:)) ;
		new_time4(i) = [] ;
		PHASE_ERROR4 = new_time4 - CALC4 ;

% Calculation of the mean or median of the algorithm in the time domain 

		[Mean1 Median1 Weighty1 WeightyP1] = weight(PHASE_ERROR1) ;
		temp1(i) = Weighty1 ;

		[Mean2 Median2 Weighty2 WeightyP2] = weight(PHASE_ERROR2) ;
		temp2(i) = Mean2 ;

		[Mean3 Median3 Weighty3 WeightyP3] = weight(PHASE_ERROR3) ;
		temp3(i) = Median3 ;
 		PHASE_ERROR4 ;
		[Mean4 Median4 Weighty4 WeightyP4] = weight(PHASE_ERROR4) ;
		temp4(i) = WeightyP4;

	end
	
	fired = fired + 1 ;
	std_t1(fired ) = std(double(t1));
	std_t2(fired ) = std(double(t2));
	std_t3(fired ) = std(double(t3));
	std_t4(fired ) = std(double(t4));
	
	if ( fired == TRIAL)
		break;
	end 
end
clf ;
hold on ;
plot(std_t4,'b') ; # Weight 
%plot(std_t3,'p') ; # Median from m-file
plot(std_t1,'r') ; # Weight with square
#plot(std_t4,'*') ; # Weight Least square 
plot(ref,'v');
legend("Weight","Median","Weight with square ");#,"Weight factor- Least Square");
xlabel("Number of firing times ");
ylabel("Standard Deviation " ) ;
axis([1 TRIAL]);
hold off; 
disp("The standard deviation is : ");
disp(std(double(t4))); 
disp("Number of times that the nodes fired before synchronization is : ");
disp(fired);
