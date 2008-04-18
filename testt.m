##
clear all;
clc;
prefix = "/home/fasika/mixim/trunk/examples/AnotherOne/Output/"; # output directory
model = "./New";               # simulation command
##
## get user input to construct omnetpp configration file
ini = 0 ;
input_parameters ;
##
## create ini file
##
for(i_al=1:2)
	switch(i_al)
	case(1)
	algorithm = 1 ;
	case(2)
	algorithm = 2 ;
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
for(i_nu=1:3)
	switch(i_nu)
	case(1)
	number_of_nodes = 20 ;	
	case(2)
	number_of_nodes = 50 ;	
	case(3)
	number_of_nodes = 100 ;	
	endswitch
system("make") ;
system("rm *.vec") ;
system("rm *.sca") ;
vectorname_m = "omnetpp.vec";
scalarname = "omnetpp.sca";
ininame = "omnetpp.ini";

if(algorithm == 1)
	algor = "mean-";
	folder = "Mean/";
elseif(algorithm == 2) 
	algor = "median-";
	folder = "Median/";
endif
start_time = 'asc';
spe = int2str(speed);
gai = int2str(gain*10);
no = int2str(number_of_nodes);
alp = int2str(alpha*100);
ext = '.eps';
prefixx = strcat(prefix,folder);
filename = strcat(prefixx,algor,'s',spe,'-g',gai,'-n',no,'-alpha',alp,'-',start_time,ext);

playgroundSizeX = (sqrt(number_of_nodes) + 2) * 150  ; ## meters 
playgroundSizeY = (sqrt(number_of_nodes) + 2) * 150  ; ## meters 

fidout = fopen(ininame, "w", "native");
fprintf(fidout, "[General]\n");
fprintf(fidout, "preload-ned-files = *.ned @nedincludes.lst\n");
fprintf(fidout, "network = mobileNet\n");
fprintf(fidout, "cpu-time-limit = %d\n\n", cpu_time_limit);

fprintf(fidout, "[Cmdenv]\n");
fprintf(fidout, "express-mode = %s\n", express);

fprintf(fidout, "[Parameters]\n");
fprintf(fidout, "##########################################################\n");
fprintf(fidout, "#			Simulation parameters                        #\n");
fprintf(fidout, "##########################################################\n");
fprintf(fidout, "mobileNet.**.coreDebug = 0\n");
fprintf(fidout, "mobileNet.playgroundSizeX = %d\n", playgroundSizeX);
fprintf(fidout, "mobileNet.playgroundSizeY = %d\n", playgroundSizeY);
fprintf(fidout, "mobileNet.playgroundSizeZ = 0\n");
fprintf(fidout, "mobileNet.numHosts = %d \n", number_of_nodes);
fprintf(fidout, "mobileNet.Node[*].normalNic.limit = %d \n" , limit) ;
fprintf(fidout, "mobileNet.Node[*].normalNic.algorithm = %d \n" , algorithm) ;
fprintf(fidout, "mobileNet.Node[*].normalNic.gain = %f \n" , gain) ;
fprintf(fidout, "mobileNet.Node[*].normalNic.hosts = %d \n\n", number_of_nodes);

fprintf(fidout, "##########################################################\n");
fprintf(fidout, "#			World Utility Parameters                        #\n");
fprintf(fidout, "##########################################################\n");
fprintf(fidout, "mobileNet.world.useTorus = 0\n");
fprintf(fidout, "mobileNet.world.use2D = 0\n\n");

fprintf(fidout, "##########################################################\n");
fprintf(fidout, "#			Channel Parameters                        #\n");
fprintf(fidout, "##########################################################\n");
fprintf(fidout, "mobileNet.Channel.coreDebug = 0\n");
fprintf(fidout, "mobileNet.Channel.sendDirect = 0\n");
fprintf(fidout, "mobileNet.Channel.pMax = 20\n");
fprintf(fidout, "mobileNet.Channel.sat = -90\n");
fprintf(fidout, "mobileNet.Channel.alpha = %f\n",alpha);
fprintf(fidout, "mobileNet.Channel.carrierFrequency = 2.45e+9\n\n");

fprintf(fidout, "##########################################################\n");
fprintf(fidout, "#			Host specific Parameters                        #\n");
fprintf(fidout, "##########################################################\n");
fprintf(fidout, "mobileNet.*Node*.utility.coreDebug = 0\n\n");

