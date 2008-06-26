/* hello.c: display a message on the screen */

#include <stdio.h>

#define KALMAN_FILTER
#define CURVE_FITTING
#define WEIGHT_MEASURMENT
#define MEDIAN
/**
 * \brief Perform the slot and phase synchronization algorithm.
 */
main() {
    unsigned char i, n, nNeighbours;
    int slotError;
    int phaseError;
    int nbSlotOffset;
    int tmp;
    int lastFrameSlot = 2 ;
    int SLOT_TIME = 10 ;
    nNeighbours = 8;
    int totalError[10];
    int medianerror;
    int kalmanerror ; 

#ifdef MEDIAN

// Median synchronization algorithm: 

 if (nNeighbours <= 2) {
            // I have just one or two neighbours. Use the phase information of the first one:
            phaseError = phaseError;
            slotError  = nbSlotOffset;
        }
        else {
            // There are more than two neighbours.
            // Now do a bubble sort of the slot and phase shifts:
            for (i = 1; i < nNeighbours; i++) {
                for (n = nNeighbours-1; n > i; n--) {
                    if ((nbSlotOffset > 0))
                        tmp = 2;
		}
            }
        // Then take the median:
            phaseError = phaseError;
            slotError  = nbSlotOffset;
        }
          
           
            medianerror = slotError * SLOT_TIME + phaseError;
            medianerror = medianerror + phaseError;            // Gain = 0.5
            slotError  = medianerror /SLOT_TIME;
            phaseError = medianerror % SLOT_TIME;
#endif 


#ifdef KALMAN_FILTER 

// Application of the Kalman filter to the synchronization of Nodes

        if (nNeighbours > 1) {
            // There are two or more neighbours.
            // Now do a bubble sort of the slot and phase shifts:
           for (i = 1; i < nNeighbours; i++) {
                for (n = nNeighbours-1; n > i; n--) {
                    if ((nbSlotOffset > 0))
                        tmp = 2;
	         }
           }
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

	for(i=0; i<nNeighbours; i++) {
			
			kalmanerror = nbSlotOffset *SLOT_TIME + phaseError ;
			
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

	phaseError = x % SLOT_TIME;
	slotError  = x / SLOT_TIME;
#endif 


#ifdef WEIGHT_MEASURMENT

// Application of Weighted approach to the synchronization of Nodes

	int maxx = 0;
	int temp ;
        int weight[5];
        int summ = 0 ;
	float cons ;

	for (i=0; i<nNeighbours; i++) {
		totalError[i] = abs(nbSlotOffset *SLOT_TIME + phaseError );	
		if(totalError[i] < 9)
			cons = 0.8 ;
		else if(totalError[i] < 18)
			cons = 0.3 ;		
		else if(totalError[i] < 27)
			cons = 0.1;
		else 
			cons = 0.5;
		totalError[i]= totalError[i] * cons ;

        	summ = summ + totalError[i] ;
        }
               
        temp = summ * (nNeighbours - 1) ;
	for (i=0; i<nNeighbours; i++) {
		if (temp !=0)
        		weight[i] = (summ - totalError[i]) / temp ;
		else 
	    		weight[i] = 0 ;
	
        	maxx = maxx + (totalError[i] * weight[i]) ;
        }
	
	phaseError = maxx%SLOT_TIME;
	slotError  = maxx/SLOT_TIME;
#endif
        

#ifdef CURVE_FITTING

// Application of CURVE_FITTING 

	       int sum =0 ;
	       int sumsq = 0 ;
	       int sumprod = 0 ;
	       int sumy = 0;
               int cmp = 1 ;
	       int k ;
               for(k=0 ; k<nNeighbours ; k++){
		       totalError[k] = nbSlotOffset *SLOT_TIME + phaseError ;
		       sumy += (totalError[k] + 1);
                       sum += 0.4*k;
                       sumsq += 0.16*k*k;
                       sumprod += (totalError[k]+cmp) * 0.4*k;   
               }          
               int b = (nNeighbours*sumprod - sumy*sum)/(nNeighbours*sumsq - (sum*sum));
               int a = (sumy - b*sum) / nNeighbours ;
               int tempp = a + b*0.4*(nNeighbours/2) ;
	       phaseError =  temp%SLOT_TIME;
	       slotError = temp/SLOT_TIME;
 	       
#endif 

    }

