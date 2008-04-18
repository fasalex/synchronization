clear all ;

%% ============== Defining Parameters =================== %%

n = input("Enter the number of nodes __  ") ;  % Number of Nodes 

% ================ Assigning the variables ============== %%

TRIAL = 10 ; % Number of periods to be displayed 
REFERENCE_VALUE = 9 ; 
ref = repmat(REFERENCE_VALUE, [1,TRIAL]); 
clock_frequency = 32768 ; 
cycles_per_slot = 29 ; 
temp = 25 ;

clock_drift = zeros(1,n) ;

clock_drift = (temp - 25 )* e-6 * 0.5 / 20 ;

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

const = clock_frequency - n * cycles_per_slot; % Number of cycles per period 

clock_drift =  rand(1,n)  ;  % Clock Drift in the node 

nodes_to_see = n ; % Number of nodes to be displayed on the graph 

wakeup_time = cycles_per_slot * n ; % Wake Up time of the node 

% Temporary variables 

new = zeros(1,n) ; 
temp = zeros(1,n) ;

fired = 1 ; % Number of times the nodes fired 

guard_time = (wakeup_time)/(n*3) ; % Guard time of the TDMA slot 

t_float = rand(1,n) * 29 * n ;

t = int32(t_float); % Initial time of the nodes --- random number ( ) 

std_t(fired) = std(t_float) ;  % Standard deviation of time distribution

disp("The standard deviation before synchronization is :");

disp(std(t_float));

ta = zeros(n,100) ;

k = zeros(n,1);

%% ================ Program starts ===================%%

while (1) 
	
	for(j=1:n)
		t(j) = t(j) + temp(j) + const + clock_drift(j) ;	
		ta (j, t(j) + 30 : t(j) + wakeup_time + 30 -1 ) = 1 ;
	end
	for (i = 1:n ) 
		CALC(1:n-1) = t(i) ;
		new_time = t + int32(delay(i,:)) ;
		new_time(i) = [] ;
		PHASE_ERROR = new_time - CALC ;
		temp(i) = calculate(PHASE_ERROR, guard_time );
	end
	temp ;
	
	fired = fired + 1 ;
	std_t(fired ) = std(double(t) );
	
	if ( fired > TRIAL)
		break;
	end 
end
figure(1);
clf;
hold on ;

% ================ Plot the output of the synchronization ============== %%

for(j=1:nodes_to_see)
	m = 1 : length(ta(j,:));
	plot(m / const ,ta(j,:)+j*1.5);
end
g = length(ta(j,:)) ;
axis([1 TRIAL 0 1.75*n]) ;
grid on ;
xlabel("Cycles");
ylabel("Nodes");

%% ==== Plot the stadard deviation with respect to the firing times ==== %% 

hold off;
figure(2);
clf;
hold on ;
plot(std_t) ;
plot(ref,'*');
xlabel("Number of firing times ");
ylabel("Standard Deviation " ) ;
hold off; 
disp("The standard deviation is : ");
disp(std(double(t)));
