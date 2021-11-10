; usb_dev.asm
; 10/07/08 microEngineering Labs, Inc.

	include	"usb_dev.inc"	; Include our header file
	include	"usb_mem.asm"	; Include memory allocation

;/********************************************************************
; FileName:     	usb_device.c
; Dependencies:	See INCLUDES section
; Processor:		PIC18 or PIC24 USB Microcontrollers
; Hardware:		The code is natively intended to be used on the following
; 				hardware platforms: PICDEM™ FS USB Demo Board, 
; 				PIC18F87J50 FS USB Plug-In Module, or
; 				Explorer 16 + PIC24 USB PIM.  The firmware may be
; 				modified for use on other USB platforms by editing the
; 				HardwareProfile.h file.
; Complier:  	Microchip C18 (for PIC18) or C30 (for PIC24)
; Company:		Microchip Technology, Inc.
;
; Software License Agreement:
;
; The software supplied herewith by Microchip Technology Incorporated
; (the “Company”) for its PIC® Microcontroller is intended and
; supplied to you, the Company’s customer, for use solely and
; exclusively on Microchip PIC Microcontroller products. The
; software is owned by the Company and/or its supplier, and is
; protected under applicable copyright laws. All rights are reserved.
; Any use in violation of the foregoing restrictions may subject the
; user to criminal sanctions under applicable laws, as well as to
; civil liability for the breach of the terms and conditions of this
; license.

; THIS SOFTWARE IS PROVIDED IN AN “AS IS” CONDITION. NO WARRANTIES,
; WHETHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT NOT LIMITED
; TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
; PARTICULAR PURPOSE APPLY TO THIS SOFTWARE. THE COMPANY SHALL NOT,
; IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL OR
; CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.

;********************************************************************/

;/** INCLUDES *******************************************************/
;#include "GenericTypeDefs.h"
;#include "Compiler.h"
;#include "./USB/usb_ch9.h"
;#include "./USB/USB.h"
;#include "./USB/usb_device.h"
;#include "HardwareProfile.h"
;#include "usb_config.h"

;#if defined(USB_USE_MSD)
;    #include "./USB/usb_function_msd.h"
;#endif

;/** VARIABLES ******************************************************/
;#pragma udata

;USB_VOLATILE BYTE USBDeviceState;
;USB_VOLATILE BYTE USBActiveConfiguration;
;USB_VOLATILE BYTE USBAlternateInterface[USB_MAX_NUM_INT];
;volatile BDT_ENTRY *pBDTEntryEP0OutCurrent;
;volatile BDT_ENTRY *pBDTEntryEP0OutNext;
;volatile BDT_ENTRY *pBDTEntryOut[USB_MAX_EP_NUMBER+1];
;volatile BDT_ENTRY *pBDTEntryIn[USB_MAX_EP_NUMBER+1];
;USB_VOLATILE BYTE shortPacketStatus;
;USB_VOLATILE BYTE controlTransferState;
;USB_VOLATILE IN_PIPE inPipes[1];
;USB_VOLATILE OUT_PIPE outPipes[1];
;USB_VOLATILE BYTE *pDst;
;USB_VOLATILE BOOL RemoteWakeup;
;USB_VOLATILE BYTE USTATcopy;
;USB_VOLATILE WORD USBInMaxPacketSize[USB_MAX_EP_NUMBER]; 
;USB_VOLATILE BYTE *USBInData[USB_MAX_EP_NUMBER];

;/** USB FIXED LOCATION VARIABLES ***********************************/
;#if defined(__18CXX)
;    #if defined(__18F14K50) || defined(__18F13K50) || defined(__18LF14K50) || defined(__18LF13K50)
;        #pragma udata USB_BDT=0x200     //See Linker Script,usb2:0x200-0x2FF(256-byte)
;    #else
;        #pragma udata USB_BDT=0x400     //See Linker Script,usb4:0x400-0x4FF(256-byte)
;    #endif
;#endif

;/********************************************************************
; * Section A: Buffer Descriptor Table
; * - 0x400 - 0x4FF(max)
; * - USB_MAX_EP_NUMBER is defined in usb_config.h
; *******************************************************************/
;#if (USB_PING_PONG_MODE == USB_PING_PONG__NO_PING_PONG)
;    volatile BDT_ENTRY BDT[(USB_MAX_EP_NUMBER + 1) * 2] __attribute__ ((aligned (512)));
;#elif (USB_PING_PONG_MODE == USB_PING_PONG__EP0_OUT_ONLY)
;    volatile BDT_ENTRY BDT[((USB_MAX_EP_NUMBER + 1) * 2)+1] __attribute__ ((aligned (512)));
;#elif (USB_PING_PONG_MODE == USB_PING_PONG__FULL_PING_PONG)
;    volatile BDT_ENTRY BDT[(USB_MAX_EP_NUMBER + 1) * 4] __attribute__ ((aligned (512)));
;#elif (USB_PING_PONG_MODE == USB_PING_PONG__ALL_BUT_EP0)
;    volatile BDT_ENTRY BDT[((USB_MAX_EP_NUMBER + 1) * 4)-2] __attribute__ ((aligned (512)));
;#else
;    #error "No ping pong mode defined."
;#endif

;//#if defined(__18CXX)
;//#pragma udata usbram5=0x400     //See Linker Script,usb5:0x500-0x5FF(256-byte)
;//#endif

;/********************************************************************
; * Section B: EP0 Buffer Space
; *******************************************************************/
;volatile CTRL_TRF_SETUP SetupPkt;           // 8-byte only
;volatile BYTE CtrlTrfData[USB_EP0_BUFF_SIZE];

;/********************************************************************
; * Section C: non-EP0 Buffer Space
; *******************************************************************/
;// Can provide compile time option to do software pingpong
;#if defined(USB_USE_HID)
;volatile unsigned char hid_report_out[HID_INT_OUT_EP_SIZE];
;volatile unsigned char hid_report_in[HID_INT_IN_EP_SIZE];
;#endif

;#if defined(USB_USE_MSD)
;	//volatile far USB_MSD_CBW_CSW msd_cbw_csw;
;	volatile USB_MSD_CBW msd_cbw;
;	volatile USB_MSD_CSW msd_csw;
;	//#pragma udata

;	#if defined(__18CXX)
;		#pragma udata myMSD=MSD_BUFFER_ADDRESS
;	#endif
;	volatile char msd_buffer[512];
;#endif

;#if defined(__18CXX)
;#pragma udata
;#endif

;/** DECLARATIONS ***************************************************/
;#pragma code

; Put Address into source pointer
mSetSourcePointer macro Address
	movlw	low (Address)
	movwf	pSrc
	movlw	high (Address)
	movwf	pSrc + 1
	movlw	upper (Address)
	movwf	pSrc + 2
	endm

; Put Address into destination pointer
mSetDestinationPointer macro Address
	movlw	low (Address)
	movwf	pDst
	movlw	high (Address)
	movwf	pDst + 1
	endm

; Get count from first location of ROM table pointed to by pSrc
mGetRomTableCount macro
	movff	pSrc, TBLPTRL		; Set source address
	movff	pSrc + 1, TBLPTRH
	movff	pSrc + 2, TBLPTRU
        tblrd   *			; Read count
	movff	TABLAT, inCount
	clrf	inCount + 1
	endm

;//DOM-IGNORE-BEGIN
;/****************************************************************************
;  Function:
;    void USBDeviceInit(void)

;  Description:
;    This function initializes the device stack
;    it in the default state

;  Precondition:
;    None

;  Parameters:
;    None

;  Return Values:
;    None

;  Remarks:
;    The USB module will be completely reset including
;    all of the internal variables, registers, and
;    interrupt flags.
;  ***************************************************************************/
;//DOM-IGNORE-END
;void USBDeviceInit(void)
USBDeviceInit
;{
;    BYTE i;

;    // Clear all USB error flags
;    USBClearInterruptRegister(U1EIR);
#if (UEIR < 0xf60)
	BANKSEL	UEIR
#endif
	clrf	UEIR			; Clear all USB error flags

;    // Clears all USB interrupts     
;    USBClearInterruptRegister(U1IR);
	clrf	UIR			; Clear all USB interrupts

;    U1EIE = 0x9F;                   // Unmask all USB error interrupts
#if (UEIE < 0xf60)
	BANKSEL	UEIE
#endif
	movlw	0x9f			; Unmask all USB error interrupts
	movwf	UEIE
;    U1IE = 0xFB;                    // Enable all interrupts except ACTVIE
;#if (UIE < 0xf60)
;	BANKSEL	UIE
;#endif
	movlw	0xfb			; Enable all interrupts except ACTVIE
	movwf	UIE

;    //power up the module
;    USBPowerModule();
;	rcall	USBPowerModule		; Does nothing

;    //set the address of the BDT (if applicable)
;    USBSetBDTAddress(BDT);
;	rcall	USBSetBDTAddress	; Does nothing

;    // Reset all of the Ping Pong buffers
;    USBPingPongBufferReset = 1;
;	bsf	USBPingPongBufferReset
;    USBPingPongBufferReset = 0;
;	bcf	USBPingPongBufferReset

;    // Reset to default address
;    U1ADDR = 0x00;
;#if (UADDR < 0xf60)
;	BANKSEL	UADDR
;#endif
	clrf	UADDR			; Reset to default address

;    //Clear all of the endpoint control registers
;    memset((void*)&U1EP1,0x00,(USB_MAX_EP_NUMBER-1));
	lfsr	2, UEP1			; Clear all of the endpoint control registers
	movlw	USB_MAX_EP_NUMBER
USBDeviceInitEPLoop
	clrf	POSTINC2
	decfsz	WREG, F
	bra	USBDeviceInitEPLoop

;    //Clear all of the BDT entries
;    for(i=0;i<(sizeof(BDT)/sizeof(BDT_ENTRY));i++)
;    {
;        BDT[i].Val = 0x00;
;    }

;    // Initialize EP0 as a Ctrl EP
;    U1EP0 = EP_CTRL|USB_HANDSHAKE_ENABLED;
;#if (UEP0 < 0xf60)
;	BANKSEL	UEP0
;#endif
	movlw	EP_CTRL|USB_HANDSHAKE_ENABLED	; Initialize EP0 as a Ctrl EP
	movwf	UEP0

;    // Flush any pending transactions
;    while(USBTransactionCompleteIF == 1)
;    {
;        USBClearInterruptFlag(USBTransactionCompleteIFReg,USBTransactionCompleteIFBitNum);
;    }
	bra	USBDeviceInitFlush1	; Simulate while
USBDeviceInitFlushLoop
	bcf	UIR, TRNIF		; Flush any pending transactions
	nop
	nop
	nop
	nop
	nop
	nop
USBDeviceInitFlush1
	btfsc	UIR, TRNIF
	bra	USBDeviceInitFlushLoop

;    //clear all of the internal pipe information
;    inPipes[0].info.Val = 0;
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	clrf	info
;    outPipes[0].info.Val = 0;
	clrf	outfo
;    outPipes[0].wCount.Val = 0;
	clrf	outCount
	clrf	outCount + 1

	clrf	RemoteWakeup

;    // Make sure packet processing is enabled
;    USBPacketDisable = 0;
	bcf	UCON, PKTDIS		; Make sure packet processing is enabled

;    //Get ready for the first packet
;    pBDTEntryIn[0] = (volatile BDT_ENTRY*)&BDT[EP0_IN_EVEN];

;    // Clear active configuration
;    USBActiveConfiguration = 0;
	clrf	USBActiveConfiguration	; Clear active configuration

;    //Indicate that we are now in the detached state
;    USBDeviceState = DETACHED_STATE;
	movlw	DETACHED_STATE		; Indicate that we are now in the detached state
  	movwf	USBDeviceState
	return
;}