fprintf(fidout, "##########################################################\n");
fprintf(fidout, "#			Physical Layer Parameters                        #\n");
fprintf(fidout, "##########################################################\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.usePropagationDelay = true\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.thermalNoise = 1.0\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.analogueModels = xmldoc(\"config.xml\")\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.decider = xmldoc(\"config.xml\")\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.timeRXToTX = 0.01\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.timeRXToSleep = 0.015\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.timeTXToRX = 0.02\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.timeTXToSleep = 0.025\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.timeSleepToRX = 0.03\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.sensitivity = 0.2\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.maxTXPower = 20.0\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.phy.timeSleepToTX = 0.035\n\n");

fprintf(fidout, "##########################################################\n");
fprintf(fidout, "#			Host Parameters                        #\n");
fprintf(fidout, "##########################################################\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.connectionManagerName = \"Channel\"\n");
disp("Clear");
i=0;
j=0;
squ = sqrt(number_of_nodes) ;
squ = int8(squ) ;
for(m=0:squ)
	while((j<squ) && ( i < number_of_nodes))
	x(i+1) = 100 + j*150 ;
	fprintf(fidout, "mobileNet.Node[%d].mobility.x = %f\n",i,x(i+1));
	y(i+1) = 100 + m*150 ;
	fprintf(fidout, "mobileNet.Node[%d].mobility.y = %f\n",i,y(i+1));
	z(i+1) = i ;
	fprintf(fidout, "mobileNet.Node[%d].mobility.z = 0\n",z(i+1));
	fprintf(fidout, "mobileNet.Node[%d].normalNic.id = %d\n", i, i );
	fprintf(fidout, "mobileNet.Node[%d].normalNic.start_time = %f \n",i, rnd(i+1));
	j=j+1;
	i=i+1;
	endwhile
	j=0;
endfor
clear x;
clear y;
clear z;
clear i;
clear j;
disp("clear");
### Changing to simulation speed 
velocity = speed * (1/32768) * (1/3.6) ;
fprintf(fidout, "mobileNet.Node[*].mobility.speed= %f\n", velocity);
fprintf(fidout, "mobileNet.Node[*].mobility.updateInterval= %f\n", updateInterval);
fprintf(fidout, "mobileNet.Node[*].mobility.debug = 0 \n\n");
fclose(fidout) ;

## run the simulations
run_sim(model, ininame);

######################################################################################################
##### Vector file split to individual vector files
######################################################################################################
fidin = fopen(vectorname_m);
if ( fidin == -1 )
	error("Unable to open the main vector file ") ;
endif
fseek(fidin,7,'bof');
[Temp,Remm]=strtok(fgetl(fidin));
[vec_num,count] = sscanf(Temp,"%d");
fclose(fidin);
system("splitvec omnetpp.vec");

######################################################################################################
#####  Data extract from the vector file .
######################################################################################################

for (i=0:number_of_nodes-1)
	vec_n = i + vec_num ;
	vectorname = sprintf("omnetpp-%d.vec", vec_n);
	fidin = fopen(vectorname, "r", "native");
	if (fidin==-1)
  	error("Unable to open the vector file");
	endif
	nRows=0;
	while 1
    		iString=fgetl(fidin);
    		if ~ischar(iString)
       			break;
    		endif
    	nRows=nRows+1;
	endwhile

	%Return to beginning of file
	fseek(fidin,0,'bof');

	%For each row, assign each space delimitted object to a cell in the "Output" matrix
	for iRow=1:nRows
   		iCol=1;
    	%Temporary storage of the first object
    	%   Note: the space delimitter used here can be replaced by any delimitter
    		[TempOutput,Rem]=strtok(fgetl(fidin));
		
    	%If there is now data on this row, then assign the first object to be an underscore
		if (length(TempOutput) == 0)
        		TempOutput='_';
    		endif
    	%Build the "Output" matrix this will be the first column of the iRow-th row

		ascii_output = toascii(TempOutput) ;

		if(ascii_output(1) ==35)
		Remm = toascii(Rem); 
		start = find(Remm == 91);
		eend = find(Remm == 93) ;
		nodde = substr(Rem, start+1, eend-start-1) ;
		[node_num coun] = sscanf(nodde , "%d");
		else
		j=1;
		do j++;		
		until (ascii_output(j)== 9)
		TempOutput = substr(TempOutput,1, j-1);
		[val,count] = sscanf(TempOutput,"%d");
		if(iRow > 1)		
		MainVector(node_num+1,iRow-1) = val;
		endif
		endif
	    	%Repeat this only using Rem as the total string and incrementing the iCol counter
        endfor
	fclose(fidin);
endfor 
plot(std(MainVector));
print(filename) ;
system("rm *.vec");
disp("SIMULATION ENDED") ;
ini++ ;
disp("##############################################################################################");
disp(ini);
endfor
endfor
endfor
