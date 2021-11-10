; usb_hid.asm
; 10/08/08 microEngineering Labs, Inc.

	include	"usb_hid.inc"	; Include our header file
	include	"usb_dev.asm"	; Include the main USB routines

;/********************************************************************
; FileName:     	usb_function_hid.c
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

; Software License Agreement:

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

;********************************************************************
; File Description:

; Change History:
;  Rev   Date         Description
;  1.0   11/19/2004   Initial release
;  2.1   02/26/2007   Updated for simplicity and to use common
;                     coding style
;*******************************************************************/

;/** INCLUDES *******************************************************/
;#include "GenericTypeDefs.h"
;#include "Compiler.h"
;#include "usb_config.h"
;#include "./USB/usb_device.h"
;#include "./USB/usb_function_hid.h"

;/** VARIABLES ******************************************************/
;#pragma udata
;BYTE idle_rate;
;BYTE active_protocol;   // [0] Boot Protocol [1] Report Protocol
;BYTE hid_rpt_rx_len;

;/** PRIVATE PROTOTYPES *********************************************/
;void HIDGetReportHandler(void);
;void HIDSetReportHandler(void);

;/** DECLARATIONS ***************************************************/
;#pragma code

;/** CLASS SPECIFIC REQUESTS ****************************************/
;/********************************************************************
; * Function:        void USBCheckHIDRequest(void)
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
;void USBCheckHIDRequest(void)
USBCheckHIDRequest
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;    if(SetupPkt.Recipient != RCPT_INTF) return;
	movf	SetupPkt, W		; Recipient = RCPT_INTF?
	andlw	0x1f			; Mask to lower 5 bits
	sublw	RCPT_INTF
	bnz	USBCheckHIDRequestExit	; No
;    if(SetupPkt.bIntfID != HID_INTF_ID) return;
	movlw	HID_INTF_ID		; IntfID = HID_INTF_ID?
	cpfseq	SetupPkt + bIntfID
USBCheckHIDRequestExit
	return				; No
    
;    /*
;     * There are two standard requests that hid.c may support.
;     * 1. GET_DSC(DSC_HID,DSC_RPT,DSC_PHY);
;     * 2. SET_DSC(DSC_HID,DSC_RPT,DSC_PHY);
;     */
;    if(SetupPkt.bRequest == GET_DSC)
	movlw	GET_DSC			; Request = GET_DSC?
	cpfseq	SetupPkt + bRequest
	bra	USBCheckHIDRequestClass	; No
;    {
;        switch(SetupPkt.bDescriptorType)
;        {
;            case DSC_HID:           
	movlw	DSC_HID			; DescriptorType = DSC_HID?
	cpfseq	SetupPkt + bDescriptorType
	bra	USBCheckHIDRequest1	; No
;                if(USBActiveConfiguration == 1)
	movlw	1			; USBActiveConfiguration = 1?
	cpfseq	USBActiveConfiguration
	bra	USBCheckHIDRequestClass	; No
;                {
;                    USBEP0SendROMPtr(
;                        (ROM BYTE*)&configDescriptor1 + 18,
;                        sizeof(USB_HID_DSC)+3,     // RRoj hack
;                        USB_EP0_INCLUDE_ZERO);
	mSetSourcePointer HIDDescriptor1
	mGetRomTableCount		; Set wCount
;	clrf	info
	bcf	info, ctrl_trf_mem	; Indicate ROM
	bsf	info, includeZero	; Include a trailing zero packet
	bsf	info, busy
	bra	USBCheckHIDRequestClass
;                }
;                break;
USBCheckHIDRequest1
;            case DSC_RPT:             
	movlw	DSC_RPT			; DescriptorType = DSC_RPT?
	cpfseq	SetupPkt + bDescriptorType
	bra	USBCheckHIDRequest2	; No
;                if(USBActiveConfiguration == 1)
	movlw	1			; USBActiveConfiguration = 1?
	cpfseq	USBActiveConfiguration
	bra	USBCheckHIDRequestClass	; No
;                {
;                    USBEP0SendROMPtr(
;                        (ROM BYTE*)&hid_rpt01,
;                        sizeof(hid_rpt01),     //See usbcfg.h
;                        USB_EP0_INCLUDE_ZERO);
	mSetSourcePointer ReportDescriptor1
	movlw	low (ReportDescriptor1Len)	; Set wCount
	movwf	TBLPTRL
	movlw	high (ReportDescriptor1Len)
	movwf	TBLPTRH
	movlw	upper (ReportDescriptor1Len)
	movwf	TBLPTRU
        tblrd   *+			; Read count low
	movff	TABLAT, inCount
        tblrd   *+			; Skip next
        tblrd   *			; Read count high
	movff	TABLAT, inCount + 1
;	clrf	info
	bcf	info, ctrl_trf_mem	; Indicate ROM
	bsf	info, includeZero	; Include a trailing zero packet
	bsf	info, busy
	bra	USBCheckHIDRequestClass
;                }
;                break;
USBCheckHIDRequest2
;            case DSC_PHY:
	movlw	DSC_PHY			; DescriptorType = DSC_PHY?
	cpfseq	SetupPkt + bDescriptorType
	bra	USBCheckHIDRequestClass
;                USBEP0Transmit(USB_EP0_NO_DATA);
	clrf	info
	bsf	info, busy
;                break;
;        }//end switch(SetupPkt.bDescriptorType)
;    }//end if(SetupPkt.bRequest == GET_DSC)
    
