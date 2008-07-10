/* hello.c: display a message on the screen */

#include <stdio.h>

/**
 * \brief Perform the slot and phase synchronization algorithm.
 */
    int nNeighbours = 108;
    int slotError;
    int phaseError;
    int nbSlotOffset[] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27} ;
    int tmp;
    int temp ;
    int lastFrameSlot = 2 ;
    int SLOT_TIME = 10 ;
    int i, n;
int main() {  
	int fasika ;	
	for(fasika =1;fasika < 10000;fasika++){
        med(nNeighbours);
	kalman(nNeighbours);
	weighty(nNeighbours);
	curvy(nNeighbours);
	}
	return 0 ;
}
int med(int nNeigh) {

//printf("This is Median.....Get over it\n") ;

            int medianerror;
            for (i = 1; i < nNeigh; i++) {
                for (n = nNeigh-1; n > i; n--) {
                    if (nbSlotOffset[i] > nbSlotOffset[n]){
                        tmp = nbSlotOffset[i];
			nbSlotOffset[i]=nbSlotOffset[n] ;
			nbSlotOffset[n]=tmp ;
		}}
            }
	    if(nNeigh%2==0)
            phaseError = nbSlotOffset[nNeigh/2];
	    else
	    phaseError = nbSlotOffset[(nNeigh+1)/2];
}           

int kalman(int nNeigh){
	
//		printf("Welcome to Kalman Filter ...Hope U will like your stay here\n") ;
		int kalmanerror ;
	       for (i = 1; i < nNeigh; i++) {
                for (n = nNeigh-1; n > i; n--) {
                    if (nbSlotOffset[i] > nbSlotOffset[n]){
                        tmp = nbSlotOffset[i];
			nbSlotOffset[i]=nbSlotOffset[n] ;
			nbSlotOffset[n]=tmp ;
		}}
            }

	int x;    // estimated value of the variable to be considered 
	int phi ; // prediction factor 
	int R;    // noise covariance
	int P;    // error covariance 
	int Ka;   // Kalman gain 
	int Q;    // noise covariance 
        int H; 

		// Initialize the matrices 

	x = 0 ;   // Initial estimate 
	P = 1 ;   // Initial estimate of covariance matrix - error covariance matrix
	Q = 10;   // covariance matrix - 
	R = 1 ;
	H = 1;
	phi = 5/4;

	// Loop 

	for(i=0; i<nNeigh; i++) {
			
			kalmanerror = nbSlotOffset[i] ;
			
			// Time update "PREDICT"

			x = phi*x ;  
			P =  phi*P*phi + Q ;

			// Measurment Update "CORRECT"

			// Compute Kalman gain

			Ka = P * H /(( H * P * H ) + R);	

			// update estimate with measurement
			
			x = x + Ka * (kalmanerror - (H * x) );
			// update the error covariance

			P = ( 1 - (Ka * H)) * P;	

	}

	phaseError = x ;
} 

int weighty(int nNeigh){

//	printf("How much WEIGHT do u want ?\n") ;

        int totalError[nNeigh];
	int maxx = 0;
	int totalweight = 0 ;
	int temp ;
        int weight[nNeigh];
        int summ = 0 ;
	float cons ;
	for (i = 1; i < nNeigh; i++) {
                for (n = nNeigh-1; n > i; n--) {
                    if (nbSlotOffset[i] > nbSlotOffset[n]){
                        tmp = nbSlotOffset[i];
			nbSlotOffset[i]=nbSlotOffset[n] ;
			nbSlotOffset[n]=tmp ;
		}}
        }
	for (i=0; i<nNeigh; i++) {
		totalError[i] = abs(nbSlotOffset[i]);	
		if(totalError[i] < 9)
			cons = 0.8 ;
		else if(totalError[i] < 18)
			cons = 0.3 ;		
		else if(totalError[i] < 27)
			cons = 0.1;
		else 
			cons = 0.5;
 		totalweight = totalweight + cons ;
        	summ = summ + totalError[i] * cons;
        }
        if(totalweight!=0)     
	phaseError = summ/totalweight;
	else
	phaseError = summ;
}
 
int curvy(int nNeigh){

//	       printf("I am curved in irregular manner....what shall I do ?\n") ;
	   for (i = 1; i < nNeigh; i++) {
                for (n = nNeigh-1; n > i; n--) {
                    if (nbSlotOffset[i] > nbSlotOffset[n]){
                        tmp = nbSlotOffset[i];
			nbSlotOffset[i]=nbSlotOffset[n] ;
			nbSlotOffset[n]=tmp ;
		}}
            }
	       int totalError[nNeigh];
	       int sum =0 ;
	       int sumsq = 0 ;
	       int sumprod = 0 ;
	       int sumy = 0;
               int cmp = 1 ;
	       int k ;
               for(k=0 ; k<nNeigh ; k++){
		       totalError[k] = nbSlotOffset[i] ;
		       sumy += (totalError[k] + 1);
                       sum += 0.4*k;
                       sumsq += 0.16*k*k;
                       sumprod += (totalError[k]+cmp) * 0.4*k;   

               }          
               int b = (nNeigh*sumprod - sumy*sum)/(nNeigh*sumsq - (sum*sum));
               int a = (sumy - b*sum) / nNeigh;
               int tempp = a + b*0.4*(nNeigh/2) ;
	       phaseError =  temp;
 	       
}

