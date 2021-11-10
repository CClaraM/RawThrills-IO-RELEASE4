; usb_hid.inc
; 6/30/08 microEngineering Labs, Inc.

;/*******************************************************************************

;    USB HID class header file

;This file, with its associated C source file, provides the interface required
;to talk to the USB host through the Human Interface Device (HID) class.  

;******************************************************************************/
;//DOM-IGNORE-BEGIN
;/******************************************************************************
; FileName:     	usb_function_hid.h
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
; Change History:
;  Rev   Date         Description
;  1.0   11/19/2004   Initial release
;  2.1   02/26/2007   Updated for simplicity and to use common
;                     coding style
;*******************************************************************/
;#ifndef HID_H
;#define HID_H
;//DOM-IGNORE-END

;/** INCLUDES *******************************************************/

;/** DEFINITIONS ****************************************************/

; DEVICE CLASS USAGE
#define USB_USE_HID

; Class-Specific Requests
#define GET_REPORT	0x01
#define GET_IDLE	0x02
#define GET_PROTOCOL	0x03
#define SET_REPORT	0x09
#define SET_IDLE	0x0A
#define SET_PROTOCOL	0x0B

; Class Descriptor Types
#define DSC_HID		0x21
#define DSC_RPT		0x22
#define DSC_PHY		0x23

; Protocol Selection
#define BOOT_PROTOCOL	0x00
#define RPT_PROTOCOL	0x01

; HID Interface Class Code
#define HID_INTF	0x03

; HID Interface Class SubClass Codes
#define BOOT_INTF_SUBCLASS	0x01

; HID Interface Class Protocol Codes
#define HID_PROTOCOL_NONE	0x00
#define HID_PROTOCOL_KEYBOARD	0x01
#define HID_PROTOCOL_MOUSE	0x02


;/********************************************************************
; * Macro:           BYTE mHIDGetRptRxLength(void)
; *
; * Description:     mHIDGetRptRxLength is used to retrieve the number
; *                  of bytes copied to user's buffer by the most
; *                  recent call to HIDRxReport function.
; * Input:           
; *     None :
; *
; * Output:          
; *     BYTE : mHIDGetRptRxLength returns hid_rpt_rx_len
; *
; *******************************************************************/
;#define mHIDGetRptRxLength()        hid_rpt_rx_len

;#define HIDTxHandleBusy USBHandleBusy
;#define HIDRxHandleBusy USBHandleBusy
;#define HIDTxPacket USBTxOnePacket
;#define HIDRxPacket USBRxOnePacket

;// Section: STRUCTURES *********************************************/

;//USB HID Descriptor header as detailed in section 
;//"6.2.1 HID Descriptor" of the HID class definition specification
;typedef struct _USB_HID_DSC_HEADER
;{
;    BYTE bDescriptorType;	//offset 9
;    WORD wDscLength;		//offset 10
;} USB_HID_DSC_HEADER;

;//USB HID Descriptor header as detailed in section 
;//"6.2.1 HID Descriptor" of the HID class definition specification
;typedef struct _USB_HID_DSC
;{
;    BYTE bLength;			//offset 0 
;	BYTE bDescriptorType;	//offset 1
;	WORD bcdHID;			//offset 2
;    BYTE bCountryCode;		//offset 4
;	BYTE bNumDsc;			//offset 5


;    //USB_HID_DSC_HEADER hid_dsc_header[HID_NUM_OF_DSC];
;    /* HID_NUM_OF_DSC is defined in usbcfg.h */
    
;} USB_HID_DSC;

;/** EXTERNS ********************************************************/
;extern BYTE hid_rpt_rx_len;

;/** PUBLIC PROTOTYPES **********************************************/
;#if defined(USB_DYNAMIC_EP_CONFIG)
;    #define HIDInitEP()
;#else
;	/********************************************************************
;	 * Function:        void HIDInitEP(void)
;	 *
;	 * PreCondition:    None
;	 *
;	 * Input:           None
;	 *
;	 * Output:          None
;	 *
;	 * Side Effects:    None;
;	 *
;	 * Overview:        HIDInitEP initializes HID endpoints, buffer
;	 *                  descriptors, internal state-machine, and
;	 *                  variables. It should be called after the USB
;	 *                  host has sent out a SET_CONFIGURATION request.
;	 *                  See USBStdSetCfgHandler() in usbd.c for examples.
;	 *
;	 * Note:            None
;	 *******************************************************************/
;    void HIDInitEP(void);
;#endif
;	/********************************************************************
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
;void USBCheckHIDRequest(void);

;#endif //HID_H
