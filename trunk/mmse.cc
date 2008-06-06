
double H; // Coefficient Matrix (nx1)
double W; // Weight factor (nxn)
double y; // Measured values ( phase offsets) (nx1)
double x; // Estimated value of the offset, next firing time (1x1)
double J; // Error function 
double k; // gain factor , may be a kalman gain , who knows ?

// Initialization of the parameters 
H = 1 ;
x = 1 ;
w = 1 ;

// Loop 

x = 1/((1/H)*W*H)*(1/H)*W*y[0] ;

// Sequential LS Estimation 

k = P*H*W ;
x = x + k(y - H*x) ;
P =(1-k*H)*P ;

//endloop 