;//DOM-IGNORE-BEGIN
;/****************************************************************************
;  Function:
;    void USBDeviceTasks(void)

;  Description:
;    This function is the main state machine of the 
;    USB device side stack.  This function should be
;    called periodically to receive and transmit
;    packets through the stack.  This function should
;    be called  preferably once every 100us 
;    during the enumeration process.  After the
;    enumeration process this function still needs to
;    be called periodically to respond to various
;    situations on the bus but is more relaxed in its
;    time requirements.  This function should also
;    be called at least as fast as the OUT data
;    expected from the PC.

;  Precondition:
;    None

;  Parameters:
;    None

;  Return Values:
;    None

;  Remarks:
;    None
;  ***************************************************************************/
;//DOM-IGNORE-END
;void USBDeviceTasks(void)
USBDeviceTasks
;{
;	BYTE i;

	movlb	high _USBMEMORYADDRESS	; Point to proper bank
#ifdef USE_USB_BUS_SENSE_IO
;    //If we aren't attached to the bus
;    if(USB_BUS_SENSE != 1)
	btfsc	USB_BUS_SENSE		; If we aren't attached to the bus
	bra	USBDeviceTasksCheckDetached
;    {
;        // Disable module & detach from bus
;        U1CON = 0;
	clrf	UCON			; Disable module & detach from bus

;        // Mask all USB interrupts
;        U1IE = 0;
#if (UIE < 0xf60)
	BANKSEL	UIE
#endif
	clrf	UIE			; Mask all USB interrupts

;        //Move to the detached state
;        USBDeviceState = DETACHED_STATE;
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movlw	DETACHED_STATE		; Move to the detached state
	movwf	USBDeviceState

;        //return so that we don't go through the rest of 
;        //the state machine
;        return;
	return				; Return so that we don't go through the rest of the state machine
;    }
#endif

USBDeviceTasksCheckDetached
;    //if we are in the detached state
;    if(USBDeviceState == DETACHED_STATE)
	movlw	DETACHED_STATE
	cpfseq	USBDeviceState
	bra	USBDeviceTasksCheckAttached
;    {
;        //#if defined(__18CXX)
;            U1CON = 0;                           // Disable module & detach from bus
	clrf	UCON			; Disable module & detach from bus
;        //#else
;        //#endif

;        // Mask all USB interrupts
;        U1IE = 0;
#if (UIE < 0xf60)
	BANKSEL	UIE
#endif
	clrf	UIE			; Mask all USB interrupts

;        // Enable module & attach to bus
;        while(!U1CONbits.USBEN){U1CONbits.USBEN = 1;}
USBDeviceTasksCDLoop
	bsf	UCON, USBEN		; Enable module & attach to bus
	btfss	UCON, USBEN
	bra	USBDeviceTasksCDLoop

;        //moved to the attached state
;        USBDeviceState = ATTACHED_STATE;
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movlw	ATTACHED_STATE
	movwf	USBDeviceState

;        //Enable/set things like: pull ups, full/low-speed mode,
;        //set the ping pong mode, and set internal transceiver
;        SetConfigurationOptions();
#if (UCFG < 0xf60)
	BANKSEL	UCFG
#endif
	movlw	UCFG_VAL		; Enable/set things like: pull ups, full/low-speed mode...
	movwf	UCFG
;    }

USBDeviceTasksCheckAttached
;    if(USBDeviceState == ATTACHED_STATE)
	movlw	ATTACHED_STATE
	cpfseq	USBDeviceState
	bra	USBDeviceTasksA
;    {
;        /*
;         * After enabling the USB module, it takes some time for the
;         * voltage on the D+ or D- line to rise high enough to get out
;         * of the SE0 condition. The USB Reset interrupt should not be
;         * unmasked until the SE0 condition is cleared. This helps
;         * prevent the firmware from misinterpreting this unique event
;         * as a USB bus reset from the USB host.
;         */

;        if(!USBSE0Event)
	btfsc	UCON, SE0
	bra	USBDeviceTasksA
;        {
;            USBClearInterruptRegister(U1IR);// Clear all USB interrupts
	clrf	UIR			; Clear all USB interrupts
;            U1IE=0;                        // Mask all USB interrupts
#if (UIE < 0xf60)
	BANKSEL	UIE
#endif
	clrf	UIE			; Mask all USB interrupts
;            USBResetIE = 1;             // Unmask RESET interrupt
	bsf	UIE, URSTIE		; Unmask RESET interrupt
;            USBIdleIE = 1;             // Unmask IDLE interrupt
	bsf	UIE, IDLEIE		; Unmask IDLE interrupt
;            USBDeviceState = POWERED_STATE;
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movlw	POWERED_STATE
	movwf	USBDeviceState
;        }
;    }

USBDeviceTasksA
;    /*
;     * Task A: Service USB Activity Interrupt
;     */
;    if(USBActivityIF && USBActivityIE)
	btfss	UIR, ACTVIF
	bra	USBDeviceTasks1
#if (UIE < 0xf60)
	BANKSEL	UIE
#endif
	btfsc	UIE, ACTVIE
;    {
;        USBWakeFromSuspend();
	rcall	USBWakeFromSuspend
;    }

USBDeviceTasks1
;    /*
;     * Pointless to continue servicing if the device is in suspend mode.
;     */
;    if(USBSuspendControl==1)
	btfsc	UCON, SUSPND		; Are we suspended?
;    {
;        return;
	return				; Pointless to continue servicing if the device is in suspend mode.
;    }

;    /*
;     * Task B: Service USB Bus Reset Interrupt.
;     * When bus reset is received during suspend, ACTVIF will be set first,
;     * once the UCONbits.SUSPND is clear, then the URSTIF bit will be asserted.
;     * This is why URSTIF is checked after ACTVIF.
;     *
;     * The USB reset flag is masked when the USB state is in
;     * DETACHED_STATE or ATTACHED_STATE, and therefore cannot
;     * cause a USB reset event during these two states.
;     */
;    if(USBResetIF && USBResetIE)
	btfss	UIR, URSTIF		; USB Bus Reset Interrupt?
	bra	USBDeviceTasks2
#if (UIE < 0xf60)
	BANKSEL	UIE
#endif
	btfss	UIE, URSTIE
	bra	USBDeviceTasks2
;    {
;        USBDeviceInit();
	rcall	USBDeviceInit
;        USBDeviceState = DEFAULT_STATE;
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movlw	DEFAULT_STATE
  	movwf	USBDeviceState

;        /********************************************************************
;        Bug Fix: Feb 26, 2007 v2.1 (#F1)
;        *********************************************************************
;        In the original firmware, if an OUT token is sent by the host
;        before a SETUP token is sent, the firmware would respond with an ACK.
;        This is not a correct response, the firmware should have sent a STALL.
;        This is a minor non-compliance since a compliant host should not
;        send an OUT before sending a SETUP token. The fix allows a SETUP
;        transaction to be accepted while stalling OUT transactions.
;        ********************************************************************/
;        BDT[EP0_OUT_EVEN].ADR = (BYTE*)&SetupPkt;
	movlw	low SetupPkt
	movwf	ep0Bo + ADRL
	movlw	high SetupPkt
	movwf	ep0Bo + ADRH
;        BDT[EP0_OUT_EVEN].CNT = USB_EP0_BUFF_SIZE;
	movlw	USB_EP0_BUFF_SIZE
	movwf	ep0Bo + Cnt
;        BDT[EP0_OUT_EVEN].STAT.Val &= ~_STAT_MASK;
;	movf	ep0Bo + Stat, W
;	andlw	~_STAT_MASK
;        BDT[EP0_OUT_EVEN].STAT.Val |= _USIE|_DAT0|_DTSEN|_BSTALL;
;	iorlw	_USIE|_DAT0|_DTSEN|_BSTALL
	movlw	_USIE|_DAT0|_DTSEN|_BSTALL
	movwf	ep0Bo + Stat
;    }

USBDeviceTasks2
;    /*
;     * Task C: Service other USB interrupts
;     */
;    if(USBIdleIF && USBIdleIE)
	btfss	UIR, IDLEIF
	bra	USBDeviceTasks3
#if (UIE < 0xf60)
	BANKSEL	UIE
#endif
	btfss	UIE, IDLEIE
	bra	USBDeviceTasks3
;    {
;        USBSuspend();
	rcall	USBSuspend
;        USBClearInterruptFlag(USBIdleIFReg,USBIdleIFBitNum);
	bcf	UIR, IDLEIF
;    }

USBDeviceTasks3
;    if(USBSOFIF && USBSOFIE)
	btfss	UIR, SOFIF
	bra	USBDeviceTasks4
#if (UIE < 0xf60)
	BANKSEL	UIE
#endif
	btfss	UIE, SOFIE
	bra	USBDeviceTasks4
;    {
;        USBCB_SOF_Handler();    // Required callback, see usbcallbacks.c
	rcall	USBCB_SOF_Handler
;        USBClearInterruptFlag(USBSOFIFReg,USBSOFIFBitNum);
	bcf	UIR, SOFIF
;    }

USBDeviceTasks4
 ;   if(USBStallIF && USBStallIE)
	btfss	UIR, STALLIF
	bra	USBDeviceTasks5
#if (UIE < 0xf60)
	BANKSEL	UIE
#endif
	btfsc	UIE, STALLIE
;    {
;        USBStallHandler();
	rcall	USBStallHandler
;    }

USBDeviceTasks5
;    if(USBErrorIF && USBErrorIE)
	btfss	UIR, UERRIF
	bra	USBDeviceTasks6
#if (UIE < 0xf60)
	BANKSEL	UIE
#endif
	btfss	UIE, UERRIE
	bra	USBDeviceTasks6
;    {
;        USBCBErrorHandler();    // Required callback, see usbcallbacks.c
	rcall	USBCBErrorHandler
;        USBClearInterruptRegister(U1EIR);               // This clears UERRIF
	clrf	UIR			; This clears UERRIF
;    }

USBDeviceTasks6
;    /*
;     * Pointless to continue servicing if the host has not sent a bus reset.
;     * Once bus reset is received, the device transitions into the DEFAULT
;     * state and is ready for communication.
;     */
;    if(USBDeviceState < DEFAULT_STATE) return;
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movlw	DEFAULT_STATE
	subwf	USBDeviceState, W
	bnc	USBDriverTasksExit

;    /*
;     * Task D: Servicing USB Transaction Complete Interrupt
;     */
;    if(USBTransactionCompleteIE)
#if (UIE < 0xf60)
	BANKSEL	UIE
#endif
	btfss	UIE, TRNIE
	return
;    {
;	    for(i = 0; i < 4; i++)	//Drain or deplete the USAT FIFO entries.  If the USB FIFO ever gets full, USB bandwidth 
;		{						//utilization can be compromised, and the device won't be able to receive SETUP packets.
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movlw	4			; Drain or deplete the USAT FIFO entries.  If the USB FIFO ever gets full, USB bandwidth
	movwf	bTRNIFCount		; utilization can be compromised, and the device won't be able to receive SETUP packets.
USBDeviceTasks7
;		    if(USBTransactionCompleteIF)
	btfss	UIR, TRNIF
	return
;		    {
;		        USTATcopy = U1STAT;
	movf	USTAT, W
	movwf	USTATcopy

;		        USBClearInterruptFlag(USBTransactionCompleteIFReg,USBTransactionCompleteIFBitNum);
	bcf	UIR, TRNIF

;		        /*
;		         * USBCtrlEPService only services transactions over EP0.
;		         * It ignores all other EP transactions.
;		         */
;		        USBCtrlEPService();
	rcall	USBCtrlEPService
;		    }//end if(USBTransactionCompleteIF)
;		    else
;		    	break;	//USTAT FIFO must be empty.
;		}//end for()
	decfsz	bTRNIFCount, F
	bra	USBDeviceTasks7
;	}//end if(USBTransactionCompleteIE)
USBDriverTasksExit
	return

;}//end of USBDeviceTasks()

;/********************************************************************
; * Function:        void USBStallHandler(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
;; * Side Effects:    
; *
; * Overview:        This function handles the event of a STALL 
; *                  occuring on the bus
; *
; * Note:            None
; *******************************************************************/
;void USBStallHandler(void)
USBStallHandler
;{
;    /*
;     * Does not really have to do anything here,
;     * even for the control endpoint.
;     * All BDs of Endpoint 0 are owned by SIE right now,
;     * but once a Setup Transaction is received, the ownership
;     * for EP0_OUT will be returned to CPU.
;     * When the Setup Transaction is serviced, the ownership
;     * for EP0_IN will then be forced back to CPU by firmware.
;     */
;
;    /* v2b fix */
;    if(U1EP0bits.EPSTALL == 1)
#if (UEP0 < 0xf60)
	BANKSEL	UEP0
#endif
	btfss	UEP0, EPSTALL
	bra	USBStallHandlerExit
;    {
;        // UOWN - if 0, owned by CPU, if 1, owned by SIE
;        if((pBDTEntryEP0OutCurrent->STAT.Val == _USIE) && (pBDTEntryIn[0]->STAT.Val == (_USIE|_BSTALL)))
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movlw	_USIE			; UOWN - if 0, owned by CPU, if 1, owned by SIE
	cpfseq	ep0Bo + Stat
	bra	USBStallHandlerExit
	movlw	_USIE|_BSTALL
	cpfseq	ep0Bi + Stat
	bra	USBStallHandlerExit
;        {
;            // Set ep0Bo to stall also
;            pBDTEntryEP0OutCurrent->STAT.Val = _USIE|_DAT0|_DTSEN|_BSTALL;
	movlw	_USIE|_DAT0|_DTSEN|_BSTALL	; Set ep0Bo to stall also
	movwf	ep0Bo + Stat
;        }//end if
;        U1EP0bits.EPSTALL = 0;               // Clear stall status
#if (UEP0 < 0xf60)
	BANKSEL	UEP0
#endif
	bcf	UEP0, EPSTALL		; Clear stall status
;    }//end if

USBStallHandlerExit
;    USBClearInterruptFlag(USBSTALLIFReg,USBSTALLIFBitNum);
	bcf	UIR, STALLIF
	return
;}

;/********************************************************************
; * Function:        void USBSuspend(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    
; *
; * Overview:        This function handles if the host tries to 
; *                  suspend the device
; *
; * Note:            None
; *******************************************************************/
;void USBSuspend(void)
USBSuspend
;{
;    /*
;     * NOTE: Do not clear UIRbits.ACTVIF here!
;     * Reason:
;     * ACTVIF is only generated once an IDLEIF has been generated.
;     * This is a 1:1 ratio interrupt generation.
;     * For every IDLEIF, there will be only one ACTVIF regardless of
;     * the number of subsequent bus transitions.
;     *
;     * If the ACTIF is cleared here, a problem could occur when:
;     * [       IDLE       ][bus activity ->
;     * <--- 3 ms ----->     ^
;     *                ^     ACTVIF=1
;     *                IDLEIF=1
;     *  #           #           #           #   (#=Program polling flags)
;     *                          ^
;     *                          This polling loop will see both
;     *                          IDLEIF=1 and ACTVIF=1.
;     *                          However, the program services IDLEIF first
;     *                          because ACTIVIE=0.
;     *                          If this routine clears the only ACTIVIF,
;     *                          then it can never get out of the suspend
;     *                          mode.
;     */
;    USBActivityIE = 1;                     // Enable bus activity interrupt
#if (UIE < 0xf60)
	BANKSEL	UIE
#endif
	bsf	UIE, ACTVIE		; Enable bus activity interrupt
;    USBClearInterruptFlag(USBIdleIFReg,USBIdleIFBitNum);
	bcf	UIR, IDLEIF

;#if defined(__18CXX)
;    U1CONbits.SUSPND = 1;                   // Put USB module in power conserve
	bsf	UCON, SUSPND		; Put USB module in power conserve
					; mode, SIE clock inactive
;#endif


;    /*
;     * At this point the PIC can go into sleep,idle, or
;     * switch to a slower clock, etc.  This should be done in the
;     * USBCBSuspend() if necessary.
;     */
;    USBCBSuspend();             // Required callback, see usbcallbacks.c
	bra	USBCBSuspend
;}