USBCheckHIDRequestClass
;    if(SetupPkt.RequestType != CLASS) return;
	movf	SetupPkt, W		; RequestType = CLASS?
	andlw	0x60			; Mask to proper bits
	sublw	(CLASS) << 5
	bnz	USBCheckHIDRequestExit	; No
;    switch(SetupPkt.bRequest)
;    {
;        case GET_REPORT:
	movlw	GET_REPORT		; Request = GET_REPORT?
	subwf	SetupPkt + bRequest, W
;            HIDGetReportHandler();
	bz	HIDGetReportHandler	; Yes
;            break;
;        case SET_REPORT:
	movlw	SET_REPORT		; Request = SET_REPORT?
	subwf	SetupPkt + bRequest, W
;            HIDSetReportHandler();            
	bz	HIDSetReportHandler	; Yes
;            break;
;        case GET_IDLE:
	movlw	GET_IDLE		; Request = GET_IDLE?
	cpfseq	SetupPkt + bRequest
	bra	USBCheckHIDRequestClass1	; No
;            USBEP0SendRAMPtr(
;                (BYTE*)&idle_rate,
;                1,
;                USB_EP0_INCLUDE_ZERO);
	mSetSourcePointer idle_rate
	movlw	1
	movwf	inCount
	clrf	inCount + 1
;	clrf	info
	bsf	info, ctrl_trf_mem	; Indicate RAM
	bsf	info, includeZero	; Include a trailing zero packet
	bsf	info, busy
	return
;            break;
USBCheckHIDRequestClass1
;        case SET_IDLE:
	movlw	SET_IDLE		; Request = SET_IDLE?
	cpfseq	SetupPkt + bRequest
	bra	USBCheckHIDRequestClass2	; No
;            USBEP0Transmit(USB_EP0_NO_DATA);
	clrf	info
	bsf	info, busy
;            idle_rate = SetupPkt.W_Value.byte.HB;
	movff	SetupPkt + wValue + 1, idle_rate
	return
;            break;
USBCheckHIDRequestClass2
;        case GET_PROTOCOL:
	movlw	GET_PROTOCOL		; Request = GET_PROTOCOL?
	cpfseq	SetupPkt + bRequest
	bra	USBCheckHIDRequestClass3	; No
;            USBEP0SendRAMPtr(
;                (BYTE*)&active_protocol,
;                1,
;                USB_EP0_NO_OPTIONS);
	mSetSourcePointer active_protocol
	movlw	1
	movwf	inCount
	clrf	inCount + 1
	clrf	info
	bsf	info, ctrl_trf_mem	; Indicate RAM
	bsf	info, busy
	return
;            break;
USBCheckHIDRequestClass3
;        case SET_PROTOCOL:
	movlw	SET_PROTOCOL		; Request = SET_PROTOCOL?
	cpfseq	SetupPkt + bRequest
	return				; No
;            USBEP0Transmit(USB_EP0_NO_DATA);
	clrf	info
	bsf	info, busy
;            active_protocol = SetupPkt.W_Value.byte.LB;
	movff	SetupPkt + wValue, active_protocol
;            break;
;    }//end switch(SetupPkt.bRequest)
	return
;}//end USBCheckHIDRequest

;void HIDGetReportHandler(void)
HIDGetReportHandler
;{
	return
;}//end HIDGetReportHandler

;void HIDSetReportHandler(void)
HIDSetReportHandler
;{
	return
;}//end HIDSetReportHandler

;/** USER API *******************************************************/

