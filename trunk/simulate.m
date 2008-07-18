%%%% The begining of the end !!!!!!!!!!
for s=1:1
iter = 1 ;
finalvec = zeros(iter,500);
barplotter=zeros(20,500,4); 
clf;
for master=1:iter 
keep('master','finalvec','iter','s','barplotter');
clf ;

system("rm *.vec");
system("rm *.sca");

number_of_nodes = 20 ;
rnd = rand(1,number_of_nodes);
hold on ;
for fasika = 1:4
keep('fasika','number_of_nodes','rnd','master','finalvec','iter','s','barplotter');
algorithm = 2 ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%          INPUT PARAMETERS FOR THE SIMULATION                         %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run = 1 ;                           %% 1 - commandline  2 - gui 
jump = 1 ;                          %% jump to reduce the calculation burden 
sim_time_limit = 500;		    %% Number of events needed for "limit" 
updateInterval = 1;                 %% In simulation seconds 
if(s==1) 			    %% Speed of the nodes , random in a sense that 
speed = 0 ;
elseif(s==2)
speed = 5.4 + rand() ;   
elseif(s==3)
speed = 20 + rand() ;
endif
gain = 0.2*fasika + 0.2 ;                       %% Value for computing the offsets 
express = "yes" ;                   %% Enable or Disable express mode 
alpha =2.5;                         %% Channel factor - attenuation if you might say ...
playgroundSizeX = (sqrt(number_of_nodes)+1)*30; % The distance between the nodes is at max 30 meters 
%%playgroundSizeX = 300 ;
playgroundSizeY =  playgroundSizeX ;            %% meters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%          END OF PARAMETERS , OUT                                     %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (fasika == 1)
color = 'b' ;
elseif(fasika == 2 )
color = '^';
elseif(fasika == 3)
color = '+';
elseif(fasika == 4)
color = 'rs';
elseif(fasika == 5)
color = 'c';
elseif(fasika == 6)
color = 'w';
endif

prefix = "/home/fasika/mixim/trunk/examples/synchronization/graphs/";	% output directory
model = "./New";		  % simulation command

%% create ini file

if(run==1)
system("cp Makefile_cmd Makefile");
else
system("cp Makefile_tk Makefile");
endif

system("make") ;
vectorname_m = "omnetpp.vec";
scalarname = "omnetpp.sca";
ininame = "omnetpp.ini";

spe = int2str(speed);
gai = int2str(gain*10);
no = int2str(number_of_nodes);
ra = int2str(rand()*500 );
alp = int2str(alpha*100);
ext = '.eps';
filename = strcat(prefix,ra,'s',spe,'-g',gai,'-n',no,'-alpha',alp,ext);

fidout = fopen(ininame, "w", "native");
fprintf(fidout, "[General]\n");
fprintf(fidout, "preload-ned-files = *.ned @nedincludes.lst\n");
fprintf(fidout, "network = mobileNet\n");
fprintf(fidout, "sim-time-limit = %d\n\n", sim_time_limit);

fprintf(fidout, "[Cmdenv]\n");
fprintf(fidout, "express-mode = %s\n", express);

fprintf(fidout, "[Parameters]\n");
fprintf(fidout, "##############################\n");
fprintf(fidout, "# Simulation parameters #\n");
fprintf(fidout, "##############################\n");
fprintf(fidout, "mobileNet.**.coreDebug = 0\n");
fprintf(fidout, "mobileNet.playgroundSizeX = %d\n", playgroundSizeX);
fprintf(fidout, "mobileNet.playgroundSizeY = %d\n", playgroundSizeY);
fprintf(fidout, "mobileNet.playgroundSizeZ = 0\n");
fprintf(fidout, "mobileNet.numHosts = %d \n", number_of_nodes);
fprintf(fidout, "mobileNet.Node[*].normalNic.jump = %d \n" , jump) ;
fprintf(fidout, "mobileNet.Node[*].normalNic.algorithm = %d \n" , algorithm) ;
fprintf(fidout, "mobileNet.Node[*].normalNic.gain = %f \n" , gain) ;
fprintf(fidout, "mobileNet.Node[*].normalNic.hosts = %d \n\n", number_of_nodes);

fprintf(fidout, "##############################\n");
fprintf(fidout, "# World Utility Parameters #\n");
fprintf(fidout, "##############################\n");
fprintf(fidout, "mobileNet.world.useTorus = 0\n");
fprintf(fidout, "mobileNet.world.use2D = 0\n\n");

fprintf(fidout, "##############################\n");
fprintf(fidout, "# Channel Parameters #\n");
fprintf(fidout, "##############################\n");
fprintf(fidout, "mobileNet.Channel.coreDebug = 0\n");
fprintf(fidout, "mobileNet.Channel.sendDirect = 0\n");
fprintf(fidout, "mobileNet.Channel.pMax = 4\n");
fprintf(fidout, "mobileNet.Channel.sat = -82\n");
fprintf(fidout, "mobileNet.Channel.alpha = %f\n",alpha);
fprintf(fidout, "mobileNet.Channel.carrierFrequency = 2.45e+9\n\n");

fprintf(fidout, "##############################\n");
fprintf(fidout, "# Host specific Parameters #\n");
fprintf(fidout, "##############################\n");
fprintf(fidout, "mobileNet.*Node*.utility.coreDebug = 0\n\n");

fprintf(fidout, "##############################\n");
fprintf(fidout, "# Physical Layer Parameters #\n");
fprintf(fidout, "##############################\n");
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

