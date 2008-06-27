/*
 ****************************************************************************************************
 *           Copyright (C)  2008 Chess, Haarlem, the Netherlands.  All rights reserved.             *
 ****************************************************************************************************
 * 
 * Version: $Id: gMacSynchronize.c,v 1.10 2008/04/24 15:59:17 frits Exp $
 */
 
/**
 * \brief Frame synchronisation algorithm for gMac
 * 
 * \par Description
 * At the end of the active period (the period in which the TDMA slots are scheduled)
 * of a frame, the MyriaCore scheduler will call the gMacSynchronize() function.
 * 
 * \par Order of execution
 * The gMacTdmaStrategy() will be called first, then the gMacSynchronize() function.
 * This is important when acessing and updating variables in the gMacFram structure!
 *
 * \author
 *      Chess B.V. - Innovation Team (Frits van der Wateren)
 */

#include <stdlib.h>
#include <avr/interrupt.h>
#include "gMac.h"
#include "mcDebugIo.h"

#ifdef MC_DEBUG_PRINT_SYNC
#include "mcUart.h"
#endif

//#define KALMAN_FILTER
//#define CURVE_FITTING
//#define WEIGHT_MEASURMENT
#define MEDIAN

extern volatile Frame gMacFrame;   //!< Global value for a frame

//! Phase statistics of all messages that I have received in one Frame:
//  Allocate one additional place as free overflow location.
extern volatile rxStatsStruct rxStatistics[];


/**
 * \brief Perform the slot and phase synchronization algorithm.
 */
