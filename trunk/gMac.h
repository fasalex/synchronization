/*
 ****************************************************************************************************
 *           Copyright (C)  2007 Chess, Haarlem, the Netherlands.  All rights reserved.             *
 ****************************************************************************************************
 *
 * Version: $Id: gMac.h,v 1.12 2008/04/24 15:59:57 frits Exp $
 *
 */

#ifndef GMAC_H_
#define GMAC_H_


/* This file has been prepared for Doxygen automatic documentation generation.*/
/*! \file *********************************************************************
 *
 * \brief
 *      Configuration constants and data structure definitions
 *
 * \author
 *      Chess B.V. - Innovation Team
 *
 ******************************************************************************/

/**
 * \defgroup gMacGroup gMac parameters and definitions
 */



//! @{

//!constant to compute number of Clockticks on a 32khz crystal from a time in uS
#define Us2Cycles           0.032768
//!Time which indicates how much larger the RXwindows is compared to the TXwindow.
//!This is to catch phase errors.
#define FRAME_TIME         (int)300
#define GUARD_TIME          ((int)(300 * Us2Cycles))
//!Time it takes to put the radio on, expressed in us
#define Tstby2a             130
/** Time it takes for the radio to transmit a message, expressed in us.
 *  Here I assume an address field of 3 bytes and a 2 byte CRC */
#define TimeOnAir           ((8 * (1 + 3 + 2) + 9) / 10)
//! Time where the Transmission is started.
#define TIME2TX             GUARD_TIME
//! Time needed to turn the radio into Tx Mode. (Tx command via SPI-bus)
#define TIME_TXON           3
//! Time before the radio is turned into Tx Mode.
#define TIME2TXON           (TIME2TX - TIME_TXON)
//! The time it takes for a complete transmission, including standby to active time:
#define TIME_TX             ((int)((Tstby2a+TimeOnAir)*Us2Cycles) + 1)
//! The time from TX burst until the end of the time slot.
#define TIME_TX2END         (TIME_TX + GUARD_TIME)
//! Time to the end of a time slot. Used by idle slots.
#define SLOT_TIME           (GUARD_TIME + TIME_TX + GUARD_TIME)
//!Time to turn the radio from standby to active
#define TIME2A              ((int)((Tstby2a*Us2Cycles) + 1))
/** Processing Pipe-line delay, expressed in clock cycles.
 *  It takes one clock to process the OCR2A Timer interrupt! */
#define EVENT_PL_DLY 1
/*!
 * Time needed to Process the Radio read message interrupt.
 * This is including the transfer from the Nordic Radio FIFO into our software FIFO.
 * The time is measured with an oscilloscope.
 */
#define TIME_RX_INT ((int)((275 * Us2Cycles) + 1))

//! The total number of slots winthin a time frame
#define TOTAL_FRAME_SLOTS  ((int)(FRAME_TIME / (SLOT_TIME / Us2Cycles)))
/*!
 * Compute the number of slots needed for the Radio from Power-Down to Standby.
 * The value from the datasheet of the nRF24L01 is 1500us.
 * The complicated *10, +9 operations are made to round the floating point number
 */
#define SLOTS_PD2STBY   ((int)(((1500 *10 *Us2Cycles) / SLOT_TIME + 9)/10))
/*!
 * The maximum number of IDLE slots that I can jump. This computation is done
 * for the AVR mega645 chips, where the async timer is set to no prescaler.
 * The timer is 8-bit, so numeric range is 256!
 * We take the floor of the function.
 */
#define MAX_IDLE_SLOTS    ((int) ((256 *10 / SLOT_TIME +9)/10 -1))

/*!
 * \brief Semaphore structure
 *
 * This structure holds all common MyriaCore semaphores
 */
struct Semaphore {
    char gMacFinished;      //!< Set by gMac, Cleared at completion of application */
    char txMsgAvailable;    //!< Set by the application, Cleared by gMac  */
};
typedef struct Semaphore Semaphore;  //!< Semaphore type definition

/*!
 * \struct Frame
 *
 * Frame structure holds informations about the current slot number,
 * tx slot number, receive slots, frame length, synchronisation parameters, etc.
 */
struct Frame {
    int  randomNumber;          //!< Computed once per frame
    int  currentSlotNumber;     //!< Current Time Slot value
    int  txSlot;                //!< My current Tx Slot
    int  neighbourTxSlot;       //!< Current Tx Slot of neighbour that I currenty receive
    int  syncTxSlot;            //!< Random slot to sent join message
    int  firstRxSlot;           //!< First Rx Slot to listen in
    int  lastRxSlot;            //!< Last Rx Slot to listen in
    int  lastTdmaSlot;          //!< Last possible active TDMA slot
    int  lastFrameSlot;         //!< Last possible slot in a frame
    int  phaseError;            //!< Calculated Phase error for this frame
    int  searchFrames;          //!< Frame counter while doing a network Search
    unsigned char slotPhaseRef; //!< Timer value at start of current slot
    char emptySchedules;        //!< Number of schedules without a valid reception
    char radionRxOn;            //!< 1=Radio is in listen mode, 0=Not
    char readRadioLock;         //!< 1= Read FIFO from Radio is in progress, 0= Idle
    unsigned char slotUsage;    //!< Bit mask of slots beeing used in current schedule
    unsigned char numRxMsg;     //!< Number of messages received in one schedule
//! \enum Tsync Possible synchronization states
    enum Tsync {
        NETWORK_CATCH,    //!< The node searches a network: the RX window is constantly open
        NETWORK_CATCHED,  //!< Found a network: Go synchronize to it
        NETWORK_SEARCH,   //!< The node searches a network: the RX window is open shortly
        SYNCHRONIZED,     //!< The node is synchronized
        DO_PHASE_SYNC     //!< The node needs to be synchronized
    } syncState;          //!< Synchronization State
};
typedef struct Frame Frame;  //!< Type definition of gMac Frame structure


