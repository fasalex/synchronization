###########################################################################################
#######          INPUT PARAMETERS FOR THE SIMULATION                         ##############
###########################################################################################

number_of_nodes = 100;              ## Number of Nodes - as the name describes it 
limit = 500 ;                       ## Number of periods to run the simulation - One period One second 
cpu_time_limit = limit * 32768 * 0.1 / 80000 ;  ## Number of events needed for "limit" 
speed = 10 ;                         ##  In Kilometer per hour 
updateInterval = 1000 ;             ## In simulation seconds or a cycle(1/32000)
algorithm = 3 ;                     ## "mean" - 1 , "median" -2 , "weight" - 3 ;
gain = 1 ;                       ## Value for computing the offsets 
express = "yes" ;                   ## Enable or Disable express mode 
con = 29 / number_of_nodes ;
A = rand(1,number_of_nodes)*60 ;   ## Start time of the nodes - random 
B = sort(A) ;                       ## A set of Inputs for ascending order
C = B(end:-1:1) ;                   ## A set of Inputs for desceding order
rnd = A ;
alpha = 2.50 ;                      ## Channel factor - attenuation if you might say ...
