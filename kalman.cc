double x; // estimated value of the variable to be considered 
double phi; // coefficient to bla bla the previous estimate in it
double z;   // measured value
double H;  // adjustment matrix
double R;  // noise covariance
double P;  // error covariance 
double K;  // Kalman gain 
double Q;  // noise covariance  

// Initialize the matrices 

x = 1 ; // Initial estimate 
P = 1 ; // Initial estimate of covariance matrix - error covariance matrix

phi = 1 ;
Q = 1 ;
R = 1 ;
H = 1 ;

// Loop 

// Time update "PREDICT"

x = phi*x + B*U ;
P = (phi * P) * (1/phi) + Q ;

// Measurment Update "CORRECT"

// Compute Kalman gain

K = P * (1/H) * 1/(( ( H * P ) * (1/H) ) + R);	

// update estimate with measurement

x = x + K * (z(1) - (H * x) );

// update the error covariance

P = ( 1 - (K * H)) * P;	

//endloop 