void gMacSynchronize(void) {
    unsigned char i, n, nNeighbours;
    int slotError;
    int phaseError;
    rxStatsStruct tmp;

    // Lock the number of neighbours, since a radio interrupt
    // could add more information, while I'm busy here....
    // FIXME: This is a fail safe, and cannot happen, since the Radio is off here....
    nNeighbours = gMacFrame.numRxMsg;
    
    if ((gMacFrame.syncState == NETWORK_CATCH)
       || (gMacFrame.syncState == NETWORK_CATCHED)
       || (gMacFrame.syncState == DO_PHASE_SYNC)) {
#ifdef MC_DEBUG_PRINT_SYNC
        if (gMacFrame.syncState == NETWORK_CATCH) dbgPrintChar('C');
        else if (gMacFrame.syncState == NETWORK_CATCHED) dbgPrintChar('d');
        else if (gMacFrame.syncState == DO_PHASE_SYNC) dbgPrintChar('?');
#endif
        return;
    }
    
    if (nNeighbours != 0) {

        // I have one or more neighbours:
        gMacFrame.emptySchedules = 0;
        
        // First see if I have discovered another network:
        for (i=0; i<nNeighbours; i++) {
            if ((rxStatistics[i].nbTxSlot > gMacFrame.lastTdmaSlot)
              || (gMacFrame.syncState == NETWORK_SEARCH)) {
                // Found another network, synchronize to it...
                phaseError = rxStatistics[i].phaseError;
                slotError  = rxStatistics[i].nbSlotOffset;
                cli();
                if (slotError < 0) {
                    gMacFrame.lastFrameSlot = slotError + 2 * TOTAL_FRAME_SLOTS - 1;
                    }
                else {
                    gMacFrame.lastFrameSlot = slotError + TOTAL_FRAME_SLOTS - 1;
                }
                gMacFrame.phaseError = phaseError;
                gMacFrame.syncState = DO_PHASE_SYNC;
                sei();
#ifdef MC_DEBUG_PRINT_SYNC
                dbgPrintStr("\nFound Network, r:");
                dbgPrintHex4(rxStatistics[i].myRxSlot);
                dbgPrintStr(" t:");
                dbgPrintHex4(rxStatistics[i].nbTxSlot);
                dbgPrintStr(" p:");
                dbgPrintHex4(gMacFrame.phaseError);
                dbgPrintStr(" s:");
                dbgPrintHex4(slotError);
                dbgPrintStr(" f:");
                dbgPrintHex4(gMacFrame.lastFrameSlot);
#endif
                return;
            }
        }
        // Here I'm in the normal slot synchronization mode:

    mcSetDebugSignal5();
// Set the debug signal 

#ifdef MEDIAN

// Median synchronization algorithm: 

#ifdef MC_DEBUG_PRINT_SYNC
        dbgPrintStr("\n MEDIAN ");
#endif
        if (nNeighbours <= 2) {
            // I have just one or two neighbours. Use the phase information of the first one:
            phaseError = rxStatistics[0].phaseError;
            slotError  = rxStatistics[0].nbSlotOffset;
        }
        else {
            // There are more than two neighbours.
            // Now do a bubble sort of the slot and phase shifts:
            for (i = 1; i < nNeighbours; i++) {
                for (n = nNeighbours-1; n > i; n--) {
                    if ((rxStatistics[n-1].nbSlotOffset > rxStatistics[n].nbSlotOffset) ||
                        ((rxStatistics[n-1].nbSlotOffset == rxStatistics[n].nbSlotOffset) &&
                         (rxStatistics[n-1].phaseError > rxStatistics[n].phaseError))) {
                        tmp = rxStatistics[n];
                        rxStatistics[n] = rxStatistics[n-1];  // Flip elements
                        rxStatistics[n-1] = tmp;
                    }
                }
            }
            // Then take the median:
            phaseError = rxStatistics[nNeighbours/2].phaseError;
            slotError  = rxStatistics[nNeighbours/2].nbSlotOffset;
        }

        // Now update the Frame stucture as an atomic operation.
        // The actual synchronization will take place in one of the upcoming Idle slots...
        if (slotError == 0) {
            // Here we can do a simple control loop calculus:
            cli();
            gMacFrame.lastFrameSlot = TOTAL_FRAME_SLOTS - 1;
            gMacFrame.phaseError = phaseError/2 + phaseError/4;   // Gain = 0.75
            gMacFrame.syncState = DO_PHASE_SYNC;
            sei();
#ifdef MC_DEBUG_PRINT_SYNC
            dbgPrintHex(nNeighbours);
            dbgPrintHex2(gMacFrame.phaseError);
            dbgPrintChar(' ');
#endif
        }
        else {
            // In case of slot mis-alignment we need a more complex calculus:
            int totalError;

            totalError = slotError * (uint8_t)SLOT_TIME + phaseError;
            totalError = totalError/2 + phaseError/4;            // Gain = 0.5
            slotError  = totalError / (uint8_t)SLOT_TIME;
            phaseError = totalError % (uint8_t)SLOT_TIME;
            cli();
            gMacFrame.lastFrameSlot = slotError + TOTAL_FRAME_SLOTS - 1;
            gMacFrame.phaseError = phaseError;
            gMacFrame.syncState = DO_PHASE_SYNC;
            sei();

        }
#endif 


#ifdef KALMAN_FILTER 

// Application of the Kalman filter to the synchronization of Nodes

#ifdef MC_DEBUG_PRINT_SYNC
        dbgPrintStr("\n KALMAN ");
#endif
        if (nNeighbours > 1) {
            // There are two or more neighbours.
            // Now do a bubble sort of the slot and phase shifts:
            for (i = 0; i < nNeighbours; i++) {
                for (n = nNeighbours-1; n > i; n--) {
                    if ((rxStatistics[n-1].nbSlotOffset > rxStatistics[n].nbSlotOffset) ||
                       ((rxStatistics[n-1].nbSlotOffset == rxStatistics[n].nbSlotOffset) &&
                        (rxStatistics[n-1].phaseError > rxStatistics[n].phaseError))) {
                       tmp = rxStatistics[n];
                       rxStatistics[n] = rxStatistics[n-1];  // Flip elements
                       rxStatistics[n-1] = tmp;
                    }
                }
            }
        }
	int totalError ; 
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
			
			totalError = rxStatistics[i].nbSlotOffset *(uint8_t)SLOT_TIME + rxStatistics[i].phaseError ;
			
			// Time update "PREDICT"

			x = phi*x ;  
			P =  phi*P*phi + Q ;

			// Measurment Update "CORRECT"

			// Compute Kalman gain

			Ka = P * H /(( H * P * H ) + R);	

			// update estimate with measurement
			
			x = x + Ka * (totalError - (H * x) );
			// update the error covariance

			P = ( 1 - (Ka * H)) * P;	
	}

	phaseError = x % SLOT_TIME;
	slotError  = x / SLOT_TIME;
#ifdef MC_DEBUG_PRINT_SYNC
        dbgPrintHex4(phaseError);
        dbgPrintChar(':');
        dbgPrintHex4(slotError);
#endif
 	cli();
        gMacFrame.lastFrameSlot = slotError + TOTAL_FRAME_SLOTS - 1;
        gMacFrame.phaseError = phaseError;
        gMacFrame.syncState = DO_PHASE_SYNC;
        sei();
#endif 


#ifdef WEIGHT_MEASURMENT

// Application of Weighted approach to the synchronization of Nodes

#ifdef MC_DEBUG_PRINT_SYNC
        dbgPrintStr("\n WEIGHT_MEASUREMENT");
#endif
	int maxx = 0;
	int temp ;
        int weight[5];
        int sum = 0 ;
	int totalError[5] ;
	float cons ;

	for (i=0; i<nNeighbours; i++) {
		totalError[i] = abs(rxStatistics[i].nbSlotOffset *(uint8_t)SLOT_TIME + rxStatistics[i].phaseError );	
		if(totalError[i] < 9)
			cons = 0.8 ;
		else if(totalError[i] < 18)
			cons = 0.3 ;		
		else if(totalError[i] < 27)
			cons = 0.1;
		else 
			cons = 0.5;
		totalError[i]= totalError[i] * cons ;

        	sum = sum + totalError[i] ;
        }
               
        temp = sum * (nNeighbours - 1) ;
	for (i=0; i<nNeighbours; i++) {
		if (temp !=0)
        		weight[i] = (sum - totalError[i]) / temp ;
		else 
	    		weight[i] = 0 ;
	
        	maxx = maxx + (totalError[i] * weight[i]) ;
        }
	
	phaseError = maxx%SLOT_TIME;
	slotError  = maxx/SLOT_TIME;
 	cli();
        gMacFrame.lastFrameSlot = slotError + TOTAL_FRAME_SLOTS - 1;
        gMacFrame.phaseError = phaseError;
        gMacFrame.syncState = DO_PHASE_SYNC;
        sei();
               
#endif
        

#ifdef CURVE_FITTING

// Application of CURVE_FITTING 

#ifdef MC_DEBUG_PRINT_SYNC
        dbgPrintStr("\n NONLINEAR CURVE FITTING");
#endif
	       int sum =0 ;
	       int sumsq = 0 ;
	       int sumprod = 0 ;
	       int sumy = 0;
               int cmp = 1 ;
	       int k ;
	       int totalError[10] ;
               for(k=0 ; k<nNeighbours ; k++){
		       totalError[k] = rxStatistics[i].nbSlotOffset *(uint8_t)SLOT_TIME + rxStatistics[i].phaseError ;
		       sumy += (totalError[k] + 1);
                       sum += 0.4*k;
                       sumsq += 0.16*k*k;
                       sumprod += (totalError[k]+cmp) * 0.4*k;   
               }          
               int b = (nNeighbours*sumprod - sumy*sum)/(nNeighbours*sumsq - (sum*sum));
               int a = (sumy - b*sum) / nNeighbours ;
               int temp = a + b*0.4*(nNeighbours/2) ;
	       phaseError =  temp%SLOT_TIME;
	       slotError = temp/SLOT_TIME;
 	       cli();
               gMacFrame.lastFrameSlot = slotError + TOTAL_FRAME_SLOTS - 1;
               gMacFrame.phaseError = phaseError;
               gMacFrame.syncState = DO_PHASE_SYNC;
               sei();	
#endif 
	
	mcClearDebugSignal5();    

#ifdef MC_DEBUG_PRINT_SYNC
            dbgPrintStr(" #");
            dbgPrintHex(nNeighbours);
            dbgPrintChar('.');
            dbgPrintHex2(gMacFrame.phaseError);
            dbgPrintChar('.');
            dbgPrintHex2(slotError);
            dbgPrintChar('.');
            dbgPrintHex4(gMacFrame.lastFrameSlot);
            dbgPrintChar(' ');
#endif
#ifdef MC_DEBUG_PRINT_SYNC
        dbgPrintStr("\nS ");
        for (i=0; i<nNeighbours; i++) {
            dbgPrintStr(" r:");
            dbgPrintHex4(rxStatistics[i].myRxSlot);
            dbgPrintStr(" t:");
            dbgPrintHex4(rxStatistics[i].nbTxSlot);
            dbgPrintStr(" o:");
            dbgPrintHex4(rxStatistics[i].nbSlotOffset);
            dbgPrintStr(" p:");
            dbgPrintHex4(rxStatistics[i].phaseError);
            dbgPrintStr("\n  ");
        }
#endif
        return;
    }
}

