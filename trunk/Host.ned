import
    "Nic",
    "ConstSpeedMobility",
    "BaseUtility";


module Host
    parameters:
        numHosts : numeric const; // total number of hosts in the network

    gates:
        in: radioIn;

    submodules:
        utility: BaseUtility;
            display: "p=130,60;i=block/blackboard";   
        mobility: ConstSpeedMobility;
            display: "p=130,130;i=block/cogwheel";  
        normalNic: Nic;
        parameters:			
            display: "b=32,30;p=60,166;i=block/ifcard";
    connections:

		radioIn --> normalNic.radioIn;

    display: "p=10,10;b=180,200,rect;o=white";
endmodule

