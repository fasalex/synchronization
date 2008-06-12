
iter = 5 ;
for master=1:iter 
keep('master','finalvec','iter');
clf ;
system("rm *.vec");
system("rm *.sca");

number_of_nodes = 100 ;
rnd = [ 0.8143029   0.1436809   0.3708347   0.3751496   0.9997108   0.2128853   0.2519268   0.9645563   0.7833585   0.6117664   0.2488287   0.7356938   0.9992336 0.9947599   0.4696405   0.6541043   0.8898897   0.2130503  0.9190389   0.4829364   0.9184579   0.8490024   0.3047150   0.1094834   0.8235706   0.1189216 0.7378912   0.8568373   0.3897217   0.2688272   0.6572797   0.6881676   0.3183481   0.0048737   0.1204599   0.9669948   0.5117774   0.4241742   0.2122554 0.5350033   0.5500493   0.0556049   0.7438356   0.1723119   0.6855482   0.1854460   0.0407906   0.2015634   0.5702908   0.0701168   0.3850803   0.1734662 0.0076402   0.1214227   0.7501434   0.2834053   0.8838660   0.3743215   0.1851521   0.7505261   0.7204267   0.3326949   0.9364861   0.8168793   0.1224146 0.8613567   0.6900291   0.3413432   0.9305705   0.7447966   0.2897837   0.9311427   0.1047797   0.4313064   0.3121755   0.3825634   0.5265033   0.0415815 0.2966999   0.2156913   0.3764479   0.5211732   0.8367369   0.0229211   0.9339046   0.1499722   0.8459940   0.1217056   0.4445572   0.8465233   0.8582198 0.7865434   0.7004069   0.7445873   0.3609242   0.3545262   0.0267232   0.8984687   0.6323993   0.1587987] ;
hold on ;

rnd = rand(1,number_of_nodes);

for fasika = 1:4
keep('fasika','number_of_nodes','rnd','master','finalvec','iter');
algorithm = fasika ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%          INPUT PARAMETERS FOR THE SIMULATION                         %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run = 1 ;                           %% 1 - commandline  2 - gui 
jump = 1 ;                          %% jump to reduce the calculation burden 
sim_time_limit = 1000;		    %% Number of events needed for "limit" 
speed = 0 ;                         %%  In Kilometer per hour 
updateInterval = 1;                 %% In simulation seconds 
gain = 0.85 ;                       %% Value for computing the offsets 
express = "yes" ;                   %% Enable or Disable express mode 
alpha = 2.50 ;                      %% Channel factor - attenuation if you might say ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%          END OF PARAMETERS , OUT                                     %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (fasika == 1)
color = 'b' ;
elseif(fasika == 2 )
color = 'r';
elseif(fasika == 3)
color = 'g';
elseif(fasika == 4)
color = 'm';
elseif(fasika == 5)
color = 'c';
elseif(fasika == 6)
color = 'w';
endif

prefix = "/home/fasika/mixim/trunk/examples/synchronization/graphs/";		 % output directory
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
ra = int2str(rand()*1000 );
alp = int2str(alpha*100);
ext = '.eps';
filename = strcat(prefix,'s',ra,spe,'-g',gai,'-n',no,'-alpha',alp,ext);

playgroundSizeX = (sqrt(number_of_nodes) + 2) * 150 ; %% meters
playgroundSizeY = (sqrt(number_of_nodes) + 2) * 150 ; %% meters

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
fprintf(fidout, "mobileNet.Channel.pMax = 20\n");
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

%%% Changing to simulation speed
speed = speed * (1/3.6) ;
fprintf(fidout, "mobileNet.Node[*].mobility.speed= %f\n", speed);
fprintf(fidout, "mobileNet.Node[*].mobility.updateInterval= %f\n", updateInterval);
fprintf(fidout, "mobileNet.Node[*].mobility.debug = 0 \n\n");
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

%% The vector which contains the time information about the nodes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Data extracting from the scalar file ....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fidin = fopen(scalarname, "r", "native");
%k=0;
%if (fidin==-1)
% error("Unable to open the scalar file");
%endif
%while 1
% iString=fgetl(fidin);
% if ~ischar(iString)
% break;
% endif
% [val, count] = sscanf(iString, "scalar \"mobileNet.Node[%d].normalNic.mac\" \"Time at last\" %f");
% if( count == 0)
% else
% final_time(k,k) = val(2);
% final(k) = val(2) ;
% endif
% k = k + 1 ;
%endwhile
%fclose(fidin);
%offset = final_time / max(max(final_time));
%vi = find(offset == 0 ) ;
%offset(vi) = nan ;
%[X Y] = meshgrid(x,y);
%I = input( "Do U want to plot the 3D graph? 0/1 " ) ;
%if ( I == 1)
%mesh(X,Y,offset);
%axis([0 1000 0 1000 0 1 ]);
%figure;
%plot3(x,y,final/max(final),'*');
%axis([0 1000 0 1000 0 1 ]);
%endif
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% End of Simulation -- Deleting files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m = length(MainVector);
if(m>=sim_time_limit)
MainVector(:,sim_time_limit:m) = MainVector(1,sim_time_limit-1) ;
endif
temp = max(MainVector) - min(MainVector) ;
mea = mean(MainVector) ;
plot(std(MainVector),color);
endfor
xlabel('period(sec)');
ylabel('Synchronization error(microseconds)');
legend("Kalman filter","Median","Weighted measurment","Curve fitting","Minimum Mean Square Estimator");
print(filename);
hold on ;
disp("SIMULATION ENDED") ;
endfor

kalman = zeors(1,iter);
medina = zeros(1,iter);
weight = zeros(1,iter);
curvefit = zeros(1,iter);

for(k=1:iter)
    kalman = kalman + finalvec((k-1)*4 + 1 ,:) ;
    median = median + finalvec((k-1)*4 + 2 ,:) ;
    weight = weight + finalvec((k-1)*4 + 3 ,:) ;
    curvefit = curvefit + finalvec((k-1)*4 + 4 ,:) ;
endfor
 
kalman = kalman / iter;
median = median / iter ;
weight = weight / iter ;
curvefit = curvefit / iter ;

figure ;
hold on ;
plot(kalman, 'b');
plot(median, 'r');
plot(weight, 'c');
plot(curvefit, 'm');

