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
        if (gMacFrame.syncState == NETWORK_CATCH) mcUartPutChar('C');
        else if (gMacFrame.syncState == NETWORK_CATCHED) mcUartPutChar('d');
        else if (gMacFrame.syncState == DO_PHASE_SYNC) mcUartPutChar('?');
#endif
        return;
    }
#ifdef __MEDIAN__   
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
                mcSetDebugSignal5();
                sei();
#ifdef MC_DEBUG_PRINT_SYNC
                mcUartPutStr("\nFound Network, r:");
                mcUartPutHex4(rxStatistics[i].myRxSlot);
                mcUartPutStr(" t:");
                mcUartPutHex4(rxStatistics[i].nbTxSlot);
                mcUartPutStr(" p:");
                mcUartPutHex4(gMacFrame.phaseError);
                mcUartPutStr(" s:");
                mcUartPutHex4(slotError);
                mcUartPutStr(" f:");
                mcUartPutHex4(gMacFrame.lastFrameSlot);
#endif
                mcClearDebugSignal5();        
                return;
            }
        }

        // Here I'm in the normal slot synchronization mode:
        if (nNeighbours <= 2) {
            // I have just one or two neighbours. Use the phase information of the first one:
            phaseError = rxStatistics[0].phaseError;
            slotError  = rxStatistics[0].nbSlotOffset;
        }
        else {
            // There are more than two neighbours.
            // Now do a bubble sort of the slot and phase shifts:
            for (i = 1; i < nNeighbours; i++) {
                for (n = nNeighbours-1; n >= i; n--) {
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
            mcUartPutHex(nNeighbours);
            mcUartPutHex2(gMacFrame.phaseError);
            mcUartPutChar(' ');
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
            mcSetDebugSignal5();
            sei();
#ifdef MC_DEBUG_PRINT_SYNC
            mcUartPutStr(" #");
            mcUartPutHex(nNeighbours);
            mcUartPutChar('.');
            mcUartPutHex2(gMacFrame.phaseError);
            mcUartPutChar('.');
            mcUartPutHex2(slotError);
            mcUartPutChar('.');
            mcUartPutHex4(gMacFrame.lastFrameSlot);
            mcUartPutChar(' ');
#endif
        }
#endif __MEDIAN
#ifdef KALMAN_FILTER
		for (i = 0; i < nNeighbours; i++) {
                	for (n = nNeighbours-1; n >= i; n--) {
                    		if ((rxStatistics[n-1].nbSlotOffset > rxStatistics[n].nbSlotOffset) ||
                        		((rxStatistics[n-1].nbSlotOffset == rxStatistics[n].nbSlotOffset) &&
                         	(rxStatistics[n-1].phaseError > rxStatistics[n].phaseError))) {
                        	tmp = rxStatistics[n];
                        	rxStatistics[n] = rxStatistics[n-1];  // Flip elements
                        	rxStatistics[n-1] = tmp;
                    	}
                	}
            	}
		int totalError ; 
		int x; // estimated value of the variable to be considered 
		int phi ; // prediction factor 
		int R;  // noise covariance
		int P;  // error covariance 
		int Ka;  // Kalman gain 
		int Q;  // noise covariance  

		// Initialize the matrices 

		x = 0 ; // Initial estimate 
		P = 1 ;          // Initial estimate of covariance matrix - error covariance matrix
		Q = 10;          // covariance matrix - 
		R = 1 ;
		H = 1;
		phi = 5/4;

		// Loop 

		for(int i=0;i<nNeighbours;i++){
			
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
			phaseError =  x%SLOT_TIME;
			nSlotoffset = x/SLOT_TIME;
 	    cli();
            gMacFrame.lastFrameSlot = nslotoffset + TOTAL_FRAME_SLOTS - 1;
            gMacFrame.phaseError = phaseError;
            gMacFrame.syncState = DO_PHASE_SYNC;
            mcSetDebugSignal5();
            sei();
#endif 
#ifdef WEIGHTED_MEASURMENTS
		int maxx ;
		int temp ;
                int weight[5];
                int tempp[5] ;
                int sum = 0 ;

		for(int i=0;i<nNeighbours;i++){
			totalError[i] = rxStatistics[i].nbSlotOffset *(uint8_t)SLOT_TIME + rxStatistics[i].phaseError ;			
                        tempp[i] = abs(totalError);
                        sum = sum + tempp[i] ;
                }
               
                temp  =  sum * (nNeighbours - 1) ;
		for(int i=0;i<nNeighbours;i++){
			if(fasika !=0)
                         weight[i] = (sum - 0.9 * tempp[i]) / fasika ;
			else 
			 weight[i] = 0 ;

                         maxx = maxx + (totalError[i] * weight[i]) ;
                }
		phaseError =  maxx%SLOT_TIME;
		nSlotoffset = maxx/SLOT_TIME;
 		cli();
            	gMacFrame.lastFrameSlot = nSlotoffset + TOTAL_FRAME_SLOTS - 1;
            	gMacFrame.phaseError = phaseError;
            	gMacFrame.syncState = DO_PHASE_SYNC;
            	mcSetDebugSignal5();
            	sei();
                }
#endif
#ifdef CURVE_FITTING

	       int a,b,sum,sumsq,sumprod,sumprodsum,sumy,temp = 0;
               for(int k=0 ; k<nNeighbours ; k++){
		       totalError[i] = rxStatistics[i].nbSlotOffset *(uint8_t)SLOT_TIME + rxStatistics[i].phaseError ;
		       sumy += (totalError[k] + 1);
                       sum += log(k+1);
                       sumsq += pow(log(k+1),2);
                       sumprod += (totalError[k]+cmp) * log(k+1);   
               }
               for(int k=0;k<nNeighbours;k++){
                       sumprodsum += (totalError[k] + cmp)*sum ;
               }
               b = (count*sumprod - sumy*sum)/(count*sumsq - (sum*sum));
               a = (sumy - b*sum) / count ;
               temp = a + b*log((double)count/2) ;
	       phaseError =  temp%SLOT_TIME;
	       nSlotoffset = temp/SLOT_TIME;
 	       cli();
               gMacFrame.lastFrameSlot = nSlotoffset + TOTAL_FRAME_SLOTS - 1;
               gMacFrame.phaseError = phaseError;
               gMacFrame.syncState = DO_PHASE_SYNC;
               mcSetDebugSignal5();
               sei();	
#endif CURVE_FITTING
#ifdef MC_DEBUG_PRINT_SYNC
        mcUartPutStr("\nS ");
        for (i=0; i<nNeighbours; i++) {
            mcUartPutStr(" r:");
            mcUartPutHex4(rxStatistics[i].myRxSlot);
            mcUartPutStr(" t:");
            mcUartPutHex4(rxStatistics[i].nbTxSlot);
            mcUartPutStr(" o:");
            mcUartPutHex4(rxStatistics[i].nbSlotOffset);
            mcUartPutStr(" p:");
            mcUartPutHex4(rxStatistics[i].phaseError);
            mcUartPutStr("\n  ");
        }
#endif

        mcClearDebugSignal5();        
        return;
    }
}