;/********************************************************************
; * Function:        void USBWakeFromSuspend(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:
; *
; * Note:            None
; *******************************************************************/
;void USBWakeFromSuspend(void)
USBWakeFromSuspend
;{
;    #if defined(__18CXX)
;    U1CONbits.SUSPND = 0;                   // Bring USB module out of power conserve
;                                            // mode.
	bcf	UCON, SUSPND		; Bring USB module out of power conserve mode
;    #endif

;    /*
;     * If using clock switching, the place to restore the original
;     * microcontroller core clock frequency is in the USBCBWakeFromSuspend() callback
;     */
;    USBCBWakeFromSuspend(); // Required callback, see usbcallbacks.c
	rcall	USBCBWakeFromSuspend

;    USBActivityIE = 0;
#if (UIE < 0xf60)
	BANKSEL	UIE
#endif
	bcf	UIE, ACTVIE

;    /********************************************************************
;    Bug Fix: Feb 26, 2007 v2.1
;    *********************************************************************
;    The ACTVIF bit cannot be cleared immediately after the USB module wakes
;    up from Suspend or while the USB module is suspended. A few clock cycles
;    are required to synchronize the internal hardware state machine before
;    the ACTIVIF bit can be cleared by firmware. Clearing the ACTVIF bit
;    before the internal hardware is synchronized may not have an effect on
;    the value of ACTVIF. Additonally, if the USB module uses the clock from
;    the 96 MHz PLL source, then after clearing the SUSPND bit, the USB
;    module may not be immediately operational while waiting for the 96 MHz
;    PLL to lock.
;    ********************************************************************/

;    // UIRbits.ACTVIF = 0;                      // Removed
;    #if defined(__18CXX)
;    while(USBActivityIF)
USBWakeFromSuspendLoop
	btfss	UIR, ACTVIF
	return
;    #endif
;    {
;        USBClearInterruptFlag(USBActivityIFReg,USBActivityIFBitNum);
	bcf	UIR, ACTVIF
;    }  // Added
	bra	USBWakeFromSuspendLoop

;}//end USBWakeFromSuspend

;/********************************************************************
; * Function:        void USBCtrlEPService(void)
; *
; * PreCondition:    USTAT is loaded with a valid endpoint address.
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        USBCtrlEPService checks for three transaction
; *                  types that it knows how to service and services
; *                  them:
; *                  1. EP0 SETUP
; *                  2. EP0 OUT
; *                  3. EP0 IN
; *                  It ignores all other types (i.e. EP1, EP2, etc.)
; *
; * Note:            None
; *******************************************************************/
;void USBCtrlEPService(void)
USBCtrlEPService
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;	//If the last packet was a EP0 OUT packet
;    if((USTATcopy & USTAT_EP0_PP_MASK) == USTAT_EP0_OUT_EVEN)
	movf	USTATcopy, W
	andlw	USTAT_EP0_PP_MASK
	sublw	USTAT_EP0_OUT
	bnz	USBCtrlEPService1
;    {
;		//Point to the EP0 OUT buffer of the buffer that arrived
;        #if defined(__18CXX)
;            pBDTEntryEP0OutCurrent = (volatile BDT_ENTRY*)&BDT[(USTATcopy & USTAT_EP_MASK)>>1];
;        #elif defined(__C30__)
;            pBDTEntryEP0OutCurrent = (volatile BDT_ENTRY*)&BDT[(USTATcopy & USTAT_EP_MASK)>>2];
;        #else
;            #error "unimplemented"
;        #endif

;		//Set the next out to the current out packet
;        pBDTEntryEP0OutNext = pBDTEntryEP0OutCurrent;
;		//Toggle it to the next ping pong buffer (if applicable)
;        ((BYTE_VAL*)&pBDTEntryEP0OutNext)->Val ^= USB_NEXT_EP0_OUT_PING_PONG;

;		//If the current EP0 OUT buffer has a SETUP token
;        if(pBDTEntryEP0OutCurrent->STAT.PID == SETUP_TOKEN)
	movf	ep0Bo + Stat, W
	andlw	0x3c			; Mask to PID
	sublw	(SETUP_TOKEN) << 2
;        {
;			//Handle the control transfer
;            USBCtrlTrfSetupHandler();
	bz	USBCtrlTrfSetupHandler
;        }
;        else
;        {
;			//Handle the DATA transfer
;            USBCtrlTrfOutHandler();
	bra	USBCtrlTrfOutHandler
;        }
;    }
;    else if((USTATcopy & USTAT_EP0_PP_MASK) == USTAT_EP0_IN)
USBCtrlEPService1
	movf	USTATcopy, W
	andlw	USTAT_EP0_PP_MASK
	sublw	USTAT_EP0_IN
;    {
;		//Otherwise the transmission was and EP0 IN
;		//  so take care of the IN transfer
;        USBCtrlTrfInHandler();
	bz	USBCtrlTrfInHandler
;    }
	return

;}//end USBCtrlEPService

;/********************************************************************
; * Function:        void USBCtrlTrfSetupHandler(void)
; *
; * PreCondition:    SetupPkt buffer is loaded with valid USB Setup Data
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This routine is a task dispatcher and has 3 stages.
; *                  1. It initializes the control transfer state machine.
; *                  2. It calls on each of the module that may know how to
; *                     service the Setup Request from the host.
; *                     Module Example: USBD, HID, CDC, MSD, ...
; *                     A callback function, USBCBCheckOtherReq(),
; *                     is required to call other module handlers.
; *                  3. Once each of the modules has had a chance to check if
; *                     it is responsible for servicing the request, stage 3
; *                     then checks direction of the transfer to determine how
; *                     to prepare EP0 for the control transfer.
; *                     Refer to USBCtrlEPServiceComplete() for more details.
; *
; * Note:            Microchip USB Firmware has three different states for
; *                  the control transfer state machine:
; *                  1. WAIT_SETUP
; *                  2. CTRL_TRF_TX
; *                  3. CTRL_TRF_RX
; *                  Refer to firmware manual to find out how one state
; *                  is transitioned to another.
; *
; *                  A Control Transfer is composed of many USB transactions.
; *                  When transferring data over multiple transactions,
; *                  it is important to keep track of data source, data
; *                  destination, and data count. These three parameters are
; *                  stored in pSrc,pDst, and wCount. A flag is used to
; *                  note if the data source is from ROM or RAM.
; *
; *******************************************************************/
;void USBCtrlTrfSetupHandler(void)
USBCtrlTrfSetupHandler
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;	//if the SIE currently owns the buffer
;    if(pBDTEntryIn[0]->STAT.UOWN != 0)
;    {
;		//give control back to the CPU
;		//  Compensate for after a STALL
;        pBDTEntryIn[0]->STAT.Val = _UCPU;           
;    }
	movlw	_UCPU
	btfsc	ep0Bi + Stat, UOWN
	movwf	ep0Bi + Stat

;	//Keep track of if a short packet has been sent yet or not
;    shortPacketStatus = SHORT_PKT_NOT_USED;
	movlw	SHORT_PKT_NOT_USED
	movwf	shortPacketStatus

;    /* Stage 1 */
;    controlTransferState = WAIT_SETUP;
	movlw	WAIT_SETUP
	movwf	controlTransferState

;    inPipes[0].wCount.Val = 0;
	clrf	inCount
	clrf	inCount + 1
;    inPipes[0].info.Val = 0;
	clrf	info

;    /* Stage 2 */
;    USBCheckStdRequest();
	rcall	USBCheckStdRequest
;    USBCBCheckOtherReq();   // Required callback, see usbcallbacks.c
	rcall	USBCBCheckOtherReq	; Class request

;    /* Stage 3 */
;    USBCtrlEPServiceComplete();
	bra	USBCtrlEPServiceComplete

;}//end USBCtrlTrfSetupHandler

;/******************************************************************************
; * Function:        void USBCtrlTrfOutHandler(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This routine handles an OUT transaction according to
; *                  which control transfer state is currently active.
; *
; * Note:            Note that if the the control transfer was from
; *                  host to device, the session owner should be notified
; *                  at the end of each OUT transaction to service the
; *                  received data.
; *
; *****************************************************************************/
;void USBCtrlTrfOutHandler(void)
USBCtrlTrfOutHandler
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;    if(controlTransferState == CTRL_TRF_RX)
	movlw	CTRL_TRF_RX
	cpfseq	controlTransferState
	bra	USBPrepareForNextSetupTrf
;    {
;        USBCtrlTrfRxService();
	bra	USBCtrlTrfRxService

;    }
;    else    // CTRL_TRF_TX
;    {
;        USBPrepareForNextSetupTrf();
;    }
;}

;/******************************************************************************
; * Function:        void USBCtrlTrfInHandler(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This routine handles an IN transaction according to
; *                  which control transfer state is currently active.
; *
; *
; * Note:            A Set Address Request must not change the acutal address
; *                  of the device until the completion of the control
; *                  transfer. The end of the control transfer for Set Address
; *                  Request is an IN transaction. Therefore it is necessary
; *                  to service this unique situation when the condition is
; *                  right. Macro mUSBCheckAdrPendingState is defined in
; *                  usb9.h and its function is to specifically service this
; *                  event.
; *****************************************************************************/
;void USBCtrlTrfInHandler(void)
USBCtrlTrfInHandler
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;    BYTE lastDTS;

;    lastDTS = pBDTEntryIn[0]->STAT.DTS;
	clrf	lastDTS
	btfsc	ep0Bi + Stat, DTS
	setf	lastDTS

;    //switch to the next ping pong buffer
;    ((BYTE_VAL*)&pBDTEntryIn[0])->Val ^= USB_NEXT_EP0_IN_PING_PONG;

;    //mUSBCheckAdrPendingState();       // Must check if in ADR_PENDING_STATE
;    if(USBDeviceState == ADR_PENDING_STATE)
	movlw	ADR_PENDING_STATE	; Must check if in ADR_PENDING_STATE
	cpfseq	USBDeviceState
	bra	USBCtrlTrfInHandler1
;    {
;        U1ADDR = SetupPkt.bDevADR.Val;
	movf	SetupPkt + bDevADR, W
#if (UADDR < 0xf60)
	BANKSEL	UADDR
#endif
	movwf	UADDR
;        if(U1ADDR > 0)
;        {
;            USBDeviceState=ADDRESS_STATE;
;        }
;        else
;        {
;            USBDeviceState=DEFAULT_STATE;
;        }
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movlw	ADDRESS_STATE		; If UADDR > 0
	btfsc	STATUS, Z		; Set from above
	movlw	DEFAULT_STATE
	movwf	USBDeviceState
;    }//end if


USBCtrlTrfInHandler1
;    if(controlTransferState == CTRL_TRF_TX)
	movlw	CTRL_TRF_TX
	cpfseq	controlTransferState
	bra	USBPrepareForNextSetupTrf
;    {
;        pBDTEntryIn[0]->ADR = (BYTE *)CtrlTrfData;
	movlw	low CtrlTrfData
	movwf	ep0Bi + ADRL
	movlw	high CtrlTrfData
	movwf	ep0Bi + ADRH
;        USBCtrlTrfTxService();
	rcall	USBCtrlTrfTxService

;        /* v2b fix */
;        if(shortPacketStatus == SHORT_PKT_SENT)
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movlw	SHORT_PKT_SENT
	cpfseq	shortPacketStatus
	bra	USBCtrlTrfInHandler2
;        {
;            // If a short packet has been sent, don't want to send any more,
;            // stall next time if host is still trying to read.
;            pBDTEntryIn[0]->STAT.Val = _USIE|_BSTALL;
	movlw	_USIE|_BSTALL		; If a short packet has been sent, don't want to send any more,
	movwf	ep0Bi + Stat		; stall next time if host is still trying to read.
	return
;        }
;        else
USBCtrlTrfInHandler2
;        {
;            if(lastDTS == 0)
;            {
;                pBDTEntryIn[0]->STAT.Val = _USIE|_DAT1|_DTSEN;
;            }
;            else
;            {
;                pBDTEntryIn[0]->STAT.Val = _USIE|_DAT0|_DTSEN;
;            }
	movlw	_USIE|_DAT1|_DTSEN
	tstfsz	lastDTS
	movlw	_USIE|_DAT0|_DTSEN
	movwf	ep0Bi + Stat
	return
;        }//end if(...)else
;    }
;    else // CTRL_TRF_RX
;    {
;        USBPrepareForNextSetupTrf();
;    }
;}

