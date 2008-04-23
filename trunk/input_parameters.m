###########################################################################################
#######          INPUT PARAMETERS FOR THE SIMULATION                         ##############
###########################################################################################
run = 2 ;                           ## 1 - commandline  2 - gui 
number_of_nodes = 16;              ## Number of Nodes - as the name describes it 
jump = 1 ;                           ## jump to reduce the calculation burden 
limit = 100 ;                       ## Number of periods to run the simulation - One period One second 
cpu_time_limit = limit * 32768 * 0.1 / 100 ;  ## Number of events needed for "limit" 
speed = 10 ;                         ##  In Kilometer per hour 
updateInterval = 1000 ;             ## In simulation seconds or a cycle(1/32768)
algorithm = 2 ;                     ## "mean" - 1 , "median" -2 , "weight" - 3 ;
gain = 0.75 ;                       ## Value for computing the offsets 
express = "yes" ;                   ## Enable or Disable express mode 
A =[23.2804    2.3220   10.7283   24.0327   13.6993   18.2868   21.4755   16.3737   26.9815   11.9945   21.1377   16.5874   18.9527   20.1814   16.1061 18.7219 ];  
B = sort(A) ;                       ## A set of Inputs for ascending order
C = B(end:-1:1) ;                   ## A set of Inputs for desceding order
rnd = A ;
alpha = 2.50 ;                      ## Channel factor - attenuation if you might say ...


