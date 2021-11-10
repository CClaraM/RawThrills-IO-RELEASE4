; usb_mem.asm
; 03/20/09 microEngineering Labs, Inc.

; Buffer Descriptor Byte Aliases
#define	Stat		0		; Buffer Descriptor Status Register
#define	Cnt		1		; Buffer Count
;#define ADR		2		; Buffer Address
#define	ADRL		2		; Buffer Address Low
#define	ADRH		3		; Buffer Address High

; Stat Bit Aliases
;#define BC8		0		; Upper Count Bit
;#define BC9		1		; Upper Count Bit
#define	BSTALL		2		; Buffer Stall Enable
#define	DTSEN		3		; Data Toggle Synch Enable
#define	INCDIS		4		; Address Increment Disable
#define	KEN		5		; BD Keep Enable
#define	DTS		6		; Data Toggle Synch Value
#define	UOWN		7		; USB Ownership
#define	PID		2		; Packet Identifier (4 bits)


	cblock	_USBMEMORYADDRESS	; Point to BDT RAM
	endc

; Buffer Descriptor Table (BDT) RAM

#if(0 <= USB_MAX_EP_NUMBER)
	cblock
		ep0Bo:4			; Endpoint #0 BD Out
		ep0Bi:4			; Endpoint #0 BD In
	endc
#endif

#if(1 <= USB_MAX_EP_NUMBER)
	cblock
		ep1Bo:4			; Endpoint #1 BD Out
		ep1Bi:4			; Endpoint #1 BD In
	endc
#endif

#if(2 <= USB_MAX_EP_NUMBER)
	cblock
		ep2Bo:4			; Endpoint #2 BD Out
		ep2Bi:4			; Endpoint #2 BD In
	endc
#endif

#if(3 <= USB_MAX_EP_NUMBER)
	cblock
		ep3Bo:4			; Endpoint #3 BD Out
		ep3Bi:4			; Endpoint #3 BD In
	endc
#endif

#if(4 <= USB_MAX_EP_NUMBER)
	cblock
		ep4Bo:4			; Endpoint #4 BD Out
		ep4Bi:4			; Endpoint #4 BD In
	endc
#endif

#if(5 <= USB_MAX_EP_NUMBER)
	cblock
		ep5Bo:4			; Endpoint #5 BD Out
		ep5Bi:4			; Endpoint #5 BD In
	endc
#endif

#if(6 <= USB_MAX_EP_NUMBER)
	cblock
		ep6Bo:4			; Endpoint #6 BD Out
		ep6Bi:4			; Endpoint #6 BD In
	endc
#endif

#if(7 <= USB_MAX_EP_NUMBER)
	cblock
		ep7Bo:4			; Endpoint #7 BD Out
		ep7Bi:4			; Endpoint #7 BD In
	endc
#endif

#if(8 <= USB_MAX_EP_NUMBER)
	cblock
		ep8Bo:4			; Endpoint #8 BD Out
		ep8Bi:4			; Endpoint #8 BD In
	endc
#endif

#if(9 <= USB_MAX_EP_NUMBER)
	cblock
		ep9Bo:4			; Endpoint #9 BD Out
		ep9Bi:4			; Endpoint #9 BD In
	endc
#endif

#if(10 <= USB_MAX_EP_NUMBER)
	cblock
		ep10Bo:4		; Endpoint #10 BD Out
		ep10Bi:4		; Endpoint #10 BD In
	endc
#endif

#if(11 <= USB_MAX_EP_NUMBER)
	cblock
		ep11Bo:4		; Endpoint #11 BD Out
		ep11Bi:4		; Endpoint #11 BD In
	endc
#endif

#if(12 <= USB_MAX_EP_NUMBER)
	cblock
		ep12Bo:4		; Endpoint #12 BD Out
		ep12Bi:4		; Endpoint #12 BD In
	endc
#endif

#if(13 <= USB_MAX_EP_NUMBER)
	cblock
		ep13Bo:4		; Endpoint #13 BD Out
		ep13Bi:4		; Endpoint #13 BD In
	endc
#endif

#if(14 <= USB_MAX_EP_NUMBER)
	cblock
		ep14Bo:4		; Endpoint #14 BD Out
		ep14Bi:4		; Endpoint #14 BD In
	endc
#endif

#if(15 <= USB_MAX_EP_NUMBER)
	cblock
		ep15Bo:4		; Endpoint #15 BD Out
		ep15Bi:4		; Endpoint #15 BD In
	endc
#endif