;/********************************************************************
; * Function:        void USBPrepareForNextSetupTrf(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        The routine forces EP0 OUT to be ready for a new
; *                  Setup transaction, and forces EP0 IN to be owned
; *                  by CPU.
; *
; * Note:            None
; *******************************************************************/
;void USBPrepareForNextSetupTrf(void)
USBPrepareForNextSetupTrf
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;    /********************************************************************
;    Bug Fix: Feb 26, 2007 v2.1
;    *********************************************************************
;    Facts:
;    A Setup Packet should never be stalled. (USB 2.0 Section 8.5.3)
;    If a Setup PID is detected by the SIE, the DTSEN setting is ignored.
;    This causes a problem at the end of a control write transaction.
;    In USBCtrlEPServiceComplete(), during a control write (Host to Device),
;    the EP0_OUT is setup to write any data to the CtrlTrfData buffer.
;    If <SETUP[0]><IN[1]> is completed and USBCtrlTrfInHandler() is not
;    called before the next <SETUP[0]> is received, then the latest Setup
;    data will be written to the CtrlTrfData buffer instead of the SetupPkt
;    buffer.
;
;    If USBCtrlTrfInHandler() was called before the latest <SETUP[0]> is
;    received, then there would be no problem,
;    because USBPrepareForNextSetupTrf() would have been called and updated
;    ep0Bo.ADR to point to the SetupPkt buffer.
;
;    Work around:
;    Check for the problem as described above and copy the Setup data from
;    CtrlTrfData to SetupPkt.
;    ********************************************************************/
;    if((controlTransferState == CTRL_TRF_RX) &&
	movlw	CTRL_TRF_RX
	cpfseq	controlTransferState
	bra	USBPrepareForNextSetupTrf1
;       (USBPacketDisable == 1) &&
	btfss	UCON, PKTDIS
	bra	USBPrepareForNextSetupTrf1
;       (pBDTEntryEP0OutCurrent->CNT == sizeof(CTRL_TRF_SETUP)) &&
	movlw	USB_EP0_BUFF_SIZE
	cpfseq	ep0Bo + Cnt
	bra	USBPrepareForNextSetupTrf1
;       (pBDTEntryEP0OutCurrent->STAT.PID == SETUP_TOKEN) &&
	movf	ep0Bo + Stat, W
	andlw	0x3c			; Mask to PID
	sublw	(SETUP_TOKEN) << 2
	bnz	USBPrepareForNextSetupTrf1
;       (pBDTEntryEP0OutNext->STAT.UOWN == 0))
	btfsc	ep0Bo + Stat, UOWN
	bra	USBPrepareForNextSetupTrf1
;    {
;        unsigned char setup_cnt;

;        pBDTEntryEP0OutNext->ADR = (BYTE*)&SetupPkt;
	movlw	low SetupPkt
	movwf	ep0Bo + ADRL
	movlw	high SetupPkt
	movwf	ep0Bo + ADRH

;        // The Setup data was written to the CtrlTrfData buffer, must copy
;        // it back to the SetupPkt buffer so that it can be processed correctly
;        // by USBCtrlTrfSetupHandler().
;        for(setup_cnt = 0; setup_cnt < sizeof(CTRL_TRF_SETUP); setup_cnt++)
;        {
;            *(((BYTE*)&SetupPkt)+setup_cnt) = *(((BYTE*)&CtrlTrfData)+setup_cnt);
;        }//end for
	lfsr	1, CtrlTrfData
	lfsr	2, SetupPkt
	movlw	USB_EP0_BUFF_SIZE
USBPrepareForNextSetupTrfLoop
	movff	POSTINC1, POSTINC2
	decfsz	WREG, F
	bra	USBPrepareForNextSetupTrfLoop
	bra	USBPrepareForNextSetupTrf2
;    }
;    /* End v3b fix */
;    else
USBPrepareForNextSetupTrf1
;    {
;        controlTransferState = WAIT_SETUP;
	movlw	WAIT_SETUP
	movwf	controlTransferState
;        pBDTEntryEP0OutNext->CNT = USB_EP0_BUFF_SIZE;      // Defined in usb_config.h
	movlw	USB_EP0_BUFF_SIZE
	movwf	ep0Bo + Cnt
;        pBDTEntryEP0OutNext->ADR = (BYTE*)&SetupPkt;
	movlw	low SetupPkt
	movwf	ep0Bo + ADRL
	movlw	high SetupPkt
	movwf	ep0Bo + ADRH

;        /********************************************************************
;        Bug Fix: Feb 26, 2007 v2.1 (#F1)
;        *********************************************************************
;        In the original firmware, if an OUT token is sent by the host
;        before a SETUP token is sent, the firmware would respond with an ACK.
;        This is not a correct response, the firmware should have sent a STALL.
;        This is a minor non-compliance since a compliant host should not
;        send an OUT before sending a SETUP token. The fix allows a SETUP
;        transaction to be accepted while stalling OUT transactions.
;        ********************************************************************/
;        //ep0Bo.Stat.Val = _USIE|_DAT0|_DTSEN;        // Removed
;        pBDTEntryEP0OutNext->STAT.Val = _USIE|_DAT0|_DTSEN|_BSTALL;  //Added #F1
	movlw	_USIE|_DAT0|_DTSEN|_BSTALL
	movwf	ep0Bo + Stat

;        /********************************************************************
;        Bug Fix: Feb 26, 2007 v2.1 (#F3)
;        *********************************************************************
;        In the original firmware, if an IN token is sent by the host
;        before a SETUP token is sent, the firmware would respond with an ACK.
;        This is not a correct response, the firmware should have sent a STALL.
;        This is a minor non-compliance since a compliant host should not
;        send an IN before sending a SETUP token.

;        Comment why this fix (#F3) is interfering with fix (#AF1).
;        ********************************************************************/
;        pBDTEntryIn[0]->STAT.Val = _UCPU;             // Should be removed

;        {
;            BDT_ENTRY* p;

;            p = (BDT_ENTRY*)(((unsigned int)pBDTEntryIn[0])^USB_NEXT_EP0_IN_PING_PONG);
;            p->STAT.Val = _UCPU;
	movlw	_UCPU			; EP0 IN buffer initialization
	movwf	ep0Bi + Stat
;        }

;        //ep0Bi.Stat.Val = _USIE|_BSTALL;   // Should be added #F3
;    }

USBPrepareForNextSetupTrf2
;    //if someone is still expecting data from the control transfer
;    //  then make sure to terminate that request and let them know that
;    //  they are done
;    if(outPipes[0].info.bits.busy == 1)
;    {
;        if(outPipes[0].pFunc != NULL)
;        {
;            outPipes[0].pFunc();
;        }
;        outPipes[0].info.bits.busy = 0;
	bcf	outfo, busy
;    }
	return

;}//end USBPrepareForNextSetupTrf

;/********************************************************************
; * Function:        void USBCheckStdRequest(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This routine checks the setup data packet to see
; *                  if it knows how to handle it
; *
; * Note:            None
; *******************************************************************/
;void USBCheckStdRequest(void)
USBCheckStdRequest
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;    if(SetupPkt.RequestType != STANDARD) return;
	movf	SetupPkt, W		; RequestType = STANDARD?
	andlw	0x60			; Mask to proper bits
	sublw	(STANDARD) << 5
	bnz	USBCheckStdRequestExit	; No

;    switch(SetupPkt.bRequest)
;    {
;        case SET_ADR:
	movlw	SET_ADR			; Handle request
	cpfseq	SetupPkt + bRequest
	bra	USBCheckStdRequest1
;            inPipes[0].info.bits.busy = 1;            // This will generate a zero length packet
	bsf	info, busy
;            USBDeviceState = ADR_PENDING_STATE;       // Update state only
	movlw	ADR_PENDING_STATE	; Update state only
	movwf	USBDeviceState
;            /* See USBCtrlTrfInHandler() for the next step */
;            break;
USBCheckStdRequestExit
	return
USBCheckStdRequest1
;        case GET_DSC:
	movlw	GET_DSC
	subwf	SetupPkt + bRequest, W
	bz	USBStdGetDscHandler
;	cpfseq	SetupPkt + bRequest
;	bra	USBCheckStdRequest2
;            USBStdGetDscHandler();
;	bra	USBStdGetDscHandler
;            break;
;USBCheckStdRequest2
;        case SET_CFG:
	movlw	SET_CFG
	cpfseq	SetupPkt + bRequest
	bra	USBCheckStdRequest3
;            USBStdSetCfgHandler();
	bra	USBStdSetCfgHandler
;            break;
USBCheckStdRequest3
;        case GET_CFG:
	movlw	GET_CFG
	cpfseq	SetupPkt + bRequest
	bra	USBCheckStdRequest4
;            inPipes[0].pSrc.bRam = (BYTE*)&USBActiveConfiguration;         // Set Source
	mSetSourcePointer USBActiveConfiguration
;            inPipes[0].info.bits.ctrl_trf_mem = _RAM;               // Set memory type
	bsf	info, ctrl_trf_mem	; Indicate RAM
;            inPipes[0].wCount.v[0] = 1;                         // Set data count
	movlw	1
	movwf	inCount
	clrf	inCount + 1
;            inPipes[0].info.bits.busy = 1;
	bsf	info, busy
;            break;
	return
USBCheckStdRequest4
;        case GET_STATUS:
	movlw	GET_STATUS
	cpfseq	SetupPkt + bRequest
	bra	USBCheckStdRequest5
;            USBStdGetStatusHandler();
	bra	USBStdGetStatusHandler
;            break;
USBCheckStdRequest5
;        case CLR_FEATURE:
	movlw	CLR_FEATURE
	subwf	SetupPkt + bRequest, W
	bz	USBStdFeatureReqHandler
;	cpfseq	SetupPkt + bRequest
;	bra	USBCheckStdRequest6
;	bra	USBStdFeatureReqHandler
;USBCheckStdRequest6
;        case SET_FEATURE:
	movlw	SET_FEATURE
	subwf	SetupPkt + bRequest, W
	bz	USBStdFeatureReqHandler
;	cpfseq	SetupPkt + bRequest
;	bra	USBCheckStdRequest7
;            USBStdFeatureReqHandler();
;	bra	USBStdFeatureReqHandler
;            break;
;USBCheckStdRequest7
;        case GET_INTF:
	movlw	GET_INTF
	cpfseq	SetupPkt + bRequest
	bra	USBCheckStdRequest8
;            inPipes[0].pSrc.bRam = (BYTE*)&USBAlternateInterface+SetupPkt.bIntfID;  // Set source
	mSetSourcePointer USBAlternateInterface
	movf	SetupPkt + bIntfID, W
	addwf	pSrc, F
;            inPipes[0].info.bits.ctrl_trf_mem = _RAM;               // Set memory type
	bsf	info, ctrl_trf_mem	; Indicate RAM
;            inPipes[0].wCount.v[0] = 1;                         // Set data count
	movlw	1
	movwf	inCount
	clrf	inCount + 1
;            inPipes[0].info.bits.busy = 1;
	bsf	info, busy
;            break;
	return
USBCheckStdRequest8
;        case SET_INTF:
	movlw	SET_INTF
	cpfseq	SetupPkt + bRequest
	bra	USBCheckStdRequest9
;            inPipes[0].info.bits.busy = 1;
	bsf	info, busy
;            USBAlternateInterface[SetupPkt.bIntfID] = SetupPkt.bAltID;
	lfsr	2, USBAlternateInterface
	movf	SetupPkt + bIntfID, W
	movff	SetupPkt + bAltID, PLUSW2
;            break;
	return
USBCheckStdRequest9
;        case SET_DSC:
	movlw	SET_DSC
	cpfseq	SetupPkt + bRequest
	return
;            USBCBStdSetDscHandler();
	bra	USBCBStdSetDscHandler
;            break;
;        case SYNCH_FRAME:
;        default:
;            break;
;    }//end switch
;}//end USBCheckStdRequest

;/********************************************************************
; * Function:        void USBStdFeatureReqHandler(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This routine handles the standard SET & CLEAR
; *                  FEATURES requests
; *
; * Note:            None
; *******************************************************************/
;void USBStdFeatureReqHandler(void)
USBStdFeatureReqHandler
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;    BDT_ENTRY *p;
;    unsigned int* pUEP;             

;    if((SetupPkt.bFeature == DEVICE_REMOTE_WAKEUP)&&
	movlw	DEVICE_REMOTE_WAKEUP	; If Feature = DEVICE_REMOTE_WAKEUP &
	cpfseq	SetupPkt + bFeature
	bra	USBStdFeatureReqHandler1
;       (SetupPkt.Recipient == RCPT_DEV))
	movf	SetupPkt, W		; Recipient = RCPT_DEV?
	andlw	0x1f			; Mask to lower 5 bits
	sublw	RCPT_DEV
	bnz	USBStdFeatureReqHandler1	; No
;    {
;        inPipes[0].info.bits.busy = 1;
        bsf	info, busy
;        if(SetupPkt.bRequest == SET_FEATURE)
;            RemoteWakeup = TRUE;
;        else
;            RemoteWakeup = FALSE;
	setf	RemoteWakeup		; Preset RemoteWakeup to 1
	movlw	SET_FEATURE		; Request = SET_FEATURE?
	cpfseq	SetupPkt + bRequest
	clrf	RemoteWakeup		; No, RemoteWakeup = 0
;    }//end if