fprintf(fidout, "##############################\n");
fprintf(fidout, "# Host Parameters #\n");
fprintf(fidout, "##############################\n");
fprintf(fidout, "mobileNet.Node[*].normalNic.connectionManagerName = \"Channel\"\n");
fprintf(fidout, "mobileNet.Node[*].mobility.angle = 2\n");
fprintf(fidout, "mobileNet.Node[*].mobility.acceleration = 2 \n");
speed = speed * (1/3.6) ;
i=0;
j=0;
squ = sqrt(number_of_nodes) ;
spac = playgroundSizeX / (1 + squ) ;
squ = int8(squ) ;
for(m=0:squ)
while((j<squ) && ( i < number_of_nodes))
x(i+1) = spac + j*spac ;
fprintf(fidout, "mobileNet.Node[%d].mobility.x = %f\n",i,x(i+1));
y(i+1) = spac + m*spac ;
fprintf(fidout, "mobileNet.Node[%d].mobility.y = %f\n",i,y(i+1));
z(i+1) = i ;
fprintf(fidout, "mobileNet.Node[%d].mobility.z = 0\n",z(i+1));
fprintf(fidout, "mobileNet.Node[%d].normalNic.id = %d\n", i, i );
fprintf(fidout, "mobileNet.Node[%d].normalNic.start_time = %f \n",i, rnd(i+1));
fprintf(fidout, "mobileNet.Node[%d].mobility.speed= %f\n",i, speed);
fprintf(fidout, "mobileNet.Node[%d].mobility.updateInterval= %f\n",i, updateInterval);
fprintf(fidout, "mobileNet.Node[%d].mobility.debug = 0 \n\n",i);
j=j+1;
i=i+1;
endwhile
j=0;
endfor

fclose(fidout) ;

%%
%% run the simulations
%%

run_sim(model,ininame) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Vector file split to individual vector files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fidin = fopen(vectorname_m);
if ( fidin == -1 )
error("Unable to open the main vector file ") ;
endif
fseek(fidin,7,'bof');
[Temp,Remm]=strtok(fgetl(fidin));
[vec_num,count] = sscanf(Temp,"%d");
fclose(fidin);
system("splitvec omnetpp.vec");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Data extract from the vector file .
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
% Note: the space delimitter used here can be replaced by any delimitter
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
num = find (ascii_output == 9) ;
TempOutput = substr(TempOutput,num(1)+1,num(2)-num(1));
[val,count] = sscanf(TempOutput,"%d");
if(iRow > 1)
MainVector(node_num+1,iRow-1) = val;
endif
endif
%Repeat this only using Rem as the total string and incrementing the iCol counter
endfor
fclose(fidin);
endfor
%% START EXTRACTING THE VECTOR FORM THE FILE 
for(l=1:sim_time_limit)
barplotter(:,l,fasika) = (MainVector(:,l)-min(MainVector(:,l)))' ;
endfor
finalvec((master-1)*4 + fasika,:) = uint8(max(MainVector(:,1:500)/30)-min(MainVector(:,1:500)/30)) ;
endfor
endfor 

kalman = zeros(1,500);
med = zeros(1,500);
weight = zeros(1,500);
curvefit = zeros(1,500);

for(k=1:iter)
    kalman = kalman + finalvec((k-1)*4 + 1 ,:) ;
    med = med + finalvec((k-1)*4 + 2 ,:) ;
    weight = weight + finalvec((k-1)*4 + 3 ,:) ;
    curvefit = curvefit + finalvec((k-1)*4 + 4 ,:) ;
endfor
%% TAKING THE AVERAGE OF THE VECTORS TO FIND THE OPTIMAL VALUE FOR THE SIMULATION 
kalman = kalman / iter;
med = med / iter ;
weight = weight / iter ;
curvefit = curvefit / iter ;
%% PLOT THE DAMN AVERAGED GRAPHS FROM THE VARIABLES
hold on ;
plot(kalman, 'b','LineWidth',3);
plot(med, '^-r','LineWidth',3);
plot(weight, '+-m','LineWidth',3);
plot(curvefit, '-os','LineWidth',3);
tit = strcat('Synchronization error for ',no,' nodes with different gain factor');
xlabel('period(sec)','fontsize',22);
ylabel('Synchronization error(clock cycles)','fontsize',22);
%legend("KALMAN FILTER","MEDIAN","WEIGHTED MEASURMENTS","NONLINEAR CURVE FITTING");
legend("0.4","0.6","0.8","1");
%legend("0.25","0.5","0.75","1.0");
title(tit,'fontsize',24);
grid on ;
print('-F:20',filename) ;
clf;
%% Perform comparisons Numerically
med(find(med<=1)) = 1 ;
K = abs(med - kalman)*100./ med ;
W = abs(med - weight)*100./ med ;
NLCF = abs(med - curvefit)*100./med ;
hold on ;
filename = strcat(prefix,ra,'s',spe,'-g',gai,'-n',no,'-alpha',alp,' Error',ext);
plot(K,'b','LineWidth',3);
plot(W,'+-m','LineWidth',3);
plot(NLCF,'-os','LineWidth',3) ;
xlabel('period(sec)','fontsize',22) ;
ylabel('Percentage Performance Improvment over Median(%)','fontsize',22);
legend("KALMAN FILTER","WEIGHTED MEASURMENTS","NONLINEAR CURVE FITTING");
title('Percentage performance improvement compared to Median algorithm(%)','fontsize',24);
grid on ;
print('-F:20',filename) ;
endfor
%% For the gradient graph
%%  y = (rho*d.*log(x-1))./(8*(1+rho)*log(8*(1+rho).*log(x-1)/rho)) 
anime = [kalman,med,weight,curvefit]';
disp("Euffffffffff");
