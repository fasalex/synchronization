### Main Program to be run ###
###
clear all;
clc;
t_start = date ;
prefix = "/home/fasika/mixim/trunk/examples/AnotherOne/Output/"; # output directory
model = "./New";               # simulation command #
###################################################################################
ini = 0 ;
input_parameters ;

for(i_al=1:1)
switch(i_al)
case(1)
	algorithm = 2 ;
#case(2)
#	algorithm = 2 ;
#case(3)
#	algorithm == 3 ;
endswitch
for(i_s=1:3)
switch(i_s)
case(1)
	speed = 0 ;
case(2)
	speed = 50 ;
case(3)
	speed = 100 ;
endswitch
#for(i_i=1:3)
#switch(i_i)
#case(1)
#	rnd = A ;
	start_time = "rnd";
#case(2)
#	rnd = B ;
#	start_time = "asc";
#case(3)
#	rnd = C ;
#	start_time = "dsc";
#endswitch
##for(i_alp=1:3)
#switch(i_alp)
#case(1)
#	alpha = 2.5 ;
#case(2)
#	alpha = 2.85 ;
#case(3)
#	alpha = 3.00 ;
#endswitch
for(i_g=1:2)
switch(i_g)
case(1)
	gain = 0.75 ;
case(2)
	gain = 1 ;
#case(3)
#	gain = 1.25 ;
endswitch
for(i_nu=1:3)
switch(i_nu)
case(1)
	number_of_nodes = 20 ;
	
case(2)
	number_of_nodes = 50 ;
	
case(3)
	number_of_nodes = 100 ;
	
endswitch
run_simulation ;
ini++ ;
disp("############### Count ###########################################################");
disp(ini);
disp(filename);
#endfor
#endfor
endfor
endfor
endfor
endfor