USBStdFeatureReqHandler1
;    if((SetupPkt.bFeature == ENDPOINT_HALT)&&
	movlw	ENDPOINT_HALT		; If Feature = ENDPOINT_HALT &
	cpfseq	SetupPkt + bFeature
USBStdFeatureReqHandlerExit
	return
;       (SetupPkt.Recipient == RCPT_EP)&&
	movf	SetupPkt, W		; Recepient = RCPT_EP &
	andlw	0x1f			; Mask to lower 5 bits
	sublw	RCPT_EP
	bnz	USBStdFeatureReqHandlerExit
;       (SetupPkt.EPNum != 0))
	movf	SetupPkt + bEPID, W	; EPNum != 0
	andlw	0x0f			; Mask to EPNum
	bz	USBStdFeatureReqHandlerExit
;    {
;        BYTE i;

;        inPipes[0].info.bits.busy = 1;
	bsf	info, busy
;        /* Must do address calculation here */

;		//loop for each of the possible ping-pong buffers
;        for(i=0; i<2; i++)
;        {
;			//point to the first EP0 OUT ping pong buffer
;            p = (BDT_ENTRY*)&BDT[EP0_OUT_EVEN];

;			//jump from this endpoint to the requested endpoint
;            p += EP(SetupPkt.EPNum,SetupPkt.EPDir,i);
	rcall	USBCalcEPAddress	; Put endpoint buffer address in FSR2

;			//if it was a SET_FEATURE request
;            if(SetupPkt.bRequest == SET_FEATURE)
	movlw	SET_FEATURE		; Request = SET_FEATURE?
	cpfseq	SetupPkt + bRequest
	bra	USBStdFeatureReqHandler2	; No
;            {
;				//Then STALL the endpoint
;                p->STAT.Val = _USIE|_BSTALL;
	movlw	_USIE|_BSTALL
	movwf	INDF2			; Put in endpoint buffer
	return
;            }
;            else
USBStdFeatureReqHandler2
;            {
;				//If it was not a SET_FEATURE
;				//point to the appropriate UEP register
;                pUEP = (unsigned int*)(&U1EP0+SetupPkt.EPNum);
; Point FSR1 to endpoint table
	lfsr	1, UEP0			; FSR2 = beginning of endpoint table
	movf	SetupPkt + bEPID, W	; Add in endpoint number
	addwf	FSR1L, F

;				//Clear the STALL bit in the UEP register
;                *pUEP &= ~UEP_STALL;
	movlw	~UEP_STALL
	andwf	INDF1, F

;                if(SetupPkt.EPDir == 1) // IN
;                {
;					//If the endpoint is an IN endpoint then we
;					//  need to return it to the CPU and reset the
;					//  DTS bit so that the next transfer is correct
;                    p->STAT.Val = _UCPU|_DAT1;
;                }
;                else
;                {
;					//If the endpoint was an OUT endpoint then we
;					//  need to give control of the endpoint back to
;					//  the SIE so that the function driver can
;					//  receive the data as they expected.  Also need
;					//  to set the DTS bit so the next packet will be
;					//  correct
;                    p->STAT.Val = _USIE|_DAT1|_DTSEN;
;                }
	movlw	_UCPU|_DAT1		; IN
	btfss	SetupPkt + bEPID, EPDir	; EPDir = 1 (IN)?
	movlw	_USIE|_DAT1|_DTSEN	; No - OUT
	movwf	INDF2			; Put in endpoint buffer
	return
;            }//end if
;        }

;    }//end if
;}//end USBStdFeatureReqHandler

; Put endpoint buffer address in FSR2 (ep0Bo+(EPNum*8)+(EPDir*4))
USBCalcEPAddress
	lfsr	2, ep0Bo		; Point FSR2 to beginning of buffer area
	rlncf	SetupPkt + bEPID, W	; Move endpoint direction to C
	rlcf	SetupPkt + bEPID, W	; Endpoint number * 8 (roll in ep direction)
	rlncf	WREG, F
	rlncf	WREG, F
	addwf	FSR2L, F		; Add to FSR2 (can't overflow to FSR2H)
	return

;/********************************************************************
; * Function:        void USBStdGetDscHandler(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This routine handles the standard GET_DESCRIPTOR
; *                  request.
; *
; * Note:            None
; *******************************************************************/
;void USBStdGetDscHandler(void)
USBStdGetDscHandler
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;    if(SetupPkt.bmRequestType == 0x80)
	movlw	0x80
	cpfseq	SetupPkt + bmRequestType
	return
;    {
;        inPipes[0].info.Val = USB_INPIPES_ROM | USB_INPIPES_BUSY | USB_INPIPES_INCLUDE_ZERO;
	movlw	USB_INPIPES_ROM | USB_INPIPES_BUSY | USB_INPIPES_INCLUDE_ZERO
	movwf	info

;        switch(SetupPkt.bDescriptorType)
;        {
;            case USB_DESCRIPTOR_DEVICE:
	movlw	USB_DESCRIPTOR_DEVICE
	cpfseq	SetupPkt + bDescriptorType
	bra	USBStdGetDscHandler1
;                #if !defined(USB_USER_DEVICE_DESCRIPTOR)
;                    inPipes[0].pSrc.bRom = (ROM BYTE*)&device_dsc;
;                #else
;                    inPipes[0].pSrc.bRom = (ROM BYTE*)USB_USER_DEVICE_DESCRIPTOR;
;                #endif
	mSetSourcePointer DeviceDescriptor
;                inPipes[0].wCount.Val = sizeof(device_dsc);
	mGetRomTableCount		; Set wCount
	return
;                break;
USBStdGetDscHandler1
;            case USB_DESCRIPTOR_CONFIGURATION:
	movlw	USB_DESCRIPTOR_CONFIGURATION
	cpfseq	SetupPkt + bDescriptorType
	bra	USBStdGetDscHandler2
;                #if !defined(USB_USER_CONFIG_DESCRIPTOR)
;                    inPipes[0].pSrc.bRom = *(USB_CD_Ptr+SetupPkt.bDscIndex);
;                #else
;                    inPipes[0].pSrc.bRom = *(USB_USER_CONFIG_DESCRIPTOR+SetupPkt.bDscIndex);
;                #endif
;	mSetSourcePointer Config1
	clrf	TBLPTRU
	clrf	TBLPTRH
	rlncf	SetupPkt + bDscIndex, W	; Index * 4
	rlncf	WREG, F
	addlw	low (USB_CD_Ptr)	; Add element offset to low address
	movwf	TBLPTRL
	movlw	high (USB_CD_Ptr)
	addwfc	TBLPTRH, F
	movlw	upper (USB_CD_Ptr)
	addwfc	TBLPTRU, F
	tblrd   *+			; Get the data to TABLAT and move pointer forward
	movff	TABLAT, pSrc		; Get low source address
	tblrd   *+
	movff	TABLAT, pSrc + 1	; Get high source address
	tblrd   *
	movff	TABLAT, pSrc + 2	; Get upper source address
;                inPipes[0].wCount.Val = *(inPipes[0].pSrc.wRom+1);                // Set data count
	movff	pSrc, TBLPTRL		; Set wCount to total length
	movff	pSrc + 1, TBLPTRH
	movff	pSrc + 2, TBLPTRU
	tblrd	*+			; Skip 4 locations
	tblrd	*+
	tblrd	*+
	tblrd	*+
	tblrd	*+			; Read count low
	movff	TABLAT, inCount
	tblrd	*+			; Ignore RETLW opcode
	tblrd	*+			; Read count high
	movff	TABLAT, inCount + 1
 	return
;               break;
USBStdGetDscHandler2
;            case USB_DESCRIPTOR_STRING:
	movlw	USB_DESCRIPTOR_STRING
	cpfseq	SetupPkt + bDescriptorType
	bra	USBStdGetDscHandler3
;                inPipes[0].pSrc.bRom = *(USB_SD_Ptr+SetupPkt.bDscIndex);
	clrf	TBLPTRU
	clrf	TBLPTRH
	rlncf	SetupPkt + bDscIndex, W	; Index * 4
	rlncf	WREG, F
	addlw	low (USB_SD_Ptr)	; Add element offset to low address
	movwf	TBLPTRL
	movlw	high (USB_SD_Ptr)
	addwfc	TBLPTRH, F
	movlw	upper (USB_SD_Ptr)
	addwfc	TBLPTRU, F
        tblrd   *+			; Get the data to TABLAT and move pointer forward
	movff	TABLAT, pSrc		; Get low source address
        tblrd   *+
	movff	TABLAT, pSrc + 1	; Get high source address
        tblrd   *
	movff	TABLAT, pSrc + 2	; Get upper source address
;                inPipes[0].wCount.Val = *inPipes[0].pSrc.bRom;                    // Set data count
	mGetRomTableCount		; Set wCount
	return
;                break;
USBStdGetDscHandler3
;            default:
;                inPipes[0].info.Val = 0;
	clrf	info
	return
;                break;
;        }//end switch
;    }//end if
;}//end USBStdGetDscHandler

;/********************************************************************
; * Function:        void USBStdGetStatusHandler(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This routine handles the standard GET_STATUS request
; *
; * Note:            None
; *******************************************************************/
;void USBStdGetStatusHandler(void)
USBStdGetStatusHandler
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;    CtrlTrfData[0] = 0;                 // Initialize content
	clrf	CtrlTrfData		; Initialize content
;    CtrlTrfData[1] = 0;
	clrf	CtrlTrfData + 1

;    switch(SetupPkt.Recipient)
;    {
;        case RCPT_DEV:
	movf	SetupPkt, W		; Recipient = RCPT_DEV?
	andlw	0x1f			; Mask to lower 5 bits
	sublw	RCPT_DEV
	bnz	USBStdGetStatusHandler1	; No
;            inPipes[0].info.bits.busy = 1;
	bsf	info, busy
;            /*
;             * [0]: bit0: Self-Powered Status [0] Bus-Powered [1] Self-Powered
;             *      bit1: RemoteWakeup        [0] Disabled    [1] Enabled
;             */
;            if(self_power == 1) // self_power is defined in HardwareProfile.h
#ifdef USB_SELF_POWER
            {
;                CtrlTrfData[0]|=0x01;
	bsf	CtrlTrfData, 0
            }
#endif

;            if(RemoteWakeup == TRUE)
;            {
;                CtrlTrfData[0]|=0x02;
;            }
	tstfsz	RemoteWakeup
	bsf	CtrlTrfData, 1
	bra	USBStdGetStatusHandlerExit
;            break;
USBStdGetStatusHandler1
;        case RCPT_INTF:
	movf	SetupPkt, W		; Recipient = RCPT_INTF?
	andlw	0x1f			; Mask to lower 5 bits
	sublw	RCPT_INTF
	bnz	USBStdGetStatusHandler2	; No
;            inPipes[0].info.bits.busy = 1;     // No data to update
	bsf	info, busy
	bra	USBStdGetStatusHandlerExit
;            break;
USBStdGetStatusHandler2
;        case RCPT_EP:
	movf	SetupPkt, W		; Recipient = RCPT_EP?
	andlw	0x1f			; Mask to lower 5 bits
	sublw	RCPT_EP
	bnz	USBStdGetStatusHandlerExit	; No
;            inPipes[0].info.bits.busy = 1;
	bsf	info, busy
;            /*
;             * [0]: bit0: Halt Status [0] Not Halted [1] Halted
;             */
;            {
;                BDT_ENTRY *p;
;                p = (BDT_ENTRY*)&BDT[EP0_OUT_EVEN];
;                p += EP(SetupPkt.EPNum,SetupPkt.EPDir,0);
	rcall	USBCalcEPAddress	; Put endpoint buffer address in FSR2
    
;                if(p->STAT.Val & _BSTALL)    // Use _BSTALL as a bit mask
	movf	INDF2, W
	andlw	_BSTALL
	bz	USBStdGetStatusHandlerExit
;                    CtrlTrfData[0]=0x01;    // Set bit0
;	movlw	0x01
;	movwf	CtrlTrfData
	bsf	CtrlTrfData, 0
;                break;
;            }
;    }//end switch

USBStdGetStatusHandlerExit
;    if(inPipes[0].info.bits.busy == 1)
	btfss	info, busy
	return
;    {
;        inPipes[0].pSrc.bRam = (BYTE*)&CtrlTrfData;            // Set Source
	mSetSourcePointer CtrlTrfData
;        inPipes[0].info.bits.ctrl_trf_mem = _RAM;               // Set memory type
	bsf	info, ctrl_trf_mem	; Indicate RAM
;        inPipes[0].wCount.v[0] = 2;                         // Set data count
	movlw	2			; Set count
	movwf	inCount
	clrf	inCount + 1
	return
;    }//end if(...)
;}//end USBStdGetStatusHandler

;/******************************************************************************
; * Function:        void USBCtrlEPServiceComplete(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This routine wrap up the ramaining tasks in servicing
; *                  a Setup Request. Its main task is to set the endpoint
; *                  controls appropriately for a given situation. See code
; *                  below.
; *                  There are three main scenarios:
; *                  a) There was no handler for the Request, in this case
; *                     a STALL should be sent out.
; *                  b) The host has requested a read control transfer,
; *                     endpoints are required to be setup in a specific way.
; *                  c) The host has requested a write control transfer, or
; *                     a control data stage is not required, endpoints are
; *                     required to be setup in a specific way.
; *
; *                  Packet processing is resumed by clearing PKTDIS bit.
; *
; * Note:            None
; *****************************************************************************/
;void USBCtrlEPServiceComplete(void)
USBCtrlEPServiceComplete
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;    /*
;     * PKTDIS bit is set when a Setup Transaction is received.
;     * Clear to resume packet processing.
;     */
;    USBPacketDisable = 0;
	bcf	UCON, PKTDIS

