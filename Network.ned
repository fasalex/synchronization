import  
    "Host", 
    "ConnectionManager",
    "BaseWorldUtility";
 
module Network 
    parameters: 
        playgroundSizeX : numeric const, // x size of the area the nodes are in (in meters)
        playgroundSizeY : numeric const, // y size of the area the nodes are in (in meters)
        playgroundSizeZ : numeric const, // z size of the area the nodes are in (in meters)
        numHosts : numeric const; // total number of weak hosts in the network
                                
    submodules: 
    	world: BaseWorldUtility;
    		parameters: 
                playgroundSizeX = playgroundSizeX, 
                playgroundSizeY = playgroundSizeY,
                playgroundSizeZ = playgroundSizeZ;
            display: "p=250,0;i=misc/globe";
                                
        Channel: ConnectionManager;
            display: "p=450,0;b=42,42,rect;o=red;i=abstract/multicast";
            
        Node: Host[numHosts]; 
            parameters: 
                numHosts = numHosts; 
            display: "p=50,50;b=22,22,rect;o=red;i=device/palm";
    connections nocheck: 
                         // all connections and gates are to be generated dynamically
                         
    display: "p=10,50;b=$playgroundSizeX,$playgroundSizeY,rect;o=white";
endmodule 

network mobileNet : Network
endnetwork 