;/********************************************************************
; * Function:        void HIDInitEP(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        HIDInitEP initializes HID endpoints, buffer
; *                  descriptors, internal state-machine, and
; *                  variables. It should be called after the USB
; *                  host has sent out a SET_CONFIGURATION request.
; *                  See USBStdSetCfgHandler() in usbd.c for examples.
; *
; * Note:            None
; *******************************************************************/
;#if !defined(USB_DYNAMIC_EP_CONFIG)
;void HIDInitEP(void)
;{   
;}//end HIDInitEP
;#endif

;// ******************************************************************************************************
;// ************** USB Callback Functions ****************************************************************
;// ******************************************************************************************************
;// The USB firmware stack will call the callback functions USBCBxxx() in response to certain USB related
;// events.  For example, if the host PC is powering down, it will stop sending out Start of Frame (SOF)
;// packets to your device.  In response to this, all USB devices are supposed to decrease their power
;// consumption from the USB Vbus to <2.5mA each.  The USB module detects this condition (which according
;// to the USB specifications is 3+ms of no bus activity/SOF packets) and then calls the USBCBSuspend()
;// function.  You should modify these callback functions to take appropriate actions for each of these
;// conditions.  For example, in the USBCBSuspend(), you may wish to add code that will decrease power
;// consumption from Vbus to <2.5mA (such as by clock switching, turning off LEDs, putting the
;// microcontroller to sleep, etc.).  Then, in the USBCBWakeFromSuspend() function, you may then wish to
;// add code that undoes the power saving things done in the USBCBSuspend() function.

;// The USBCBSendResume() function is special, in that the USB stack will not automatically call this
;// function.  This function is meant to be called from the application firmware instead.  See the
;// additional comments near the function.

;/******************************************************************************
; * Function:        void USBCBSuspend(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        Call back that is invoked when a USB suspend is detected
; *
; * Note:            None
; *****************************************************************************/
;void USBCBSuspend(void)
USBCBSuspend
;{
;	//Example power saving code.  Insert appropriate code here for the desired
;	//application behavior.  If the microcontroller will be put to sleep, a
;	//process similar to that shown below may be used:
	
;	//ConfigureIOPinsForLowPower();
;	//SaveStateOfAllInterruptEnableBits();
;	//DisableAllInterruptEnableBits();
;	//EnableOnlyTheInterruptsWhichWillBeUsedToWakeTheMicro();	//should enable at least USBActivityIF as a wake source
;	//Sleep();
;	//RestoreStateOfAllPreviouslySavedInterruptEnableBits();	//Preferrably, this should be done in the USBCBWakeFromSuspend() function instead.
;	//RestoreIOPinsToNormal();									//Preferrably, this should be done in the USBCBWakeFromSuspend() function instead.

;	//IMPORTANT NOTE: Do not clear the USBActivityIF (ACTVIF) bit here.  This bit is 
;	//cleared inside the usb_device.c file.  Clearing USBActivityIF here will cause 
;	//things to not work as intended.	
	

;    #if defined(__C30__)
;    #if 0
;        U1EIR = 0xFFFF;
;        U1IR = 0xFFFF;
;        U1OTGIR = 0xFFFF;
;        IFS5bits.USB1IF = 0;
;        IEC5bits.USB1IE = 1;
;        U1OTGIEbits.ACTVIE = 1;
;        U1OTGIRbits.ACTVIF = 1;
;        TRISA &= 0xFF3F;
;        LATAbits.LATA6 = 1;
;        Sleep();
;        LATAbits.LATA6 = 0;
;    #endif
;    #endif
	return
;}


;/******************************************************************************
; * Function:        void _USB1Interrupt(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This function is called when the USB interrupt bit is set
; *					In this example the interrupt is only used when the device
; *					goes to sleep when it receives a USB suspend command
; *
; * Note:            None
; *****************************************************************************/
;#if 0
;void __attribute__ ((interrupt)) _USB1Interrupt(void)
;{
;    #if !defined(self_powered)
;        if(U1OTGIRbits.ACTVIF)
;        {
;            LATAbits.LATA7 = 1;
;        
;            IEC5bits.USB1IE = 0;
;            U1OTGIEbits.ACTVIE = 0;
;            IFS5bits.USB1IF = 0;
;        
;            //USBClearInterruptFlag(USBActivityIFReg,USBActivityIFBitNum);
;            USBClearInterruptFlag(USBIdleIFReg,USBIdleIFBitNum);
;            //USBSuspendControl = 0;
;            LATAbits.LATA7 = 0;
;        }
;    #endif
;}
;#endif

