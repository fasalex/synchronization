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
            display: "i=device/palm;is=vs";
    connections nocheck: 
                         // all connections and gates are to be generated dynamically
                         
    display: "b=$playgroundSizeX,$playgroundSizeY,rect;o=white";
endmodule 

network mobileNet : Network
endnetwork 