;    if(inPipes[0].info.bits.busy == 0)
	btfsc	info, busy
	bra	USBCtrlEPServiceComplete1
;    {
;        if(outPipes[0].info.bits.busy == 1)
	btfss	outfo, busy
	bra	USBCtrlEPServiceComplete0
;        {
;            controlTransferState = CTRL_TRF_RX;
	movlw	CTRL_TRF_RX
	movwf	controlTransferState
;            /*
;             * Control Write:
;             * <SETUP[0]><OUT[1]><OUT[0]>...<IN[1]> | <SETUP[0]>
;             *
;             * 1. Prepare IN EP to respond to early termination
;             *
;             *    This is the same as a Zero Length Packet Response
;             *    for control transfer without a data stage
;             */
;            pBDTEntryIn[0]->CNT = 0;
	clrf	ep0Bi + Cnt
;            pBDTEntryIn[0]->STAT.Val = _USIE|_DAT1|_DTSEN;
	movlw	_USIE|_DAT1|_DTSEN
	movwf	ep0Bi + Stat
;
;            /*
;             * 2. Prepare OUT EP to receive data.
;             */
;            pBDTEntryEP0OutNext->CNT = USB_EP0_BUFF_SIZE;
	movlw	USB_EP0_BUFF_SIZE
	movwf	ep0Bo + Cnt
;            pBDTEntryEP0OutNext->ADR = (BYTE*)&CtrlTrfData;
	movlw	low CtrlTrfData
	movwf	ep0Bo + ADRL
	movlw	high CtrlTrfData
	movwf	ep0Bo + ADRH
;            pBDTEntryEP0OutNext->STAT.Val = _USIE|_DAT1|_DTSEN;
	movlw	_USIE|_DAT1|_DTSEN
	movwf	ep0Bo + Stat
	return
;        }
;        else
USBCtrlEPServiceComplete0
;        {
;            /*
;             * If no one knows how to service this request then stall.
;             * Must also prepare EP0 to receive the next SETUP transaction.
;            */
;            pBDTEntryEP0OutNext->CNT = USB_EP0_BUFF_SIZE;
	movlw	USB_EP0_BUFF_SIZE
	movwf	ep0Bo + Cnt
;            pBDTEntryEP0OutNext->ADR = (BYTE*)&SetupPkt;
	movlw	low SetupPkt
	movwf	ep0Bo + ADRL
	movlw	high SetupPkt
	movwf	ep0Bo + ADRH

;            /* v2b fix */
;            pBDTEntryEP0OutNext->STAT.Val = _USIE|_DAT0|_DTSEN|_BSTALL;
	movlw	_USIE|_DAT0|_DTSEN|_BSTALL
	movwf	ep0Bo + Stat
;            pBDTEntryIn[0]->STAT.Val = _USIE|_BSTALL; 
	movlw	_USIE|_BSTALL
	movwf	ep0Bi + Stat
	return
;        }
;    }
;    else    // A module has claimed ownership of the control transfer session.
USBCtrlEPServiceComplete1
;    {
;        if(outPipes[0].info.bits.busy == 0)
	btfsc	outfo, busy
	bra	USBCtrlEPServiceComplete0
;        {
;        if(SetupPkt.DataDir == DEV_TO_HOST)
	btfss	SetupPkt, DataDir
	bra	USBCtrlEPServiceComplete2
;        {
;            if(SetupPkt.wLength < inPipes[0].wCount.Val)
;            {
;                inPipes[0].wCount.Val = SetupPkt.wLength;
;            }
	movf	inCount + 1, W		; Make sure count does not exceed max length requested by Host
	subwf	SetupPkt + wLength + 1, W
	bnc	USBCtrlEPServiceCompleteCopy
	bnz	USBCtrlEPServiceComplete11
	movf	inCount, W
	subwf	SetupPkt + wLength, W
	bc	USBCtrlEPServiceComplete11
USBCtrlEPServiceCompleteCopy
	movff	SetupPkt + wLength, inCount	; Set count to maximum
	movff	SetupPkt + wLength + 1, inCount + 1
USBCtrlEPServiceComplete11
;            USBCtrlTrfTxService();
	rcall	USBCtrlTrfTxService    ; Actually copy the data to EP0 IN buffer
;            controlTransferState = CTRL_TRF_TX;
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movlw	CTRL_TRF_TX
	movwf	controlTransferState
;            /*
;             * Control Read:
;             * <SETUP[0]><IN[1]><IN[0]>...<OUT[1]> | <SETUP[0]>
;             * 1. Prepare OUT EP to respond to early termination
;             *
;             * NOTE:
;             * If something went wrong during the control transfer,
;             * the last status stage may not be sent by the host.
;             * When this happens, two different things could happen
;             * depending on the host.
;             * a) The host could send out a RESET.
;             * b) The host could send out a new SETUP transaction
;             *    without sending a RESET first.
;             * To properly handle case (b), the OUT EP must be setup
;             * to receive either a zero length OUT transaction, or a
;             * new SETUP transaction.
;             *
;             * Furthermore, the Cnt byte should be set to prepare for
;             * the SETUP data (8-byte or more), and the buffer address
;             * should be pointed to SetupPkt.
;             */
;            pBDTEntryEP0OutNext->CNT = USB_EP0_BUFF_SIZE;
	movlw	USB_EP0_BUFF_SIZE
	movwf	ep0Bo + Cnt
;            pBDTEntryEP0OutNext->ADR = (BYTE*)&SetupPkt;
	movlw	low SetupPkt
	movwf	ep0Bo + ADRL
	movlw	high SetupPkt
	movwf	ep0Bo + ADRH
;            pBDTEntryEP0OutNext->STAT.Val = _USIE;           // Note: DTSEN is 0!
	movlw	_USIE			; Note: DTSEN is 0!
	movwf	ep0Bo + Stat

;            pBDTEntryEP0OutCurrent->CNT = USB_EP0_BUFF_SIZE;
;            pBDTEntryEP0OutCurrent->ADR = (BYTE*)&SetupPkt;
;            pBDTEntryEP0OutCurrent->STAT.Val = _USIE;           // Note: DTSEN is 0!

;            /*
;             * 2. Prepare IN EP to transfer data, Cnt should have
;             *    been initialized by responsible request owner.
;             */
;            pBDTEntryIn[0]->ADR = (BYTE*)&CtrlTrfData;
	movlw	low CtrlTrfData
	movwf	ep0Bi + ADRL
	movlw	high CtrlTrfData
	movwf	ep0Bi + ADRH
;            pBDTEntryIn[0]->STAT.Val = _USIE|_DAT1|_DTSEN;
	movlw	_USIE|_DAT1|_DTSEN
	movwf	ep0Bi + Stat
	return
;        }
;        else    // (SetupPkt.DataDir == HOST_TO_DEVICE)
USBCtrlEPServiceComplete2
;        {
;            controlTransferState = CTRL_TRF_RX;
	movlw	CTRL_TRF_RX
	movwf	controlTransferState
;            /*
;             * Control Write:
;             * <SETUP[0]><OUT[1]><OUT[0]>...<IN[1]> | <SETUP[0]>
;             *
;             * 1. Prepare IN EP to respond to early termination
;             *
;             *    This is the same as a Zero Length Packet Response
;             *    for control transfer without a data stage
;             */
;            pBDTEntryIn[0]->CNT = 0;
	clrf	ep0Bi + Cnt
;            pBDTEntryIn[0]->STAT.Val = _USIE|_DAT1|_DTSEN;
	movlw	_USIE|_DAT1|_DTSEN
	movwf	ep0Bi + Stat

;            /*
;             * 2. Prepare OUT EP to receive data.
;             */
;            pBDTEntryEP0OutNext->CNT = USB_EP0_BUFF_SIZE;
	movlw	USB_EP0_BUFF_SIZE
	movwf	ep0Bo + Cnt
;            pBDTEntryEP0OutNext->ADR = (BYTE*)&CtrlTrfData;
	movlw	low CtrlTrfData
	movwf	ep0Bo + ADRL
	movlw	high CtrlTrfData
	movwf	ep0Bo + ADRH
;            pBDTEntryEP0OutNext->STAT.Val = _USIE|_DAT1|_DTSEN;
	movlw	_USIE|_DAT1|_DTSEN
	movwf	ep0Bo + Stat
;			}
;        }
;    }//end if(ctrl_trf_session_owner == MUID_NULL)

	return
;}//end USBCtrlEPServiceComplete


;/******************************************************************************
; * Function:        void USBCtrlTrfTxService(void)
; *
; * PreCondition:    pSrc, wCount, and usb_stat.ctrl_trf_mem are setup properly.
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This routine should be called from only two places.
; *                  One from USBCtrlEPServiceComplete() and one from
; *                  USBCtrlTrfInHandler(). It takes care of managing a
; *                  transfer over multiple USB transactions.
; *
; * Note:            This routine works with isochronous endpoint larger than
; *                  256 bytes and is shown here as an example of how to deal
; *                  with BC9 and BC8. In reality, a control endpoint can never
; *                  be larger than 64 bytes.
; *****************************************************************************/
;void USBCtrlTrfTxService(void)
USBCtrlTrfTxService
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;    WORD_VAL byteToSend;

;    /*
;     * First, have to figure out how many byte of data to send.
;     */
;    if(inPipes[0].wCount.Val < USB_EP0_BUFF_SIZE)
;    {
;        byteToSend.Val = inPipes[0].wCount.Val;

;        /* v2b fix */
;        if(shortPacketStatus == SHORT_PKT_NOT_USED)
;        {
;            shortPacketStatus = SHORT_PKT_PENDING;
;        }
;        else if(shortPacketStatus == SHORT_PKT_PENDING)
;        {
;            shortPacketStatus = SHORT_PKT_SENT;
;        }//end if
;        /* end v2b fix for this section */
;    }
;    else
;    {
;        byteToSend.Val = USB_EP0_BUFF_SIZE;
;    }
	movf	inCount, W		; Preset wCount bytes to send
	movwf	usb_temp
	movf	inCount + 1, W
	movwf	usb_temp + 1
	sublw	high USB_EP0_BUFF_SIZE	; Check for count less than maximium length
	bnz	USBCtrlTrfTxServiceNotEQ	; Not equal so we don't need to check the bottom byte
	movf	inCount, W
	sublw	low USB_EP0_BUFF_SIZE
	bz	USBCtrlTrfTxServiceNotLess	; Equal to
USBCtrlTrfTxServiceNotEQ
	bnc	USBCtrlTrfTxServiceGreater	; Greater than
	movlw	SHORT_PKT_NOT_USED
	cpfseq	shortPacketStatus
	bra	USBCtrlTrfTxServiceNotEQ1
	movlw	SHORT_PKT_PENDING
	movwf	shortPacketStatus
        bra	USBCtrlTrfTxServiceNotLess
USBCtrlTrfTxServiceNotEQ1
	movlw	SHORT_PKT_PENDING
	cpfseq	shortPacketStatus
        bra	USBCtrlTrfTxServiceNotLess
	movlw	SHORT_PKT_SENT
	movwf	shortPacketStatus
        bra	USBCtrlTrfTxServiceNotLess
USBCtrlTrfTxServiceGreater
	movlw	low USB_EP0_BUFF_SIZE	; Send buffer full of bytes
	movwf	usb_temp
	movlw	high USB_EP0_BUFF_SIZE
	movwf	usb_temp + 1
USBCtrlTrfTxServiceNotLess

;    /*
;     * Next, load the number of bytes to send to BC9..0 in buffer descriptor
;     */
;    #if defined(__18CXX)
;        pBDTEntryIn[0]->STAT.BC9 = 0;
;        pBDTEntryIn[0]->STAT.BC8 = 0;
	movf	ep0Bi + Stat, W		; Get full Stat byte
	andlw	0xfc			; Clear bottom bits
;    #endif
;    pBDTEntryIn[0]->STAT.Val |= byteToSend.byte.HB;
	iorwf	usb_temp + 1, W		; Put in high bits of bytes to send
	movwf	ep0Bi + Stat		; Save it out
;    pBDTEntryIn[0]->CNT = byteToSend.byte.LB;
	movf	usb_temp, W		; Get actual bytes to be sent from the buffer for subtract
	movwf	ep0Bi + Cnt		; Save low number of bytes to send while we're here

;    /*
;     * Subtract the number of bytes just about to be sent from the total.
;     */
;    inPipes[0].wCount.Val = inPipes[0].wCount.Val - byteToSend.Val;
;	movf	usb_temp, W		; Subtract actual bytes to be sent from the buffer
	subwf	inCount, F
	movf	usb_temp + 1, W
	subwfb	inCount + 1, F

;    pDst = (BYTE*)CtrlTrfData;        // Set destination pointer
	lfsr	2, CtrlTrfData		; Set destination pointer

	movf	usb_temp + 1, W		; Check high byte for 0
	iorwf	usb_temp, W		; Check low byte for 0
	bz	USBCtrlTrfTxServiceExit	; If both 0 then nothing to send this time
;    if(inPipes[0].info.bits.ctrl_trf_mem == USB_INPIPES_ROM)       // Determine type of memory source
	btfsc	info, ctrl_trf_mem	; ROM or RAM?
	bra	USBCtrlTrfTxServiceRam	; RAM