;/******************************************************************************
; * Function:        void USBCBWakeFromSuspend(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        The host may put USB peripheral devices in low power
; *					suspend mode (by "sending" 3+ms of idle).  Once in suspend
; *					mode, the host may wake the device back up by sending non-
; *					idle state signalling.
; *					
; *					This call back is invoked when a wakeup from USB suspend 
; *					is detected.
; *
; * Note:            None
; *****************************************************************************/
;void USBCBWakeFromSuspend(void)
USBCBWakeFromSuspend
;{
;	// If clock switching or other power savings measures were taken when
;	// executing the USBCBSuspend() function, now would be a good time to
;	// switch back to normal full power run mode conditions.  The host allows
;	// a few milliseconds of wakeup time, after which the device must be 
;	// fully back to normal, and capable of receiving and processing USB
;	// packets.  In order to do this, the USB module must receive proper
;	// clocking (IE: 48MHz clock must be available to SIE for full speed USB
;	// operation).
	return
;}

;/********************************************************************
; * Function:        void USBCB_SOF_Handler(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        The USB host sends out a SOF packet to full-speed
; *                  devices every 1 ms. This interrupt may be useful
; *                  for isochronous pipes. End designers should
; *                  implement callback routine as necessary.
; *
; * Note:            None
; *******************************************************************/
;void USBCB_SOF_Handler(void)
USBCB_SOF_Handler
;{
;    // No need to clear UIRbits.SOFIF to 0 here.
;    // Callback caller is already doing that.
	return
;}

;/*******************************************************************
; * Function:        void USBCBErrorHandler(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        The purpose of this callback is mainly for
; *                  debugging during development. Check UEIR to see
; *                  which error causes the interrupt.
; *
; * Note:            None
; *******************************************************************/
;void USBCBErrorHandler(void)
USBCBErrorHandler
;{
;    // No need to clear UEIR to 0 here.
;    // Callback caller is already doing that.

;	// Typically, user firmware does not need to do anything special
;	// if a USB error occurs.  For example, if the host sends an OUT
;	// packet to your device, but the packet gets corrupted (ex:
;	// because of a bad connection, or the user unplugs the
;	// USB cable during the transmission) this will typically set
;	// one or more USB error interrupt flags.  Nothing specific
;	// needs to be done however, since the SIE will automatically
;	// send a "NAK" packet to the host.  In response to this, the
;	// host will normally retry to send the packet again, and no
;	// data loss occurs.  The system will typically recover
;	// automatically, without the need for application firmware
;	// intervention.
	
;	// Nevertheless, this callback function is provided, such as
;	// for debugging purposes.
	return
;}


;/*******************************************************************
; * Function:        void USBCBCheckOtherReq(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        When SETUP packets arrive from the host, some
; * 					firmware must process the request and respond
; *					appropriately to fulfill the request.  Some of
; *					the SETUP packets will be for standard
; *					USB "chapter 9" (as in, fulfilling chapter 9 of
; *					the official USB specifications) requests, while
; *					others may be specific to the USB device class
; *					that is being implemented.  For example, a HID
; *					class device needs to be able to respond to
; *					"GET REPORT" type of requests.  This
; *					is not a standard USB chapter 9 request, and 
; *					therefore not handled by usb_device.c.  Instead
; *					this request should be handled by class specific 
; *					firmware, such as that contained in usb_function_hid.c.
; *
; * Note:            None
; *****************************************************************************/
;void USBCBCheckOtherReq(void)
USBCBCheckOtherReq
;{
;    USBCheckHIDRequest();
	bra	USBCheckHIDRequest
;}//end


;/*******************************************************************
; * Function:        void USBCBStdSetDscHandler(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        The USBCBStdSetDscHandler() callback function is
; *					called when a SETUP, bRequest: SET_DESCRIPTOR request
; *					arrives.  Typically SET_DESCRIPTOR requests are
; *					not used in most applications, and it is
; *					optional to support this type of request.
; *
; * Note:            None
; *****************************************************************************/
;void USBCBStdSetDscHandler(void)
USBCBStdSetDscHandler
;{
;    // Must claim session ownership if supporting this request
	return
;}//end