; General RAM (in _USBMEMORYADDRESS bank)
	cblock
		usb_temp:2		; Temporary storage
		pSrc:3			; Source pointer
		pDst:2			; Destination pointer
		USBDeviceState:1	; Device States: DETACHED, ATTACHED, ...
		USBActiveConfiguration:1	; Value of current configuration
		USBAlternateInterface:USB_MAX_NUM_INT	; Array to keep track of the current alternate setting for each interface ID
		controlTransferState:1	; Control Transfer State
		inCount:2		; In data counter
		outCount:2		; Out data counter
		shortPacketStatus:1	; Flag used by Control Transfer Read
		USTATcopy:1
		lastDTS:1
		bTRNIFCount:1
		info:1
		outfo:1
		RemoteWakeup:1
	endc

; info bit aliases
#define	ctrl_trf_mem	0		; [0]RAM      [1]ROM
;#define	RemoteWakeup	1		; [0]Disabled [1]Enabled
;#define	cdc_mem_type	2		; [0]RAM      [1]ROM
#define includeZero	6
#define busy		7

; Endpoint 0 buffers
	cblock
		SetupPkt:USB_EP0_BUFF_SIZE
		CtrlTrfData:USB_EP0_BUFF_SIZE
	endc

; SetupPkt Byte and Bit Aliases
#define	bmRequestType	0
#define	bRequest	1
#define	wValue		2
#define	wIndex		4
#define	wLength		6

#define	Recipient	0		; Device,Interface,Endpoint,Other (5 bits)
#define	RequestType	5		; Standard,Class,Vendor,Reserved (2 bits)
#define	DataDir		7		; Host-to-device,Device-to-host
#define	bFeature	2		; DEVICE_REMOTE_WAKEUP,ENDPOINT_HALT

#define	bReportID	2		; In a SET_REPORT or GET_REPORT request
#define	bReportType	3		; In a SET_REPORT or GET_REPORT request

#define	bDscIndex	2		; For Configuration and String DSC Only
#define	bDescriptorType	3		; Device,Configuration,String
#define	wLangID		4		; Language ID

#define	bDevADR		2		; Device Address 0-127
#define	bDevADRH	3		; Must equal zero

#define	bConfigurationValue 2		; Configuration Value 0-255
#define	bCfgRSD		3		; Must equal zero (Reserved)

#define	bAltID		2		; Alternate Setting Value 0-255
#define	bAltID_H	3		; Must equal zero (Reserved)
#define	bIntfID		4		; Interface Number Value 0-255
#define	bIntfID_H	5		; Must equal zero

#define	bEPID		4		; Endpoint ID (Number & Direction)
#define	bEPID_H		5		; Must equal zero

#define	EPNum		0		; Endpoint Number 0-15 (4 bits)
#define	EPDir		7		; Endpoint Direction: 0-OUT, 1-IN


; HID RAM (in _USBMEMORYADDRESS bank)

#ifdef USB_USE_HID
	cblock
		idle_rate:1
		active_protocol:1	; [0] Boot Protocol [1] Report Protocol
	endc
#endif


; CDC RAM (in _USBMEMORYADDRESS bank)

#ifdef USB_USE_CDC
	cblock
		line_coding:LINE_CODING_LENGTH
		control_signal_bitmap:1
		dummy_encapsulated_cmd_response:dummy_length
	endc

; line_coding Byte and Bit Aliases
#define	dwDTERate	0		; Complex data structure
#define	bCharFormat	4
#define	bParityType	5
#define	bDataBits	6

; control_signal_bitmap Byte and Bit Aliases
#define	DTE_PRESENT	0		; [0] Not Present  [1] Present
#define	CARRIER_CONTROL	1		; [0] Deactivate   [1] Activate
#endif


; All previous RAM must be in _USBMEMORYADDRESS bank
; The following buffers may be in any dual-port RAM bank

; Generic Buffer RAM

#ifdef USB_USE_GEN
	cblock
		gen_data_rx:USBGEN_EP_SIZE + 1	; +1 for size at front
		gen_data_tx:USBGEN_EP_SIZE + 1	; +1 for size at front
	endc
#endif


; HID Buffer RAM

#ifdef USB_USE_HID
	cblock
		hid_report_out:HID_INT_OUT_EP_SIZE + 1	; +1 for size at front
		hid_report_in:HID_INT_IN_EP_SIZE + 1	; +1 for size at front
	endc
#endif


; CDC Buffer RAM
	
#ifdef USB_USE_CDC
	cblock
		cdc_notice:CDC_COMM_IN_EP_SIZE + 1	; +1 for size at front
		cdc_data_rx:CDC_DATA_OUT_EP_SIZE + 1	; +1 for size at front
		cdc_data_tx:CDC_DATA_IN_EP_SIZE + 1	; +1 for size at front
	endc
#endif