;    {
;        while(byteToSend.Val)
;        {
;            *pDst++ = *inPipes[0].pSrc.bRom++;
;            byteToSend.Val--;
;        }//end while(byte_to_send.Val)
	movff	pSrc, TBLPTRL		; Move source pointer to TBLPTR
	movff	pSrc + 1, TBLPTRH
	movff	pSrc + 2, TBLPTRU
USBCtrlTrfTxServiceRomLoop
	tblrd	*+
	movff	TABLAT, POSTINC2	; Copy one buffer to the other
	tblrd	*+			; Skip retlw in high location
	decf	usb_temp, F		; Count down number of bytes
	bnz	USBCtrlTrfTxServiceRomLoop
	decf	usb_temp + 1, F
	bc	USBCtrlTrfTxServiceRomLoop
	movff	TBLPTRL, pSrc		; Update source pointer
	movff	TBLPTRH, pSrc + 1
	movff	TBLPTRU, pSrc + 2
	return
;    }
;    else  // RAM
USBCtrlTrfTxServiceRam
;    {
;        while(byteToSend.Val)
;        {
;            *pDst++ = *inPipes[0].pSrc.bRam++;
;            byteToSend.Val--;
;        }//end while(byte_to_send.Val)
	movff	pSrc, FSR1L		; Move source pointer to FSR1
	movff	pSrc + 1, FSR1H
USBCtrlTrfTxServiceRamLoop
	movff	POSTINC1, POSTINC2	; Copy one buffer to the other
	decf	usb_temp, F		; Count down number of bytes
	bnz	USBCtrlTrfTxServiceRamLoop
	decf	usb_temp + 1, F
	bc	USBCtrlTrfTxServiceRamLoop
	movff	FSR1L, pSrc		; Update source pointer
	movff	FSR1H, pSrc + 1
USBCtrlTrfTxServiceExit
	return
;    }//end if(usb_stat.ctrl_trf_mem == _ROM)

;}//end USBCtrlTrfTxService

;/******************************************************************************
; * Function:        void USBCtrlTrfRxService(void)
; *
; * PreCondition:    pDst and wCount are setup properly.
; *                  pSrc is always &CtrlTrfData
; *                  usb_stat.ctrl_trf_mem is always _RAM.
; *                  wCount should be set to 0 at the start of each control
; *                  transfer.
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        *** This routine is only partially complete. Check for
; *                  new version of the firmware.
; *
; * Note:            None
; *****************************************************************************/
;void USBCtrlTrfRxService(void)
USBCtrlTrfRxService
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;    BYTE byteToRead;
;    BYTE i;

;    byteToRead = pBDTEntryEP0OutCurrent->CNT;
	movf	ep0Bo + Cnt, W
	movwf	usb_temp

;    /*
;     * Accumulate total number of bytes read
;     */
;    if(byteToRead > outPipes[0].wCount.Val)
	tstfsz	outCount + 1	; If high byte isn't 0 then not less than
	bra	USBCtrlTrfRxService1
	movf	outCount, W	; Get low byte
	cpfslt	usb_temp
;    {
;        byteToRead = outPipes[0].wCount.Val;
	movwf	usb_temp
;    }
;    else
USBCtrlTrfRxService1
;    {
;        outPipes[0].wCount.Val = outPipes[0].wCount.Val - byteToRead;
	movf	usb_temp, W
	subwf	outCount, F
        btfss   STATUS, C
	decf	outCount + 1, F
;    }
;old    inPipes[0].wCount.Val = inPipes[0].wCount.Val + byteToRead.Val;
;	movf	ep0Bo + Cnt, W		; Get low number of bytes to read
;	movwf	usb_temp		; usb_temp & usb_temp + 1 are bytes to read
;	addwf	outCount, F		; Accumulate total number of bytes read
;;	movf	ep0Bo + Stat, W		; Get high bits to read
;;	andlw	0x03			; Mask to the count
;;	movwf	usb_temp + 1		; Save to high byte of bytes to read
;	movlw	0
;	addwfc	outCount + 1, F		; Add overflow from low byte (C) and high byte to total number

;    for(i=0;i<byteToRead;i++)
;    {
;        *outPipes[0].pDst.bRam++ = CtrlTrfData[i];
;    }//end while(byteToRead.Val)
	lfsr	1, CtrlTrfData		; Point FSR1 to source
	movff	pDst, FSR2L		; Move destination pointer to FSR2
	movff	pDst + 1, FSR2H
	movf	usb_temp, W		; Check low byte for 0
;	iorwf	usb_temp+ 1, W		; Check high byte for 0
	bz	USBCtrlTrfRxServiceExit	; If both 0 then nothing to send this time
USBCtrlTrfRxServiceLoop
	movff	POSTINC1, POSTINC2	; Copy one buffer to the other
	decf	usb_temp, F		; Count down number of bytes
	bnz	USBCtrlTrfRxServiceLoop
;	decf	usb_temp + 1, F
;	bc	USBCtrlTrfRxServiceLoop
	movff	FSR2L, pDst		; Update destination pointer
	movff	FSR2H, pDst + 1
USBCtrlTrfRxServiceExit

;    //If there is more data to read
;    if(outPipes[0].wCount.Val > 0)
	movf	outCount + 1, W		; Check high byte for 0
	iorwf	outCount, W		; Check low byte for 0
	bz	USBCtrlTrfRxService2
;    {
;        /*
;         * Don't have to worry about overwriting _KEEP bit
;         * because if _KEEP was set, TRNIF would not have been
;         * generated in the first place.
;         */
;        pBDTEntryEP0OutNext->CNT = USB_EP0_BUFF_SIZE;
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movlw	USB_EP0_BUFF_SIZE
	movwf	ep0Bo + Cnt
;        pBDTEntryEP0OutNext->ADR = (BYTE*)&CtrlTrfData;
	movlw	low CtrlTrfData
	movwf	ep0Bo + ADRL
	movlw	high CtrlTrfData
	movwf	ep0Bo + ADRH
;        if(pBDTEntryEP0OutCurrent->STAT.DTS == 0)
;        {
;            pBDTEntryEP0OutNext->STAT.Val = _USIE|_DAT1|_DTSEN;
;        }
;        else
;        {
;            pBDTEntryEP0OutNext->STAT.Val = _USIE|_DAT0|_DTSEN;
;        }
	btg	ep0Bo + Stat, DTS
;	movlw	_USIE|_DAT1|_DTSEN
;	btfsc	ep0Bo + Stat, DTS
;	movlw	_USIE|_DAT0|_DTSEN
;	movwf	ep0Bo + Stat
	return
;    }
;    else
USBCtrlTrfRxService2
;    {
;        pBDTEntryEP0OutNext->ADR = (BYTE*)&SetupPkt;
	movlw	low SetupPkt
	movwf	ep0Bo + ADRL
	movlw	high SetupPkt
	movwf	ep0Bo + ADRH
;        if(outPipes[0].pFunc != NULL)
;        {
;            outPipes[0].pFunc();
;        }
;        outPipes[0].info.bits.busy = 0;
	bcf	outfo, busy
;    }

;    // reset ep0Bo.Cnt to USB_EP0_BUFF_SIZE

	return
;}//end USBCtrlTrfRxService

;/********************************************************************
; * Function:        void USBStdSetCfgHandler(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This routine first disables all endpoints by
; *                  clearing UEP registers. It then configures
; *                  (initializes) endpoints by calling the callback
; *                  function USBCBInitDevClass().
; *
; * Note:            None
; *******************************************************************/
;void USBStdSetCfgHandler(void)
USBStdSetCfgHandler
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;    // This will generate a zero length packet
;    inPipes[0].info.bits.busy = 1;
	bsf	info, busy

;    //disable all endpoints except endpoint 0
;    memset((void*)&U1EP1,0x00,(USB_MAX_EP_NUMBER-1));
	lfsr	2, UEP1			; Reset all non-EP0 UEPn registers
	movlw	USB_MAX_EP_NUMBER
USBStdSetCfgHandlerClearEPLoop
	clrf	POSTINC2
	decfsz	WREG, F
	bra	USBStdSetCfgHandlerClearEPLoop

;    //clear the alternate interface settings
;    memset((void*)&USBAlternateInterface,0x00,USB_MAX_NUM_INT);
	lfsr	2, USBAlternateInterface	; Clear usb_alt_intf array
	movlw	USB_MAX_NUM_INT
USBStdSetCfgHandlerClearAltLoop
	clrf	POSTINC2
	decfsz	WREG, F
	bra	USBStdSetCfgHandlerClearAltLoop

;    //set the current configuration
;    USBActiveConfiguration = SetupPkt.bConfigurationValue;
	movf	SetupPkt + bConfigurationValue, W
	movwf	USBActiveConfiguration

;    //if the configuration value == 0
;    if(SetupPkt.bConfigurationValue == 0)
	bnz	USBStdSetCfgHandler1
;    {
;        //Go back to the addressed state
;        USBDeviceState = ADDRESS_STATE;
	movlw	ADDRESS_STATE		; SetupPkt + bCfgValue = 0
	movwf	USBDeviceState
	return
;    }
;    else
USBStdSetCfgHandler1
;    {
;        //Otherwise go to the configured state
;        USBDeviceState = CONFIGURED_STATE;
	movlw	CONFIGURED_STATE
	movwf	USBDeviceState
;        //initialize the required endpoints
;        USBInitEP((BYTE ROM*)(USB_CD_Ptr[USBActiveConfiguration-1]));
;        USBCBInitEP();
	bra	USBCBInitEP

;    }//end if(SetupPkt.bConfigurationValue == 0)
;}//end USBStdSetCfgHandler

;/********************************************************************
; * Function:        void USBConfigureEndpoint(BYTE EPNum, BYTE direction)
; *
; * PreCondition:    None
; *
; * Input:           BYTE EPNum - the endpoint to be configured
; *                  BYTE direction - the direction to be configured
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This function will configure the specified 
; *                  endpoint
; *
; * Note:            None
; *******************************************************************/
;void USBConfigureEndpoint(BYTE EPNum, BYTE direction)
;{
;    volatile BDT_ENTRY* handle;

;    handle = (volatile BDT_ENTRY*)&BDT[EP0_OUT_EVEN];
;    handle += BD(EPNum,direction,0)/sizeof(BDT_ENTRY);

;    handle->STAT.UOWN = 0;

;    if(direction == 0)
;    {
;        pBDTEntryOut[EPNum] = handle;
;    }
;    else
;    {
;        pBDTEntryIn[EPNum] = handle;
;    }

;    #if (USB_PING_PONG_MODE == USB_PING_PONG__FULL_PING_PONG)
;        handle->STAT.DTS = 0;
;        (handle+1)->STAT.DTS = 1;
;    #elif (USB_PING_PONG_MODE == USB_PING_PONG__NO_PING_PONG)
;        //Set DTS to one because the first thing we will do
;        //when transmitting is toggle the bit
;        handle->STAT.DTS = 1;
;    #elif (USB_PING_PONG_MODE == USB_PING_PONG__EP0_OUT_ONLY)
;        if(EPNum != 0)
;        {
;            handle->STAT.DTS = 1;
;        }
;    #elif (USB_PING_PONG_MODE == USB_PING_PONG__ALL_BUT_EP0)    
;        if(EPNum != 0)
;        {
;            handle->STAT.DTS = 0;
;            (handle+1)->STAT.DTS = 1;
;        }
;    #endif
;}

;/********************************************************************
; * Function:        void USBEnableEndpoint(BYTE ep, BYTE options)
; *
; * PreCondition:    None
; *
; * Input:
; *   BYTE ep - the endpoint to be configured
; *   BYTE options - optional settings for the endpoint.
; *        The options should be ORed together to form a 
; *        single options string.  The available options:
; *
; *        USB_HANDSHAKE_ENABLED - enable USB handshaking (ACK, NAK)
; *        USB_HANDSHAKE_DISABLED - disable USB handshaking (ACK, NAK)
; *        USB_OUT_ENABLED - enable the out direction
; *        USB_OUT_DISABLED - disable the out direction
; *        USB_IN_ENABLED - enable the in direction
; *        USB_IN_DISABLED - disable the in direction
; *        USB_ALLOW_SETUP - enable control transfers
; *        USB_DISALLOW_SETUP - disable control transfers
; *        USB_STALL_ENDPOINT - STALL this endpoint
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This function will enable the specified 
; *                  endpoint with the specified options
; *
; * Note:            None
; *******************************************************************/
;void USBEnableEndpoint(BYTE ep, BYTE options)
;{
;    //Set the options to the appropriate endpoint control register
;    //*((unsigned char*)(&U1EP0+ep)) = options;
;    {
;        unsigned int* p;

;        p = (unsigned int*)(&U1EP0+ep);
;        *p = options;
;    }
;    if(options & USB_OUT_ENABLED)
;    {
;        USBConfigureEndpoint(ep,0);
;    }
;    if(options & USB_IN_ENABLED)
;    {
;        USBConfigureEndpoint(ep,1);
;    }
;}

;  Enable and configure OUT endpoint
; Input:
;  FSR0L is endpoint number
;  FSR1 is endpoint buffer address
;  usb_temp is options
;  W is endpoint buffer size
; Returns:
;  Nada
; Uses
;  FSR0 is BDT pointer
;  FSR1 is endpoint buffer pointer
;  FSR2 is endpoint table pointer

USBEnableEndpointOut
; Save maximum count at front of endpoint buffer and move buffer pointer up
	movwf	POSTINC1		; Store maximum count at front of endpoint buffer and move up pointer

; Point FSR2 to endpoint table
	lfsr	2, UEP0			; FSR2 = beginning of endpoint table
	movf	FSR0L, W		; Add in endpoint number
	addwf	FSR2L, F