;/******************************************************************************
; * Function:        void USBCBInitEP(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        This function is called when the device becomes
; *                  initialized, which occurs after the host sends a
; * 					SET_CONFIGURATION (wValue not = 0) request.  This 
; *					callback function should initialize the endpoints 
; *					for the device's usage according to the current 
; *					configuration.
; *
; * Note:            None
; *****************************************************************************/
;void USBCBInitEP(void)
USBCBInitEP
;{
; Enable the HID endpoint
;    USBEnableEndpoint(HID_EP,USB_IN_ENABLED|USB_HANDSHAKE_ENABLED|USB_DISALLOW_SETUP);
; Enable and configure OUT endpoint
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movlw	HID_CEP
	movwf	FSR0L			; Endpoint number
	movlw	USB_OUT_ENABLED|USB_IN_ENABLED|USB_HANDSHAKE_ENABLED|USB_DISALLOW_SETUP
	movwf	usb_temp		; Options
	lfsr	1, hid_report_out	; Endpoint buffer
	movlw	HID_INT_OUT_EP_SIZE	; Endpoint size
	rcall	USBEnableEndpointOut

; Enable and configure IN endpoint
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
	movlw	HID_EP
	movwf	FSR0L			; Endpoint number
	movlw	USB_OUT_ENABLED|USB_IN_ENABLED|USB_HANDSHAKE_ENABLED|USB_DISALLOW_SETUP
	movwf	usb_temp		; Options
	lfsr	1, hid_report_in	; Endpoint buffer
	movlw	HID_INT_IN_EP_SIZE	; Endpoint size
	bra	USBEnableEndpointIn
;}

;/********************************************************************
; * Function:        void USBCBSendResume(void)
; *
; * PreCondition:    None
; *
; * Input:           None
; *
; * Output:          None
; *
; * Side Effects:    None
; *
; * Overview:        The USB specifications allow some types of USB
; * 					peripheral devices to wake up a host PC (such
; *					as if it is in a low power suspend to RAM state).
; *					This can be a very useful feature in some
; *					USB applications, such as an Infrared remote
; *					control	receiver.  If a user presses the "power"
; *					button on a remote control, it is nice that the
; *					IR receiver can detect this signalling, and then
; *					send a USB "command" to the PC to wake up.
; *					
; *					The USBCBSendResume() "callback" function is used
; *					to send this special USB signalling which wakes 
; *					up the PC.  This function may be called by
; *					application firmware to wake up the PC.  This
; *					function should only be called when:
; *					
; *					1.  The USB driver used on the host PC supports
; *						the remote wakeup capability.
; *					2.  The USB configuration descriptor indicates
; *						the device is remote wakeup capable in the
; *						bmAttributes field.
; *					3.  The USB host PC is currently sleeping,
; *						and has previously sent your device a SET 
; *						FEATURE setup packet which "armed" the
; *						remote wakeup capability.   
; *
; *					This callback should send a RESUME signal that
; *                  has the period of 1-15ms.
; *
; * Note:            Interrupt vs. Polling
; *                  -Primary clock
; *                  -Secondary clock ***** MAKE NOTES ABOUT THIS *******
; *                   > Can switch to primary first by calling USBCBWakeFromSuspend()
 
; *                  The modifiable section in this routine should be changed
; *                  to meet the application needs. Current implementation
; *                  temporary blocks other functions from executing for a
; *                  period of 1-13 ms depending on the core frequency.
; *
; *                  According to USB 2.0 specification section 7.1.7.7,
; *                  "The remote wakeup device must hold the resume signaling
; *                  for at lest 1 ms but for no more than 15 ms."
; *                  The idea here is to use a delay counter loop, using a
; *                  common value that would work over a wide range of core
; *                  frequencies.
; *                  That value selected is 1800. See table below:
; *                  ==========================================================
; *                  Core Freq(MHz)      MIP         RESUME Signal Period (ms)
; *                  ==========================================================
; *                      48              12          1.05
; *                       4              1           12.6
; *                  ==========================================================
; *                  * These timing could be incorrect when using code
; *                    optimization or extended instruction mode,
; *                    or when having other interrupts enabled.
; *                    Make sure to verify using the MPLAB SIM's Stopwatch
; *                    and verify the actual signal on an oscilloscope.
; *******************************************************************/
;void USBCBSendResume(void)
USBCBSendResume
;{
	movlb	high _USBMEMORYADDRESS	; Point to proper bank
;    static WORD delay_count;
    
;    USBResumeControl = 1;                // Start RESUME signaling
	bsf	UCON, RESUME		; Start RESUME signaling
    
;    delay_count = 1800U;                // Set RESUME line for 1-13 ms
;    do
;    {
;        delay_count--;
;    }while(delay_count);
	movlw	0x10			; Set RESUME line for 1-13 ms
	movwf	FSR2H			; Using FSR2 as temp
	clrf	FSR2L
USBCBSendResumeLoop
	decfsz	FSR2L, F
	bra	USBCBSendResumeLoop
	decfsz	FSR2H, F
	bra	USBCBSendResumeLoop
;    USBResumeControl = 0;
	bcf	UCON, RESUME
	return
;}

;/** EOF hid.c ******************************************************/