/*!
 * \struct NextFrame
 *
 * Next Frame structure holds informations about the next Frame
 * At the start of a new frame the information of the NextFrame
 * will be used in the current Frame
 */
struct NextFrame {
    int  firstRxSlot;           //!< First Rx Slot to listen in
    int  lastRxSlot;            //!< Last Rx Slot to listen in
    int  txSlot;                //!< My current Tx Slot
    int  lastTdmaSlot;          //!< Last possible active TDMA slot
    int  syncTxSlot;            //!< Random slot to sent join message
};
typedef struct NextFrame NextFrame;  //!< Type definition of gMac NextFrame structure


//! \enum TmacStates gMac FSM state definitions
    enum TmacStates {
        NEXT_SLOT,        //!< gMac will enter next slot
        PRE_TDMA_SLOT,    //!< Setup-up TDMA schedule
        PRE_RX_STATE,     //!< Slot in which the radio is going to be turned on
        RX_ON_STATE,      //!< State in which the radio is actually turned on
        RX_SLOT,          //!< RX window is open
        POST_RX_STATE,    //!< RX window closed in front of a Tx-slot
        LD_TX_STATE,      //!< State in which the Radio is loaded with transmit data
        TX_ON_STATE,      //!< State in which the Radio is set in Tx-mode
        PRE_TX_STATE,     //!< pre Tx period
        TX_STATE,         //!< active Transmission
        POST_TDMA_SLOT1,  //!< Finish-up TDMA schedule, while processing a last read message
        POST_TDMA_SLOT2,  //!< Finish-up TDMA schedule, white starting the application process
        IDLE_SLOT,        //!< Idle slot in a TDMA schedule
        IDLE_STATE,       //!< Idle period in a frame
        CATCH_SLOT,       //!< Slot with Rx open to catch a network
        SYNC_SLOT         //!< Synchronize slot to neighbour
    } gMacStates;         //!< gMac state-machine states


/** \struct rxStatsStruct 
 *  This structure describes the statics of the received messages.
 *  This is used by the phase and slot gMacynchronize() function,
 *  as well as the gMacStrategy() function
 */
struct rxStatsStruct {
    int nbTxSlot;      //!< The transmit slot of my Neighbour
    int myRxSlot;      //!< My receive slot
    int nbSlotOffset;  //!< The slot offset of my Neighbour that he was transmitting in (should be zero)
    int phaseError;    //!< The phase error that I measured
    unsigned char nbSlotUsage; //!< Bit map of slots of my neighbour that are in use 
};
typedef struct rxStatsStruct rxStatsStruct; //!< Type definition of the rxStatsStruct structure


/**
 * Initialize the MAC layer
 */
void gMacInit(void);


/*! \brief Gmac FSM entry point.
*
*	Contains the basic structure of the MAC protocol.
* It is called from the Timer-2 interrupt routine.
* This procedure cannot be interrupted!!!
*/
void gMacFsm(void);


/*! \brief Radio Receive Service Routine
 *
 * This function gets called when a Radio Receive interrupt occurs.
 * The only thing it does in interrupt context is capturing the timing
 * information of the precise occurance of this read-message event.
 * The actual processing of the timing and phase information is done
 * outside interrupt context. There the message is read from the Radio
 * FIFO too. See the "gmacProcessRxMessage" procedure below!
 */
void gMacRadioIntService(void);



/*! \brief Initialize the TDMA strategy.
*
* This function is called only once at initialisation time
* as part of the gMacInit() function. It will setup the initial
* TDMA strategy with which the MAC will try to find a network
* and then join it
*/
void gMacTdmaInit(void);



/*! \brief Setup a new TDMA strategy.
*
* Calculate a new TDMA schedule.
* This is a call-back procedure from the MyriaCore scheduler,
* that calls the Gmac here to setup a possible new schedule for the TDMA.
* Things that are decided are: 
* Tx slot allocation, Active read slots, length of active period, etc.
* 
* NOTE:
* This function can be interrupted by a Timer-2 interrupt, which in turn changes
* the state of the gMac FSM.
* Please keep this in mind when altering the parameters of the gMac!!!
* Therefore the "syncTxSlot" calculation is done first,
* because it could be the next slot!
*/
void gMacTdmaStrategy(void);


/*!
 *  \brief perform slot and phase synchronization algorithm.
 */
void gMacSynchronize(void);

//! @}

#endif /*GMAC_H_*/