; Enable Out endpoint
	movf	usb_temp, W		; Options to W
	movwf	INDF2			; Options to endpoint table

; Point FSR0 to endpoint BDT
	rlncf	FSR0L, W		; Endpoint number * 8
	rlncf	WREG, F
	rlncf	WREG, F
	lfsr	0, ep0Bo		; Point FSR0 to beginning of BDT area
	addwf	FSR0L, F		; Add endpoint offset to FSR0 (can't overflow to FSR0H)

; Set endpoint buffer address from FSR1 + 1
	movlw	ADRL			; Point to ADRL
	movff	FSR1L, PLUSW0
	movlw	ADRH			; Point to ADRH
	movff	FSR1H, PLUSW0

; Set Cnt to maximum count
	movf	POSTDEC1, W		; Back up endpoint buffer pointer (no PREDEC1!)
	incf	FSR0L, F		; Point to Cnt
	movff	INDF1, POSTDEC0		; Set maximum count and point back to Stat

; Set endpoint status
	bcf	INDF0, UOWN
	bsf	INDF0, DTS
	return

;  Enable and configure IN endpoint
; Input:
;  FSR0L is endpoint number
;  FSR1 is endpoint buffer address
;  usb_temp is options
;  W is endpoint buffer size
; Returns:
;  Nada
; Uses
;  FSR0 is BDT pointer
;  FSR1 is endpoint buffer pointer
;  FSR2 is endpoint table pointer

USBEnableEndpointIn
; Save maximum count at front of endpoint buffer and move buffer pointer up (no need to put in Cnt for In)
	movwf	POSTINC1		; Store maximum count at front of endpoint buffer and move up pointer

; Point FSR2 to endpoint table
	lfsr	2, UEP0			; FSR2 = beginning of endpoint table
	movf	FSR0L, W		; Add in endpoint number
	addwf	FSR2L, F

; Enable In endpoint
	movf	usb_temp, W		; Options to W
	movwf	INDF2			; Options to endpoint table

; Point FSR0 to endpoint BDT
	rlncf	FSR0L, W		; Endpoint number * 8
	rlncf	WREG, F
	rlncf	WREG, F
	lfsr	0, ep0Bi		; Point FSR0 to beginning of BDT area
	addwf	FSR0L, F		; Add endpoint offset to FSR0 (can't overflow to FSR0H)

; Set endpoint buffer address from FSR1
	movlw	ADRL			; Point to ADRL
	movff	FSR1L, PLUSW0
	movlw	ADRH			; Point to ADRH
	movff	FSR1H, PLUSW0

; Set endpoint status
	bcf	INDF0, UOWN
	bsf	INDF0, DTS
	return

;/********************************************************************
; * Function:        void USBStallEndpoint(BYTE ep, BYTE dir)
; *
; * PreCondition:    None
; *
; * Input:
; *   BYTE ep - the endpoint the data will be transmitted on
; *   BYTE dir - the direction of the transfer
; *
; * Output:          None
; *
; * Side Effects:    Endpoint is STALLed
; *
; * Overview:        STALLs the specified endpoint
; *
; * Note:            None
; *******************************************************************/
;void USBStallEndpoint(BYTE ep, BYTE dir)
;USBStallEndpoint
;{
;    BDT_ENTRY *p;

;    if(ep == 0)
;	tstfsz	ep
;	bra	USBStallEndpoint1
;    {
;        /*
;         * If no one knows how to service this request then stall.
;         * Must also prepare EP0 to receive the next SETUP transaction.
;         */
;        pBDTEntryEP0OutNext->CNT = USB_EP0_BUFF_SIZE;
;	movlw	USB_EP0_BUFF_SIZE
;	movwf	ep0Bo + Cnt
;        pBDTEntryEP0OutNext->ADR = (BYTE*)&SetupPkt;
;	movlw	low SetupPkt
;	movwf	ep0Bo + ADRL
;	movlw	high SetupPkt
;	movwf	ep0Bo + ADRH

;        /* v2b fix */
;        pBDTEntryEP0OutNext->STAT.Val = _USIE|_DAT0|_DTSEN|_BSTALL;
;	movlw	_USIE|_DAT0|_DTSEN|_BSTALL
;	movwf	ep0Bo + Stat
;        pBDTEntryIn[0]->STAT.Val = _USIE|_BSTALL; 
;	movlw	_USIE|_BSTALL
;	movwf	ep0Bi + Stat
;	return
;    }
USBStallEndpoint1
;    else
;    {
;        p = (BDT_ENTRY*)(&BDT[EP(ep,dir,0)]);
;	lfsr	0, ep0Bo		; Point FSR0 to beginning of out BDT area
;	tstfsz	dir
;	lfsr	0, ep0Bi		; Point FSR0 to beginning of in BDT area
;	rlncf	ep, W			; Endpoint number * 8
;	rlncf	WREG, F
;	rlncf	WREG, F
;	addwf	FSR0L, F		; Add endpoint offset to FSR0 (can't overflow to FSR0H)
;        p->STAT.Val |= _BSTALL | _USIE;
;	movlw	_BSTALL | _USIE
;	iorwf	INDF0, F

;        //If the device is in FULL or ALL_BUT_EP0 ping pong modes
;        //then stall that entry as well
;        #if (USB_PING_PONG_MODE == USB_PING_PONG__FULL_PING_PONG) || \
;            (USB_PING_PONG_MODE == USB_PING_PONG__ALL_BUT_EP0)
    
;        p = (BDT_ENTRY*)(&BDT[EP(ep,dir,1)]);
;        p->STAT.Val |= _BSTALL | _USIE;
;        #endif
;    }
;	return
;}

;/********************************************************************
; * Function:        USB_HANDLE USBTransferOnePacket(
; *                      BYTE ep, 
; *                      BYTE dir, 
; *                      BYTE* data, 
; *                      BYTE len)
; *
; * PreCondition:    None
; *
; * Input:
; *   BYTE ep - the endpoint the data will be transmitted on
; *   BYTE dir - the direction of the transfer
;                This value is either OUT_FROM_HOST or IN_TO_HOST
; *   BYTE* data - pointer to the data to be sent
; *   BYTE len - length of the data needing to be sent
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        Transfers one packet over the USB
; *
; * Note:            None
; *******************************************************************/
;USB_HANDLE USBTransferOnePacket(BYTE ep,BYTE dir,BYTE* data,BYTE len)
;{
;    USB_HANDLE handle;

;    //If the direction is IN
;    if(dir != 0)
;    {
;        //point to the IN BDT of the specified endpoint
;        handle = pBDTEntryIn[ep];
;    }
;    else
;    {
;        //else point to the OUT BDT of the specified endpoint
;        handle = pBDTEntryOut[ep];
;    }

;    //Toggle the DTS bit if required
;    #if (USB_PING_PONG_MODE == USB_PING_PONG__NO_PING_PONG)
;        handle->STAT.Val ^= _DTSMASK;
;    #elif (USB_PING_PONG_MODE == USB_PING_PONG__EP0_OUT_ONLY)
;        if(ep != 0)
;        {
;            handle->STAT.Val ^= _DTSMASK;
;        }
;    #endif

;    //Set the data pointer, data length, and enable the endpoint
;    handle->ADR = data;

;    handle->CNT = len;
;    handle->STAT.Val &= _DTSMASK;
;    handle->STAT.Val |= _USIE | _DTSEN;

;    //Point to the next buffer for ping pong purposes.
;    if(dir != 0)
;    {
;        //toggle over the to the next buffer for an IN endpoint
;        ((BYTE_VAL*)&pBDTEntryIn[ep])->Val ^= USB_NEXT_PING_PONG;
;    }
;    else
;    {
;        //toggle over the to the next buffer for an OUT endpoint
;        ((BYTE_VAL*)&pBDTEntryOut[ep])->Val ^= USB_NEXT_PING_PONG;
;    }
;    return handle;
;}

;  Get from OUT endpoint for RX
; Input:
;  FSR0L is endpoint number
;  FSR1 is destination buffer pointer
;  W is max buffer length
; Returns:
;  FSR1 is updated destination buffer pointer
;  W returns number received
;  Carry is clear for buffer not available
; Uses
;  FSR0 is BDT pointer
;  FSR1 is destination buffer pointer
;  FSR2 is endpoint buffer pointer
;  R0 in BANKA is temporary length storage

USBRxOnePacket
GetUSB
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movwf	usb_temp		; Save max buffer length

; Check to see if we're configured
	movlw	CONFIGURED_STATE	; We might not be configured yet
	subwf	USBDeviceState, W
	movlw	0			; 0 characters received, so far
	bcf	STATUS, C		; Clear Carry for possible error return
	bnz	GetUSBNotReady		; We're not configured

; Point FSR0 to requested endpoint Out BDT
	rlncf	FSR0L, W		; Endpoint number * 8
	rlncf	WREG, F
	rlncf	WREG, F
	lfsr	0, ep0Bo		; Point FSR0 to beginning of BDT area
	addwf	FSR0L, F		; Add endpoint offset to FSR0 (can't overflow to FSR0H)

	movlw	0			; 0 characters received, so far
	bcf	STATUS, C		; Clear Carry for possible error return
	btfsc	INDF0, UOWN		; Who owns the buffer (Stat, UOWN)?
GetUSBNotReady
	return				; Busy (we don't)

; Get endpoint buffer address to FSR2
	movlw	ADRL			; Point to ADRL
	movff	PLUSW0, FSR2L
	movlw	ADRH			; Point to ADRH
	movff	PLUSW0, FSR2H

	movf	PREINC0, W		; Get Cnt
	cpfslt	usb_temp		; Make sure it's not longer than the buffer
	movwf	usb_temp		; It's OK, save returned length

	movlw	-1
	movf	PLUSW2, W		; Get maximum length from in front of endpoint buffer
	movwf	POSTDEC0		; Reset max length and point back to Stat

	movf	usb_temp, W		; Get count to W
	bz	GetPutUSBZero		; Nothing received

GetUSBLoop
	movff	POSTINC2, POSTINC1	; Copy endpoint buffer to destination buffer
	decfsz	WREG, F			; Count down number of bytes
	bra	GetUSBLoop

GetPutUSBZero
	movlw	_DTSMASK		; Save only DTS bit
	andwf	INDF0, F
	btg	INDF0, DTS		; Toggle DTS bit
	movlw	_USIE|_DTSEN		; Turn ownership to SIE
	iorwf	INDF0, F
	movf	usb_temp, W		; Return number of bytes received
	bsf	STATUS, C		; Set Carry for non-error return
	return

;  Fill IN endpoint for TX
; Input:
;  FSR0L is endpoint number
;  FSR1 is source buffer pointer
;  W is count
; Returns:
;  FSR1 is updated source buffer pointer
;  W returns number sent
;  Carry is clear for buffer not available
; Uses:
;  FSR0 is BDT pointer
;  FSR1 is source buffer pointer
;  FSR2 is endpoint buffer pointer
;  R0 in BANKA is temporary length storage

USBTxOnePacket
PutUSB
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movwf	usb_temp		; Save count

; Check to see if we're configured
	movlw	CONFIGURED_STATE	; We might not be configured yet
	subwf	USBDeviceState, W
	movlw	0			; 0 characters sent, so far
	bcf	STATUS, C		; Clear Carry for possible error return
	bnz	PutUSBNotReady		; We're not configured

; Point FSR0 to requested endpoint In BDT
	rlncf	FSR0L, W		; Endpoint number * 8
	rlncf	WREG, F
	rlncf	WREG, F
	lfsr	0, ep0Bi		; Point FSR0 to beginning of BDT area
	addwf	FSR0L, F		; Add endpoint offset to FSR0 (can't overflow to FSR0H)

	movlw	0			; 0 characters sent, so far
	bcf	STATUS, C		; Clear Carry for possible error return
	btfsc	INDF0, UOWN		; Who owns the buffer (Stat, UOWN)?
PutUSBNotReady
	return				; Busy (we don't)

; Get endpoint buffer address to FSR2
	movlw	ADRL			; Point to ADRL
	movff	PLUSW0, FSR2L
	movlw	ADRH			; Point to ADRH
	movff	PLUSW0, FSR2H

	movlw	-1
	movf	PLUSW2, W		; Get maximum length from in front of endpoint buffer

	cpfslt	usb_temp		; Find number of bytes to send this time
	movwf	usb_temp		; Too big - send maximum allowed length

	incf	FSR0L, F		; Point to Cnt
	movf	usb_temp, W		; Get number to send
	movwf	POSTDEC0		; Put length into Cnt and point back to Stat
	bz	GetPutUSBZero		; Zero to send

PutUSBLoop
	movff	POSTINC1, POSTINC2	; Copy source buffer to endpoint buffer
	decfsz	WREG, F			; Count down number of bytes to transfer
	bra	PutUSBLoop
	bra	GetPutUSBZero

;/********************************************************************
; * Function:        void USBClearInterruptFlag(BYTE* reg, BYTE flag)
; *
; * PreCondition:    None
; *
; * Input:           
; *   BYTE* reg - the register address holding the interrupt flag
; *   BYTE flag - the bit number needing to be cleared
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        clears the specified interrupt flag.
; *
; * Note:            
; *******************************************************************/
;void USBClearInterruptFlag(BYTE* reg, BYTE flag)
;{
;    #if defined(__18CXX)
;        *reg &= ~(0x01<<flag);
;    #elif defined(__C30__)
;        *reg = (0x01<<flag);        
;    #endif
;}
;/** EOF USBDevice.c *****************************************************/
