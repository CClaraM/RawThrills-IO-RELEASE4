MPASMWIN_USED			EQU	1

#define	PBP_PATH	C:\PROGRAM FILES (X86)\PBP3\




        NOLIST
    ifdef PM_USED
        LIST
        "Error: PM does not support this device.  Use MPASM."
        NOLIST
    else
        LIST
        LIST p = 18F4550, r = dec, w = -311, w = -230, f = inhx32
        INCLUDE "P18F4550.INC"	; MPASM  Header
        NOLIST
    endif
        LIST
EEPROM_START	EQU	0F00000h
BLOCK_SIZE	EQU	32


PBP_HARDWAREDEF  macro
  endm


    CONFIG  PLLDIV = 5            ; Divide by 5 (20 MHz oscillator input)
    CONFIG  CPUDIV = OSC1_PLL2	  ;[Primary Oscillator Src: /1][96 MHz PLL Src: /2]
    CONFIG  USBDIV = 2            ; USB clock source comes from the 96 MHz PLL divided by 2
    CONFIG  FOSC = ECIO_EC	      ; EC oscillator, port function on RA6 (ECIO)
    CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor disabled
    CONFIG  IESO = OFF            ; Oscillator Switchover mode disabled
    CONFIG  PWRT = OFF            ; PWRT disabled
    CONFIG  BOR = ON              ; Brown-out Reset enabled in hardware only (SBOREN is disabled)
    CONFIG  VREGEN = ON           ; USB voltage regulator enabled
    CONFIG  WDT = ON              ; WDT enabled
    CONFIG  WDTPS = 512           ; 1:512
    CONFIG  PBADEN = OFF          ; PORTB<4:0> pins are configured as digital I/O on Reset
    CONFIG  LPT1OSC = OFF         ; Timer1 configured for higher power operation
    CONFIG  MCLRE = OFF	          ; RE3 input pin enabled; MCLR pin disabled
    CONFIG  STVREN = ON           ; Stack full/underflow will cause Reset
    CONFIG  LVP = OFF             ; Single-Supply ICSP disabled
    CONFIG  ICPRT = ON            ; ICPORT enabled
    CONFIG CP0 = OFF               ;Block 0 (000800-001FFFh) or (001000-001FFFh) is code-protected
    CONFIG CP1 = OFF	    ;Block 1 (002000-003FFFh) is code-protected
    CONFIG CP2 = OFF
    CONFIG CP3 = OFF
    CONFIG CPB = OFF	    ;Boot block (000000-0007FFh) or (000000-000FFFh) is code-protected
    




#define		OSC		48
#define		ADC_BITS	12  
#define		ADC_CLOCK	3  
#define		ADC_SAMPLEUS	50  

RAM_START       		EQU	00000h
RAM_END         		EQU	007FFh
RAM_BANKS       		EQU	00008h
BANK0_START     		EQU	00060h
BANK0_END       		EQU	000FFh
BANK1_START     		EQU	00100h
BANK1_END       		EQU	001FFh
BANK2_START     		EQU	00200h
BANK2_END       		EQU	002FFh
BANK3_START     		EQU	00300h
BANK3_END       		EQU	003FFh
BANK4_START     		EQU	00400h
BANK4_END       		EQU	004FFh
BANK5_START     		EQU	00500h
BANK5_END       		EQU	005FFh
BANK6_START     		EQU	00600h
BANK6_END       		EQU	006FFh
BANK7_START     		EQU	00700h
BANK7_END       		EQU	007FFh
BANKA_START     		EQU	00000h
BANKA_END       		EQU	0005Fh

FLAGS           		EQU	RAM_START + 000h
GOP             		EQU	RAM_START + 001h
R0              		EQU	RAM_START + 002h
R1              		EQU	RAM_START + 004h
R2              		EQU	RAM_START + 006h
R3              		EQU	RAM_START + 008h
R4              		EQU	RAM_START + 00Ah
R5              		EQU	RAM_START + 00Ch
R6              		EQU	RAM_START + 00Eh
R7              		EQU	RAM_START + 010h
R8              		EQU	RAM_START + 012h
T1              		EQU	RAM_START + 014h
T2              		EQU	RAM_START + 016h
T3              		EQU	RAM_START + 018h
RM1             		EQU	RAM_START + 01Ah
RM2             		EQU	RAM_START + 01Bh
RR1             		EQU	RAM_START + 01Ch
RR2             		EQU	RAM_START + 01Dh
RS1             		EQU	RAM_START + 01Eh
RS2             		EQU	RAM_START + 01Fh
PB01            		EQU	RAM_START + 020h
PB02            		EQU	RAM_START + 021h
_USBBuffer       		EQU	RAM_START + 060h
_USBBufferCount  		EQU	RAM_START + 069h
_BUFFIN0         		EQU	RAM_START + 06Ah
_BUFFIN1         		EQU	RAM_START + 06Bh
_BUFFIN2         		EQU	RAM_START + 06Ch
_LOUTSTATE       		EQU	RAM_START + 06Dh
_INPUTS0         		EQU	RAM_START + 06Eh
_INPUTS1         		EQU	RAM_START + 06Fh
_INPUTS2         		EQU	RAM_START + 070h
_INPUTS3         		EQU	RAM_START + 071h
_BINPUTS0        		EQU	RAM_START + 072h
_BINPUTS1        		EQU	RAM_START + 073h
_BINPUTS2        		EQU	RAM_START + 074h
_BINPUTS3        		EQU	RAM_START + 075h
_OUTPUTS0        		EQU	RAM_START + 076h
_OUTPUTS1        		EQU	RAM_START + 077h
_OUTPUTS2        		EQU	RAM_START + 078h
_OUTPUTS3        		EQU	RAM_START + 079h
_ANINPUT0        		EQU	RAM_START + 07Ah
_ANINPUT1        		EQU	RAM_START + 07Ch
_ANALOG0         		EQU	RAM_START + 07Eh
_BANALOG0        		EQU	RAM_START + 07Fh
_ANALOG1         		EQU	RAM_START + 080h
_BANALOG1        		EQU	RAM_START + 081h
_ANALOG2         		EQU	RAM_START + 082h
_BANALOG2        		EQU	RAM_START + 083h
_ANALOG3         		EQU	RAM_START + 084h
_BANALOG3        		EQU	RAM_START + 085h
_ANALOG4         		EQU	RAM_START + 086h
_BANALOG4        		EQU	RAM_START + 087h
_ANALOG5         		EQU	RAM_START + 088h
_BANALOG5        		EQU	RAM_START + 089h
_ANALOG6         		EQU	RAM_START + 08Ah
_BANALOG6        		EQU	RAM_START + 08Bh
; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00089	A0008C	ANALOG7     var byte            $8C
_ANALOG7         		EQU	RAM_START + 08Ch
; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00090	A0008D	BANALOG7     var byte           $8D
_BANALOG7        		EQU	RAM_START + 08Dh
; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00091	A0008E	COUNTER     var byte            $8E
_COUNTER         		EQU	RAM_START + 08Eh
; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00093	A0008F	KEYPRESS         var byte       $8F
_KEYPRESS        		EQU	RAM_START + 08Fh
; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00094	A00090	KEYS3            var byte       $90
_KEYS3           		EQU	RAM_START + 090h
; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00095	A00091	BKEY             var byte       $91
_BKEY            		EQU	RAM_START + 091h
; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00096	A00092	VATEMP           var byte       $92
_VATEMP          		EQU	RAM_START + 092h
; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\R4_DESC.BAS	00005	A00400	USBReservedMemory Var Byte[USBMEMORYSIZE] USBMEMORYADDRESS	' Reserve memory used by USB assembler code
_USBReservedMemory		EQU	RAM_START + 00400h
; C:\PROGRAM FILES (X86)\PBP3\DEVICES\PIC18F4550.PBPINC	00305	PORTL   VAR     PORTB
_PORTL           		EQU	 PORTB
; C:\PROGRAM FILES (X86)\PBP3\DEVICES\PIC18F4550.PBPINC	00306	PORTH   VAR     PORTC
_PORTH           		EQU	 PORTC
; C:\PROGRAM FILES (X86)\PBP3\DEVICES\PIC18F4550.PBPINC	00307	TRISL   VAR     TRISB
_TRISL           		EQU	 TRISB
; C:\PROGRAM FILES (X86)\PBP3\DEVICES\PIC18F4550.PBPINC	00308	TRISH   VAR     TRISC
_TRISH           		EQU	 TRISC
#define _INARC           	 PB01, 004h
#define _OP1             	 PB01, 005h
#define _OP2             	 PB01, 006h
#define _OP3             	 PB01, 007h
#define _OP4             	 PB02, 000h
#define _OPERATE         	 PB02, 001h
#define _USB_ARC         	 PB02, 002h
#define _COL0            	 PB01, 000h
#define _COL1            	 PB01, 001h
#define _COL2            	 PB01, 002h
#define _COLARC          	 PB01, 003h
#define _PORTA??6        	 PORTA, 006h
#define _PORTC??0        	 PORTC, 000h
#define _BUFFIN1??0      	_BUFFIN1, 000h
#define _OUTPUTS0??0     	_OUTPUTS0, 000h
#define _BUFFIN1??5      	_BUFFIN1, 005h
#define _OUTPUTS0??1     	_OUTPUTS0, 001h
#define _BUFFIN1??6      	_BUFFIN1, 006h
#define _OUTPUTS0??2     	_OUTPUTS0, 002h
#define _BUFFIN1??7      	_BUFFIN1, 007h
#define _OUTPUTS0??3     	_OUTPUTS0, 003h
#define _BUFFIN1??3      	_BUFFIN1, 003h
#define _OUTPUTS0??4     	_OUTPUTS0, 004h
#define _BUFFIN1??4      	_BUFFIN1, 004h
#define _OUTPUTS1??3     	_OUTPUTS1, 003h
#define _OUTPUTS1??5     	_OUTPUTS1, 005h
#define _OUTPUTS1??7     	_OUTPUTS1, 007h
#define _OUTPUTS2??1     	_OUTPUTS2, 001h
#define _PORTA??4        	 PORTA, 004h
#define _PORTD??4        	 PORTD, 004h
#define _INPUTS0??4      	_INPUTS0, 004h
#define _PORTD??5        	 PORTD, 005h
#define _INPUTS0??7      	_INPUTS0, 007h
#define _PORTD??6        	 PORTD, 006h
#define _INPUTS0??2      	_INPUTS0, 002h
#define _PORTD??7        	 PORTD, 007h
#define _INPUTS0??3      	_INPUTS0, 003h
#define _PORTB??0        	 PORTB, 000h
#define _INPUTS2??4      	_INPUTS2, 004h
#define _PORTB??1        	 PORTB, 001h
#define _INPUTS2??5      	_INPUTS2, 005h
#define _PORTB??2        	 PORTB, 002h
#define _INPUTS2??6      	_INPUTS2, 006h
#define _PORTB??3        	 PORTB, 003h
#define _INPUTS2??7      	_INPUTS2, 007h
#define _PORTB??4        	 PORTB, 004h
#define _INPUTS1??2      	_INPUTS1, 002h
#define _PORTB??5        	 PORTB, 005h
#define _INPUTS1??3      	_INPUTS1, 003h
#define _PORTE??1        	 PORTE, 001h
#define _INPUTS3??1      	_INPUTS3, 001h
#define _PORTE??0        	 PORTE, 000h
#define _INPUTS3??3      	_INPUTS3, 003h
#define _PORTE??3        	 PORTE, 003h
#define _INPUTS3??5      	_INPUTS3, 005h
#define _PORTE??2        	 PORTE, 002h
#define _INPUTS3??7      	_INPUTS3, 007h
#define _INPUTS0??5      	_INPUTS0, 005h
#define _INPUTS0??0      	_INPUTS0, 000h
#define _INPUTS0??1      	_INPUTS0, 001h
#define _INPUTS2??0      	_INPUTS2, 000h
#define _INPUTS2??1      	_INPUTS2, 001h
#define _INPUTS2??2      	_INPUTS2, 002h
#define _INPUTS2??3      	_INPUTS2, 003h
#define _INPUTS3??0      	_INPUTS3, 000h
#define _INPUTS3??2      	_INPUTS3, 002h
#define _INPUTS3??4      	_INPUTS3, 004h
#define _INPUTS3??6      	_INPUTS3, 006h
#define _PORTA??2        	 PORTA, 002h
#define _PORTA??3        	 PORTA, 003h
#define _PORTD??0        	 PORTD, 000h
#define _PORTD??1        	 PORTD, 001h
#define _PORTD??3        	 PORTD, 003h
#define _PORTD??2        	 PORTD, 002h

; Constants.
_USBMEMORYADDRESS		EQU	00400h
_USBMEMORYSIZE   		EQU	00100h
_USBBufferSizeTX 		EQU	00004h
_USBBufferSizeRX 		EQU	00003h

; EEPROM data.


	INCLUDE	"RELEASE4.MAC"
	INCLUDE	"C:\PROGRAM FILES (X86)\PBP3\PBPPIC18.LIB"


	GOTO?L	_hid_desc_end


	ASM?


#define	USB_EP0_BUFF_SIZE 	8	; 8, 16, 32, or 64
#define	USB_MAX_NUM_INT		1	; For tracking Alternate Setting
#define	USB_MAX_EP_NUMBER  	2	; UEP1
#define	NUM_CONFIGURATIONS	1
#define	NUM_INTERFACES		1

#define UCFG_VAL	USB_PULLUP_ENABLE|USB_INTERNAL_TRANSCEIVER|USB_FULL_SPEED|USB_PING_PONG__NO_PING_PONG
;#define UCFG_VAL	USB_PULLUP_ENABLE|USB_INTERNAL_TRANSCEIVER|USB_LOW_SPEED|USB_PING_PONG__NO_PING_PONG

;#define USE_SELF_POWER_SENSE_IO
;#define USE_USB_BUS_SENSE_IO

#define USB_POLLING

; HID
; Endpoints Allocation
#define	HID_INTF_ID		  0x00
#define	HID_EP			  1
#define	HID_CEP			  2
#define	HID_INT_OUT_EP_SIZE	  3
#define	HID_INT_IN_EP_SIZE	  8
#define	HID_NUM_OF_DSC		  1

   include	"usb_hid.asm"	; Include rest of USB files, starting with HID class code

; ******************************************************************
; This table is polled by the host immediately after USB Reset has been released.
; This table defines the maximum packet size EP0 can take.
; See section 9.6.1 of the Rev 1.0 USB specification.
; These fields are application DEPENDENT. Modify these to meet
; your specifications.
; ******************************************************************
DeviceDescriptor
	retlw	(EndDeviceDescriptor-DeviceDescriptor)/2	; bLength Length of this descriptor
	retlw	USB_DESCRIPTOR_DEVICE ; bDescType This is a DEVICE descriptor
	retlw	0x10		; bcdUSBUSB Revision 1.10 (low byte)
	retlw	0x01		; high byte
	retlw	0x00		; bDeviceClass zero means each interface operates independently
	retlw	0x00		; bDeviceSubClass
	retlw	0x00		; bDeviceProtocol
	retlw	USB_EP0_BUFF_SIZE ; bMaxPacketSize for EP0

        ; idVendor (low byte, high byte)
	retlw	0x83
	retlw	0x04

        ; idProduct (low byte, high byte)
	retlw	0x03
	retlw	0x00

    retlw	0x30		; bcdDevice (low byte)
	retlw	0x02		; (high byte)
	
	retlw	0x03		; iManufacturer (string index)
	retlw	0x01		; iProduct      (string index)

        ; iSerialNumber (string index)
	retlw	0x02
	retlw	NUM_CONFIGURATIONS ; bNumConfigurations
EndDeviceDescriptor

; ******************************************************************
; This table is retrieved by the host after the address has been set.
; This table defines the configurations available for the device.
; See section 9.6.2 of the Rev 1.0 USB specification (page 184).
; These fields are application DEPENDENT. 
; Modify these to meet your specifications.
; ******************************************************************
; Configuration pointer table
USB_CD_Ptr
Configs
	db	low Config1, high Config1
	db	upper Config1, 0

; Configuration Descriptor
Config1
	retlw	(Interface1-Config1)/2	; bLength Length of this descriptor
	retlw	USB_DESCRIPTOR_CONFIGURATION ; bDescType 2=CONFIGURATION
Config1Len
	retlw	low ((EndConfig1 - Config1)/2)	; Length of this configuration
	retlw	high ((EndConfig1 - Config1)/2)
	retlw	0x01		; bNumInterfaces Number of interfaces
	retlw	0x01		; bConfigValue Configuration Value
	retlw	0x00		; iConfig (string index)
	retlw	0xE0

        ; Max power consumption (2X mA)
	retlw	0x19
Interface1
	retlw	(HIDDescriptor1-Interface1)/2	; length of descriptor
	retlw	USB_DESCRIPTOR_INTERFACE
	retlw	0x00		; number of interface, 0 based array
	retlw	0x00		; alternate setting
	retlw	0x02		; number of endpoints used in this interface
	retlw	0x03		; interface class - assigned by the USB
	retlw	0x00		; boot device
	retlw	0x00		; interface protocol
	retlw 	0x00		; index to string descriptor that describes this interface
HIDDescriptor1
	retlw	(Endpoint1In-HIDDescriptor1)/2	; descriptor size (9 bytes)
        retlw	DSC_HID		; descriptor type (HID)
	retlw	0x10		; HID class release number (1.11)
	retlw	0x01
        retlw	0x21		; Localized country code (none)
        retlw	0x01		; # of HID class descriptor to follow (1)
        retlw	0x22		; Report descriptor type (HID)
ReportDescriptor1Len
	retlw	low ((EndReportDescriptor1-ReportDescriptor1)/2)
	retlw	high ((EndReportDescriptor1-ReportDescriptor1)/2)
Endpoint1In
	retlw	(EndPoint1Out-Endpoint1In)/2	; length of descriptor
	retlw	USB_DESCRIPTOR_ENDPOINT
	retlw	HID_EP|_EP_IN ;|_EP_IN		; EP1, In
	retlw	_INT		; Interrupt
	retlw	low (HID_INT_IN_EP_SIZE)		; This should be the size of the endpoint buffer
	retlw	high (HID_INT_IN_EP_SIZE)
	retlw	0x0A                        ; Polling interval
EndPoint1Out
	retlw	(EndConfig1-EndPoint1Out)/2	; Length of this Endpoint Descriptor
	retlw	USB_DESCRIPTOR_ENDPOINT		; bDescriptorType = 5 for Endpoint Descriptor
	retlw	HID_CEP|_EP02_OUT ;_EP_OUT		; Endpoint number & direction
	retlw	_INT		; Transfer type supported by this Endpoint
	retlw	low (HID_INT_OUT_EP_SIZE)		; This should be the size of the endpoint buffer
	retlw	high (HID_INT_OUT_EP_SIZE)
	retlw	0x0A                        ; Polling interval
EndConfig1

ReportDescriptor1
    ; vendor defined usage page
    retlw	0x05		
    retlw	0x8C

    ; vendor defined usage
    retlw	0x09
    retlw	0x01

    ; collection(application)
    retlw	0xA1
    retlw	0x01

    ; *** -- ***
    
    retlw	0x85    ; Report ID (1)
    retlw	0x01
        
    retlw	0x09    ; Usage
    retlw	0x03

    retlw	0x15 	; Logical Minimum (0)
    retlw	0x00    ;
    
    retlw	0x25 	; Logical Maximum (-1)
    retlw	0xFF    ;

    ; report size in bits
    retlw	0x75
    retlw	0x08

    ; report count (number of fields)
    retlw	0x95
    retlw	0x02

    ; Input (Data, Variable, Absolute)
    retlw	0x91
    retlw	0x82

    ; *** ------ ***
    
    retlw	0x85    ; Report ID (1)
    retlw	0x01
    
    retlw	0x09    ; Usage
    retlw	0x03
    
    retlw	0xB1    ; Feature (Data,Var,Abs,NWrp,Lin,Pref,NNul,Vol,Bit)
    retlw	0x82
    ; *** ------ ***
    
    retlw	0x85    ; Report ID (2)
    retlw	0x02
    
    retlw	0x09    ; Usage
    retlw	0x02
    
    retlw	0x15 	; Logical Minimum (0)
    retlw	0x00    ;
    
    retlw	0x25 	; Logical Maximum (-1)
    retlw	0xFF    ;
    
    retlw   0x75    ; Report Size (8)
    retlw   0x08
    
    retlw   0x81    ; Input (Data,Var,Abs,NWrp,Lin,Pref,NNul,Bit)
    retlw   0x82
    
    retlw   0x75    ; Report Size (8)
    retlw   0x08
    
    retlw   0x81    ; Input (Cnst,Var,Abs,NWrp,Lin,Pref,NNul,Bit)
    retlw   0x83
    
    retlw	0x85    ; Report ID (2)
    retlw	0x02
    
    retlw	0x09    ; Usage
    retlw	0x02
    
    retlw	0x75    ; Report Size (8)
    retlw	0x08
    
    retlw   0xB1    ; Feature (Data,Var,Abs,NWrp,Lin,Pref,NNul,Vol,Bit)
    retlw   0x82
    
    retlw	0x75    ; Report Size (8)
    retlw	0x08
    
    retlw   0xB1    ; Feature (Data,Var,Abs,NWrp,Lin,Pref,NNul,Vol,Bit)
    retlw   0x83
    
    retlw	0x85    ; Report ID (3)
    retlw	0x03
    
    retlw	0x09    ; Usage
    retlw	0x04
    
    retlw	0x15 	; Logical Minimum (0)
    retlw	0x00    ;
    
    retlw	0x26 	; Logical Maximum (255)
    retlw   0xFF
    retlw   0x00
    
    retlw	0x75    ; Report Size (8)
    retlw	0x08
    
    retlw	0x81    ; Input (Data,Var,Abs,NWrp,Lin,Pref,NNul,Bit)
    retlw	0x82
    
    retlw	0x85    ; Report ID (3)
    retlw	0x03
    
    retlw	0x09    ; Usage
    retlw	0x04
    
    retlw   0xB1    ; Feature (Data,Var,Abs,NWrp,Lin,Pref,NNul,Vol,Bit)
    retlw   0x82
    
    retlw	0x85    ; Report ID (4)
    retlw	0x04
    
    retlw	0x09    ; Usage
    retlw	0x05
    
    retlw	0x15 	; Logical Minimum (0)
    retlw	0x00    ;
    
    retlw	0x25 	; Logical Maximum (-1)
    retlw	0xFF    ;
    
    retlw	0x75    ; Report Size (8)
    retlw	0x08
    
    retlw	0x95    ; report count (number of fields)
    retlw	0x03
    
    retlw   0x81    ; Input (Data,Var,Abs,NWrp,Lin,Pref,NNul,Bit)
    retlw   0x82
    
    retlw	0x85    ; Report ID (4)
    retlw	0x04
    
    retlw	0x09    ; Usage
    retlw	0x05
    
    retlw   0xB1    ;Feature (Data,Var,Abs,NWrp,Lin,Pref,NNul,Vol,Bit)
    retlw   0x82
    
    retlw	0x85    ; Report ID (5)
    retlw	0x05
    
    retlw	0x09    ; Usage
    retlw	0x06
    
    retlw	0x15 	; Logical Minimum (0)
    retlw	0x00    ;
    
    retlw	0x26 	; Logical Maximum (255)
    retlw   0xFF
    retlw   0x00
    
    retlw	0x95    ; report count (number of fields)
    retlw	0x12
    
    retlw   0x81    ; Input (Data,Var,Abs,NWrp,Lin,Pref,NNul,Bit)
    retlw   0x82
    
    retlw	0x85    ; Report ID (5)
    retlw	0x05
    
    retlw	0x09    ; Usage
    retlw	0x06
    
    retlw   0xB1    ;Feature (Data,Var,Abs,NWrp,Lin,Pref,NNul,Vol,Bit)
    retlw   0x82
    
    retlw   0xC0       	   ; end collection

EndReportDescriptor1

; String pointer table
USB_SD_Ptr
Strings
	db	low String0, high String0
        db	upper String0, 0
	db	low String1, high String1
        db	upper String1, 0
	db	low String2, high String2
       	db	upper String2, 0
	db	low String3, high String3
	db	upper String3, 0

String0
	retlw	(String1-String0)/2	; Length of string
	retlw	USB_DESCRIPTOR_STRING   ; Descriptor type 3
	retlw	0x09		        ; Language ID (as defined by MS 0x0409)
	retlw	0x04

; product name
String1
	retlw	(String2-String1)/2
	retlw	USB_DESCRIPTOR_STRING
	
	    retlw   'J'
        retlw   0x00
        retlw   'A'
        retlw   0x00
        retlw   'M'
        retlw   0x00
        retlw   'M'
        retlw   0x00
        retlw   'A'
        retlw   0x00
        retlw   'U'
        retlw   0x00
        retlw   'S'
        retlw   0x00
        retlw   'B'
        retlw   0x00
        retlw   '.'
        retlw   0x00
        retlw   'B'
        retlw   0x00
        retlw   'o'
        retlw   0x00
        retlw   'a'
        retlw   0x00
        retlw   'r'
        retlw   0x00
        retlw   'd'
        retlw   0x00
	
; product Serial	
String2
	retlw	(String3-String2)/2
	retlw	USB_DESCRIPTOR_STRING
	
        retlw   'X'
        retlw   0x00
        retlw   'X'
        retlw   0x00
        retlw   'X'
        retlw   0x00

; company name
String3
	retlw	(String4-String3)/2
	retlw	USB_DESCRIPTOR_STRING
	
        retlw   'R'
        retlw   0x00
        retlw   'A'
        retlw   0x00
        retlw   'W'
        retlw   0x00
        retlw   ' '
        retlw   0x00
        retlw   'T'
        retlw   0x00
        retlw   'H'
        retlw   0x00
        retlw   'R'
        retlw   0x00
        retlw   'I'
        retlw   0x00
        retlw   'L'
        retlw   0x00
        retlw   'L'
        retlw   0x00
        retlw   'S'
        retlw   0x00
        retlw   ' '
        retlw   0x00
        retlw   'I'
        retlw   0x00
        retlw   'N'
        retlw   0x00
        retlw   'C'
        retlw   0x00

String4




	ENDASM?



	LABEL?L	_hid_desc_end	
	MOVE?CB	0A3h, TRISA

	MOVE?CB	00Dh, ADCON1

	MOVE?CB	080h, ADCON2

	MOVE?CB	0FFh, TRISB

	MOVE?CB	092h, TRISC

	MOVE?CB	0F0h, TRISD

	MOVE?CB	007h, TRISE

	MOVE?CB	000h, PORTD

	MOVE?CB	004h, PORTC

	MOVE?CT	000h, _PORTA??6

	MOVE?CB	000h, _USBBuffer

	MOVE?CB	000h, _USBBuffer + 00001h

	MOVE?CB	000h, _USBBuffer + 00002h

	MOVE?CB	000h, _USBBuffer + 00003h

	MOVE?CB	000h, _USBBuffer + 00004h

	MOVE?CB	000h, _USBBuffer + 00005h

	MOVE?CB	000h, _USBBuffer + 00006h

	MOVE?CB	000h, _USBBuffer + 00007h

	MOVE?CB	000h, _BUFFIN0

	MOVE?CB	000h, _BUFFIN1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00131	BUFFIN2=0
	MOVE?CB	000h, _BUFFIN2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00133	INPUTS0=255
	MOVE?CB	0FFh, _INPUTS0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00134	INPUTS1=255
	MOVE?CB	0FFh, _INPUTS1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00135	INPUTS2=255
	MOVE?CB	0FFh, _INPUTS2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00136	INPUTS3=255
	MOVE?CB	0FFh, _INPUTS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00138	BINPUTS0 = INPUTS0 
	MOVE?BB	_INPUTS0, _BINPUTS0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00139	BINPUTS1 = INPUTS1 
	MOVE?BB	_INPUTS1, _BINPUTS1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00140	BINPUTS2 = INPUTS2 
	MOVE?BB	_INPUTS2, _BINPUTS2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00141	BINPUTS3 = INPUTS3
	MOVE?BB	_INPUTS3, _BINPUTS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00143	OUTPUTS0=0
	MOVE?CB	000h, _OUTPUTS0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00144	OUTPUTS1=0
	MOVE?CB	000h, _OUTPUTS1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00145	OUTPUTS2=0
	MOVE?CB	000h, _OUTPUTS2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00147	VATEMP=0
	MOVE?CB	000h, _VATEMP

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00148	op1=0
	MOVE?CT	000h, _OP1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00149	op2=0
	MOVE?CT	000h, _OP2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00150	op3=0
	MOVE?CT	000h, _OP3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00151	op4=0
	MOVE?CT	000h, _OP4

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00152	usb_arc=0
	MOVE?CT	000h, _USB_ARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00153	OPERATE=0
	MOVE?CT	000h, _OPERATE

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00154	INARC=0
	MOVE?CT	000h, _INARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00155	KEYPRESS=0
	MOVE?CB	000h, _KEYPRESS

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00156	COUNTER=0
	MOVE?CB	000h, _COUNTER

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00157	KEYS3=0
	MOVE?CB	000h, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00159	low porta.6
	LOW?T	_PORTA??6

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00160	LOW portc.0
	LOW?T	_PORTC??0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00161	gosub WOUT
	GOSUB?L	_WOUT

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00166	usbinit ' initialise USB...
	USBINIT?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00168	START:

	LABEL?L	_START	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00169	    high portc.0
	HIGH?T	_PORTC??0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00170	    gosub DoUSBIn
	GOSUB?L	_DoUSBIn

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00171	    if inarc=1 then
	CMPNE?TCL	_INARC, 001h, L00001

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00172	        inarc=0
	MOVE?CT	000h, _INARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00173	        if BUFFIN0=1 and BUFFIN1=0 and BUFFIN2=15 then           
	CMPEQ?BCB	_BUFFIN0, 001h, T1
	CMPEQ?BCB	_BUFFIN1, 000h, T2
	LAND?BBW	T1, T2, T2
	CMPEQ?BCB	_BUFFIN2, 00Fh, T3
	LAND?WBW	T2, T3, T3
	CMPF?WL	T3, L00003

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00174	            gosub READIN
	GOSUB?L	_READIN

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00175	            BINPUTS3=INPUTS3
	MOVE?BB	_INPUTS3, _BINPUTS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00176	            USBBuffer[0]=4     ;ID
	MOVE?CB	004h, _USBBuffer

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00177	            USBBuffer[1]=224   ;Code
	MOVE?CB	0E0h, _USBBuffer + 00001h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00178	            USBBuffer[2]=INPUTS3   ;Data
	MOVE?BB	_INPUTS3, _USBBuffer + 00002h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00179	            USBBuffer[3]=4     ;Data
	MOVE?CB	004h, _USBBuffer + 00003h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00180	            gosub DoUSBOut
	GOSUB?L	_DoUSBOut

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00181	            KEYS3 = 207
	MOVE?CB	0CFh, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00182	            goto R4IO
	GOTO?L	_R4IO

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00183	        endif 
	LABEL?L	L00003	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00184	    endif
	LABEL?L	L00001	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00186	goto start
	GOTO?L	_START

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00191	R4IO:

	LABEL?L	_R4IO	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00192	    if COUNTER>128 then
	CMPLE?BCL	_COUNTER, 080h, L00005

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00193	        high portc.0
	HIGH?T	_PORTC??0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00194	     else
	GOTO?L	L00006
	LABEL?L	L00005	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00195	        low portc.0
	LOW?T	_PORTC??0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00196	    endif
	LABEL?L	L00006	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00198	    if OPERATE=1 then
	CMPNE?TCL	_OPERATE, 001h, L00007

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00199	        gosub READANALOG
	GOSUB?L	_READANALOG

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00200	        Gosub LOADKEY
	GOSUB?L	_LOADKEY

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00202	        if inputs0 <> BINPUTS0 or inputs1 <> BINPUTS1 then
	CMPNE?BBB	_INPUTS0, _BINPUTS0, T1
	CMPNE?BBB	_INPUTS1, _BINPUTS1, T2
	LOR?BBW	T1, T2, T2
	CMPF?WL	T2, L00009

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00203	            op1=1
	MOVE?CT	001h, _OP1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00204	            BINPUTS0=INPUTS0
	MOVE?BB	_INPUTS0, _BINPUTS0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00205	            BINPUTS1=INPUTS1
	MOVE?BB	_INPUTS1, _BINPUTS1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00206	        endif
	LABEL?L	L00009	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00208	        if KEYS3 <> BKEY then
	CMPEQ?BBL	_KEYS3, _BKEY, L00011

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00209	            op2=1
	MOVE?CT	001h, _OP2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00210	            BKEY=KEYS3
	MOVE?BB	_KEYS3, _BKEY

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00211	        endif
	LABEL?L	L00011	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00213	        if inputs2 <> BINPUTS2 or analog1 <> banalog1 then
	CMPNE?BBB	_INPUTS2, _BINPUTS2, T1
	CMPNE?BBB	_ANALOG1, _BANALOG1, T2
	LOR?BBW	T1, T2, T2
	CMPF?WL	T2, L00013

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00214	            op2=1
	MOVE?CT	001h, _OP2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00215	            banalog1=analog1
	MOVE?BB	_ANALOG1, _BANALOG1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00216	            BINPUTS2=INPUTS2
	MOVE?BB	_INPUTS2, _BINPUTS2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00217	        endif
	LABEL?L	L00013	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00219	        if analog3 <> banalog3 or analog7 <> banalog7 then
	CMPNE?BBB	_ANALOG3, _BANALOG3, T1
	CMPNE?BBB	_ANALOG7, _BANALOG7, T2
	LOR?BBW	T1, T2, T2
	CMPF?WL	T2, L00015

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00220	            op3=1
	MOVE?CT	001h, _OP3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00221	            banalog3=analog3
	MOVE?BB	_ANALOG3, _BANALOG3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00222	            banalog7=analog7
	MOVE?BB	_ANALOG7, _BANALOG7

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00223	        endif
	LABEL?L	L00015	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00225	        if INPUTS3 <> BINPUTS3 then
	CMPEQ?BBL	_INPUTS3, _BINPUTS3, L00017

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00226	            op4=1
	MOVE?CT	001h, _OP4

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00227	            BINPUTS3=INPUTS3
	MOVE?BB	_INPUTS3, _BINPUTS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00228	        endif 
	LABEL?L	L00017	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00230	        if op1=1 then
	CMPNE?TCL	_OP1, 001h, L00019

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00231	            op1=0
	MOVE?CT	000h, _OP1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00232	            USBBuffer[0]=4          ;ID
	MOVE?CB	004h, _USBBuffer

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00233	            USBBuffer[1]=128        ;Code
	MOVE?CB	080h, _USBBuffer + 00001h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00234	            USBBuffer[2]=INPUTS0    ;Data
	MOVE?BB	_INPUTS0, _USBBuffer + 00002h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00235	            USBBuffer[3]=INPUTS1    ;Data
	MOVE?BB	_INPUTS1, _USBBuffer + 00003h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00237	            gosub DoUSBOut
	GOSUB?L	_DoUSBOut

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00238	        endif
	LABEL?L	L00019	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00240	        if op2=1 then
	CMPNE?TCL	_OP2, 001h, L00021

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00241	            op2=0
	MOVE?CT	000h, _OP2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00242	            USBBuffer[0]=4          ;ID
	MOVE?CB	004h, _USBBuffer

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00243	            USBBuffer[1]=KEYS3      ;Code
	MOVE?BB	_KEYS3, _USBBuffer + 00001h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00244	            USBBuffer[2]=analog1    ;Data
	MOVE?BB	_ANALOG1, _USBBuffer + 00002h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00245	            USBBuffer[3]=INPUTS2    ;Data
	MOVE?BB	_INPUTS2, _USBBuffer + 00003h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00247	            gosub DoUSBOut
	GOSUB?L	_DoUSBOut

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00248	        endif
	LABEL?L	L00021	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00250	        if op3=1 then
	CMPNE?TCL	_OP3, 001h, L00023

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00251	            op3=0
	MOVE?CT	000h, _OP3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00252	            USBBuffer[0]=4          ;ID
	MOVE?CB	004h, _USBBuffer

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00253	            USBBuffer[1]=160        ;Code
	MOVE?CB	0A0h, _USBBuffer + 00001h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00254	            USBBuffer[2]=analog3    ;Data
	MOVE?BB	_ANALOG3, _USBBuffer + 00002h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00255	            USBBuffer[3]=analog7    ;Data
	MOVE?BB	_ANALOG7, _USBBuffer + 00003h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00257	            gosub DoUSBOut
	GOSUB?L	_DoUSBOut

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00258	        endif
	LABEL?L	L00023	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00260	        if op4=1 then
	CMPNE?TCL	_OP4, 001h, L00025

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00261	            op4=0
	MOVE?CT	000h, _OP4

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00262	            USBBuffer[0]=4     ;ID
	MOVE?CB	004h, _USBBuffer

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00263	            USBBuffer[1]=224   ;Code
	MOVE?CB	0E0h, _USBBuffer + 00001h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00264	            USBBuffer[2]=INPUTS3   ;Data
	MOVE?BB	_INPUTS3, _USBBuffer + 00002h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00265	            USBBuffer[3]=4     ;Data
	MOVE?CB	004h, _USBBuffer + 00003h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00267	            gosub DoUSBOut
	GOSUB?L	_DoUSBOut

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00268	        endif
	LABEL?L	L00025	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00270	    endif
	LABEL?L	L00007	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00272	    gosub DoUSBIn2
	GOSUB?L	_DoUSBIn2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00274	    if inarc=1 then
	CMPNE?TCL	_INARC, 001h, L00027

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00275	        inarc=0
	MOVE?CT	000h, _INARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00276	        if BUFFIN0=1 then
	CMPNE?BCL	_BUFFIN0, 001h, L00029

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00277	            if BUFFIN1=16 and BUFFIN2=15 then                       
	CMPEQ?BCB	_BUFFIN1, 010h, T1
	CMPEQ?BCB	_BUFFIN2, 00Fh, T2
	LAND?BBW	T1, T2, T2
	CMPF?WL	T2, L00031

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00279	                gosub DoUSBOut
	GOSUB?L	_DoUSBOut

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00280	                OUTPUTS0=0
	MOVE?CB	000h, _OUTPUTS0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00281	                OUTPUTS1=0
	MOVE?CB	000h, _OUTPUTS1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00282	                OUTPUTS2=0
	MOVE?CB	000h, _OUTPUTS2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00283	                gosub WOUT
	GOSUB?L	_WOUT

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00284	                OPERATE=1
	MOVE?CT	001h, _OPERATE

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00285	            endif
	LABEL?L	L00031	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00287	            if BUFFIN1.0=1 and  BUFFIN2=0 then  
	CMPEQ?TCB	_BUFFIN1??0, 001h, T1
	CMPEQ?BCB	_BUFFIN2, 000h, T2
	LAND?BBW	T1, T2, T2
	CMPF?WL	T2, L00033

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00288	                OUTPUTS0.0 = BUFFIN1.5
	MOVE?TT	_BUFFIN1??5, _OUTPUTS0??0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00289	                OUTPUTS0.1 = BUFFIN1.6
	MOVE?TT	_BUFFIN1??6, _OUTPUTS0??1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00290	                OUTPUTS0.2 = BUFFIN1.7
	MOVE?TT	_BUFFIN1??7, _OUTPUTS0??2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00291	                OUTPUTS0.3 = BUFFIN1.3
	MOVE?TT	_BUFFIN1??3, _OUTPUTS0??3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00292	                OUTPUTS0.4 = BUFFIN1.4
	MOVE?TT	_BUFFIN1??4, _OUTPUTS0??4

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00293	                gosub WOUT
	GOSUB?L	_WOUT

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00294	            endif
	LABEL?L	L00033	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00296	        endif      
	LABEL?L	L00029	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00297	    endif
	LABEL?L	L00027	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00298	    USBService
	USBSERVICE?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00299	    COUNTER=COUNTER+1
	ADD?BCB	_COUNTER, 001h, _COUNTER

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00300	goto R4IO
	GOTO?L	_R4IO

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00310	LOADKEY:

	LABEL?L	_LOADKEY	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00311	    KEYPRESS = KEYPRESS + 1
	ADD?BCB	_KEYPRESS, 001h, _KEYPRESS

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00312	    if KEYPRESS >= 4 then KEYPRESS = 0
	CMPLT?BCL	_KEYPRESS, 004h, L00035
	MOVE?CB	000h, _KEYPRESS
	LABEL?L	L00035	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00313	    Select Case KEYPRESS

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00314	        case 0
	CMPNE?BCL	_KEYPRESS, 000h, L00039

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00315	            OUTPUTS1.3=1
	MOVE?CT	001h, _OUTPUTS1??3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00316	            OUTPUTS1.5=0
	MOVE?CT	000h, _OUTPUTS1??5

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00317	            OUTPUTS1.7=0
	MOVE?CT	000h, _OUTPUTS1??7

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00318	            OUTPUTS2.1=0        
	MOVE?CT	000h, _OUTPUTS2??1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00319	        case 1
	GOTO?L	L00038
	LABEL?L	L00039	
	CMPNE?BCL	_KEYPRESS, 001h, L00040

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00320	            OUTPUTS1.3=0
	MOVE?CT	000h, _OUTPUTS1??3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00321	            OUTPUTS1.5=1
	MOVE?CT	001h, _OUTPUTS1??5

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00322	            OUTPUTS1.7=0
	MOVE?CT	000h, _OUTPUTS1??7

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00323	            OUTPUTS2.1=0
	MOVE?CT	000h, _OUTPUTS2??1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00324	        case 2
	GOTO?L	L00038
	LABEL?L	L00040	
	CMPNE?BCL	_KEYPRESS, 002h, L00041

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00325	            OUTPUTS1.3=0
	MOVE?CT	000h, _OUTPUTS1??3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00326	            OUTPUTS1.5=0
	MOVE?CT	000h, _OUTPUTS1??5

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00327	            OUTPUTS1.7=1
	MOVE?CT	001h, _OUTPUTS1??7

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00328	            OUTPUTS2.1=0
	MOVE?CT	000h, _OUTPUTS2??1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00329	        case 3 
	GOTO?L	L00038
	LABEL?L	L00041	
	CMPNE?BCL	_KEYPRESS, 003h, L00042

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00330	            OUTPUTS1.3=0
	MOVE?CT	000h, _OUTPUTS1??3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00331	            OUTPUTS1.5=0
	MOVE?CT	000h, _OUTPUTS1??5

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00332	            OUTPUTS1.7=0
	MOVE?CT	000h, _OUTPUTS1??7

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00333	            OUTPUTS2.1=1
	MOVE?CT	001h, _OUTPUTS2??1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00334	    end select
	LABEL?L	L00042	
	LABEL?L	L00038	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00335	    gosub WOUT
	GOSUB?L	_WOUT

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00336	    gosub READIN
	GOSUB?L	_READIN

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00337	    COLARC=1
	MOVE?CT	001h, _COLARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00339	    if col0=0 and COLARC=1 then
	CMPEQ?TCB	_COL0, 000h, T1
	CMPEQ?TCB	_COLARC, 001h, T2
	LAND?BBW	T1, T2, T2
	CMPF?WL	T2, L00043

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00340	        Select Case KEYPRESS

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00341	        Case 0
	CMPNE?BCL	_KEYPRESS, 000h, L00047

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00342	            KEYS3 = 192
	MOVE?CB	0C0h, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00343	        Case 1
	GOTO?L	L00046
	LABEL?L	L00047	
	CMPNE?BCL	_KEYPRESS, 001h, L00048

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00344	            KEYS3 = 195
	MOVE?CB	0C3h, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00345	        Case 2
	GOTO?L	L00046
	LABEL?L	L00048	
	CMPNE?BCL	_KEYPRESS, 002h, L00049

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00346	            KEYS3 = 198
	MOVE?CB	0C6h, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00347	        Case 3
	GOTO?L	L00046
	LABEL?L	L00049	
	CMPNE?BCL	_KEYPRESS, 003h, L00050

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00348	            KEYS3 = 201
	MOVE?CB	0C9h, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00349	        End Select
	LABEL?L	L00050	
	LABEL?L	L00046	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00350	        COLARC=0
	MOVE?CT	000h, _COLARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00351	    endif
	LABEL?L	L00043	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00353	    if col1=0 and COLARC=1 then
	CMPEQ?TCB	_COL1, 000h, T1
	CMPEQ?TCB	_COLARC, 001h, T2
	LAND?BBW	T1, T2, T2
	CMPF?WL	T2, L00051

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00354	        Select Case KEYPRESS

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00355	        Case 0
	CMPNE?BCL	_KEYPRESS, 000h, L00055

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00356	            KEYS3 = 193
	MOVE?CB	0C1h, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00357	        Case 1
	GOTO?L	L00054
	LABEL?L	L00055	
	CMPNE?BCL	_KEYPRESS, 001h, L00056

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00358	            KEYS3 = 196
	MOVE?CB	0C4h, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00359	        Case 2
	GOTO?L	L00054
	LABEL?L	L00056	
	CMPNE?BCL	_KEYPRESS, 002h, L00057

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00360	            KEYS3 = 199
	MOVE?CB	0C7h, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00361	        Case 3
	GOTO?L	L00054
	LABEL?L	L00057	
	CMPNE?BCL	_KEYPRESS, 003h, L00058

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00362	            KEYS3 = 202
	MOVE?CB	0CAh, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00363	        End Select
	LABEL?L	L00058	
	LABEL?L	L00054	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00364	        COLARC=0
	MOVE?CT	000h, _COLARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00365	    endif
	LABEL?L	L00051	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00367	    if col2=0 and COLARC=1 then
	CMPEQ?TCB	_COL2, 000h, T1
	CMPEQ?TCB	_COLARC, 001h, T2
	LAND?BBW	T1, T2, T2
	CMPF?WL	T2, L00059

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00368	        Select Case KEYPRESS

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00369	        Case 0
	CMPNE?BCL	_KEYPRESS, 000h, L00063

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00370	            KEYS3 = 194
	MOVE?CB	0C2h, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00371	        Case 1
	GOTO?L	L00062
	LABEL?L	L00063	
	CMPNE?BCL	_KEYPRESS, 001h, L00064

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00372	            KEYS3 = 197
	MOVE?CB	0C5h, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00373	        Case 2
	GOTO?L	L00062
	LABEL?L	L00064	
	CMPNE?BCL	_KEYPRESS, 002h, L00065

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00374	            KEYS3 = 200
	MOVE?CB	0C8h, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00375	        Case 3
	GOTO?L	L00062
	LABEL?L	L00065	
	CMPNE?BCL	_KEYPRESS, 003h, L00066

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00376	            KEYS3 = 203
	MOVE?CB	0CBh, _KEYS3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00377	        End Select
	LABEL?L	L00066	
	LABEL?L	L00062	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00378	        COLARC=0
	MOVE?CT	000h, _COLARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00379	    endif
	LABEL?L	L00059	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00381	    if COLARC=1 then
	CMPNE?TCL	_COLARC, 001h, L00067

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00382	        VATEMP=VATEMP+1
	ADD?BCB	_VATEMP, 001h, _VATEMP

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00383	    else
	GOTO?L	L00068
	LABEL?L	L00067	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00384	        VATEMP=0
	MOVE?CB	000h, _VATEMP

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00385	    endif
	LABEL?L	L00068	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00387	    if VATEMP >= 11 then vatemp=0 : KEYS3 = 207
	CMPLT?BCL	_VATEMP, 00Bh, L00069
	MOVE?CB	000h, _VATEMP
	MOVE?CB	0CFh, _KEYS3
	LABEL?L	L00069	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00389	return 
	RETURN?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00393	READIN:

	LABEL?L	_READIN	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00394	    low PORTA.4
	LOW?T	_PORTA??4

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00395	    pauseus 119
	PAUSEUS?C	077h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00396	    if PORTD.4 = 1 then inputs0.4 = 1 ;R
	CMPNE?TCL	_PORTD??4, 001h, L00071
	MOVE?CT	001h, _INPUTS0??4
	LABEL?L	L00071	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00397	    if PORTD.5 = 1 then inputs0.7 = 1 ;S
	CMPNE?TCL	_PORTD??5, 001h, L00073
	MOVE?CT	001h, _INPUTS0??7
	LABEL?L	L00073	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00398	    if PORTD.6 = 1 then inputs0.2 = 1 ;T
	CMPNE?TCL	_PORTD??6, 001h, L00075
	MOVE?CT	001h, _INPUTS0??2
	LABEL?L	L00075	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00399	    if PORTD.7 = 1 then inputs0.3 = 1 ;U
	CMPNE?TCL	_PORTD??7, 001h, L00077
	MOVE?CT	001h, _INPUTS0??3
	LABEL?L	L00077	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00401	    if PORTB.0 = 1 then inputs2.4 = 1 ;V
	CMPNE?TCL	_PORTB??0, 001h, L00079
	MOVE?CT	001h, _INPUTS2??4
	LABEL?L	L00079	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00402	    if PORTB.1 = 1 then inputs2.5 = 1 ;W
	CMPNE?TCL	_PORTB??1, 001h, L00081
	MOVE?CT	001h, _INPUTS2??5
	LABEL?L	L00081	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00403	    if PORTB.2 = 1 then inputs2.6 = 1 ;X
	CMPNE?TCL	_PORTB??2, 001h, L00083
	MOVE?CT	001h, _INPUTS2??6
	LABEL?L	L00083	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00404	    if PORTB.3 = 1 then inputs2.7 = 1 ;Y
	CMPNE?TCL	_PORTB??3, 001h, L00085
	MOVE?CT	001h, _INPUTS2??7
	LABEL?L	L00085	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00406	    if PORTB.4 = 1 then inputs1.2 = 1 ;Z
	CMPNE?TCL	_PORTB??4, 001h, L00087
	MOVE?CT	001h, _INPUTS1??2
	LABEL?L	L00087	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00407	    if PORTB.5 = 1 then inputs1.3 = 1 ;a
	CMPNE?TCL	_PORTB??5, 001h, L00089
	MOVE?CT	001h, _INPUTS1??3
	LABEL?L	L00089	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00411	    if PORTE.1 = 1 then INPUTS3.1 = 1 ;J4-4
	CMPNE?TCL	_PORTE??1, 001h, L00091
	MOVE?CT	001h, _INPUTS3??1
	LABEL?L	L00091	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00412	    if PORTE.0 = 1 then INPUTS3.3 = 1 ;J4-6
	CMPNE?TCL	_PORTE??0, 001h, L00093
	MOVE?CT	001h, _INPUTS3??3
	LABEL?L	L00093	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00413	    if PORTE.3 = 1 then INPUTS3.5 = 1 ;J4-8
	CMPNE?TCL	_PORTE??3, 001h, L00095
	MOVE?CT	001h, _INPUTS3??5
	LABEL?L	L00095	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00414	    if PORTE.2 = 1 then INPUTS3.7 = 1 ;d
	CMPNE?TCL	_PORTE??2, 001h, L00097
	MOVE?CT	001h, _INPUTS3??7
	LABEL?L	L00097	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00417	    if PORTD.4 = 0 then inputs0.4 = 0 ;R
	CMPNE?TCL	_PORTD??4, 000h, L00099
	MOVE?CT	000h, _INPUTS0??4
	LABEL?L	L00099	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00418	    if PORTD.5 = 0 then inputs0.7 = 0 ;S
	CMPNE?TCL	_PORTD??5, 000h, L00101
	MOVE?CT	000h, _INPUTS0??7
	LABEL?L	L00101	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00419	    if PORTD.6 = 0 then inputs0.2 = 0 ;T
	CMPNE?TCL	_PORTD??6, 000h, L00103
	MOVE?CT	000h, _INPUTS0??2
	LABEL?L	L00103	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00420	    if PORTD.7 = 0 then inputs0.3 = 0 ;U
	CMPNE?TCL	_PORTD??7, 000h, L00105
	MOVE?CT	000h, _INPUTS0??3
	LABEL?L	L00105	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00422	    if PORTB.0 = 0 then inputs2.4 = 0 ;V
	CMPNE?TCL	_PORTB??0, 000h, L00107
	MOVE?CT	000h, _INPUTS2??4
	LABEL?L	L00107	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00423	    if PORTB.1 = 0 then inputs2.5 = 0 ;W
	CMPNE?TCL	_PORTB??1, 000h, L00109
	MOVE?CT	000h, _INPUTS2??5
	LABEL?L	L00109	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00424	    if PORTB.2 = 0 then inputs2.6 = 0 ;X
	CMPNE?TCL	_PORTB??2, 000h, L00111
	MOVE?CT	000h, _INPUTS2??6
	LABEL?L	L00111	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00425	    if PORTB.3 = 0 then inputs2.7 = 0 ;Y
	CMPNE?TCL	_PORTB??3, 000h, L00113
	MOVE?CT	000h, _INPUTS2??7
	LABEL?L	L00113	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00427	    if PORTB.4 = 0 then inputs1.2 = 0 ;Z
	CMPNE?TCL	_PORTB??4, 000h, L00115
	MOVE?CT	000h, _INPUTS1??2
	LABEL?L	L00115	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00428	    if PORTB.5 = 0 then inputs1.3 = 0 ;a
	CMPNE?TCL	_PORTB??5, 000h, L00117
	MOVE?CT	000h, _INPUTS1??3
	LABEL?L	L00117	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00432	    if PORTE.1 = 0 then INPUTS3.1 = 0 ;J4-4
	CMPNE?TCL	_PORTE??1, 000h, L00119
	MOVE?CT	000h, _INPUTS3??1
	LABEL?L	L00119	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00433	    if PORTE.0 = 0 then INPUTS3.3 = 0 ;J4-6
	CMPNE?TCL	_PORTE??0, 000h, L00121
	MOVE?CT	000h, _INPUTS3??3
	LABEL?L	L00121	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00434	    if PORTE.3 = 0 then INPUTS3.5 = 0 ;J4-8
	CMPNE?TCL	_PORTE??3, 000h, L00123
	MOVE?CT	000h, _INPUTS3??5
	LABEL?L	L00123	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00435	    if PORTE.2 = 0 then INPUTS3.7 = 0 ;d
	CMPNE?TCL	_PORTE??2, 000h, L00125
	MOVE?CT	000h, _INPUTS3??7
	LABEL?L	L00125	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00437	    high PORTA.4
	HIGH?T	_PORTA??4

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00438	    pauseus 119
	PAUSEUS?C	077h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00439	    if PORTD.4 = 1 then inputs0.5 = 1 ;15
	CMPNE?TCL	_PORTD??4, 001h, L00127
	MOVE?CT	001h, _INPUTS0??5
	LABEL?L	L00127	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00440	    if PORTD.5 = 1 then inputs0.0 = 1 ;16
	CMPNE?TCL	_PORTD??5, 001h, L00129
	MOVE?CT	001h, _INPUTS0??0
	LABEL?L	L00129	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00441	    if PORTD.6 = 1 then inputs0.1 = 1 ;17
	CMPNE?TCL	_PORTD??6, 001h, L00131
	MOVE?CT	001h, _INPUTS0??1
	LABEL?L	L00131	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00442	    if PORTD.7 = 1 then inputs2.0 = 1 ;18
	CMPNE?TCL	_PORTD??7, 001h, L00133
	MOVE?CT	001h, _INPUTS2??0
	LABEL?L	L00133	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00444	    if PORTB.0 = 1 then inputs2.1 = 1 ;19
	CMPNE?TCL	_PORTB??0, 001h, L00135
	MOVE?CT	001h, _INPUTS2??1
	LABEL?L	L00135	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00445	    if PORTB.1 = 1 then inputs2.2 = 1 ;20
	CMPNE?TCL	_PORTB??1, 001h, L00137
	MOVE?CT	001h, _INPUTS2??2
	LABEL?L	L00137	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00446	    if PORTB.2 = 1 then inputs2.3 = 1 ;21
	CMPNE?TCL	_PORTB??2, 001h, L00139
	MOVE?CT	001h, _INPUTS2??3
	LABEL?L	L00139	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00447	    if PORTB.3 = 1 then COL0 = 1 ;22
	CMPNE?TCL	_PORTB??3, 001h, L00141
	MOVE?CT	001h, _COL0
	LABEL?L	L00141	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00449	    if PORTB.4 = 1 then COL1 = 1 ;23
	CMPNE?TCL	_PORTB??4, 001h, L00143
	MOVE?CT	001h, _COL1
	LABEL?L	L00143	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00450	    if PORTB.5 = 1 then COL2 = 1 ;24
	CMPNE?TCL	_PORTB??5, 001h, L00145
	MOVE?CT	001h, _COL2
	LABEL?L	L00145	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00454	    if PORTE.2 = 1 then INPUTS3.0 = 1 ;J4-3
	CMPNE?TCL	_PORTE??2, 001h, L00147
	MOVE?CT	001h, _INPUTS3??0
	LABEL?L	L00147	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00455	    if PORTE.1 = 1 then INPUTS3.2 = 1 ;J4-5
	CMPNE?TCL	_PORTE??1, 001h, L00149
	MOVE?CT	001h, _INPUTS3??2
	LABEL?L	L00149	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00456	    if PORTE.0 = 1 then INPUTS3.4 = 1 ;J4-7
	CMPNE?TCL	_PORTE??0, 001h, L00151
	MOVE?CT	001h, _INPUTS3??4
	LABEL?L	L00151	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00457	    if PORTE.3 = 1 then INPUTS3.6 = 1 ;J4-9
	CMPNE?TCL	_PORTE??3, 001h, L00153
	MOVE?CT	001h, _INPUTS3??6
	LABEL?L	L00153	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00460	    if PORTD.4 = 0 then inputs0.5 = 0 ;15
	CMPNE?TCL	_PORTD??4, 000h, L00155
	MOVE?CT	000h, _INPUTS0??5
	LABEL?L	L00155	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00461	    if PORTD.5 = 0 then inputs0.0 = 0 ;16
	CMPNE?TCL	_PORTD??5, 000h, L00157
	MOVE?CT	000h, _INPUTS0??0
	LABEL?L	L00157	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00462	    if PORTD.6 = 0 then inputs0.1 = 0 ;17
	CMPNE?TCL	_PORTD??6, 000h, L00159
	MOVE?CT	000h, _INPUTS0??1
	LABEL?L	L00159	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00463	    if PORTD.7 = 0 then inputs2.0 = 0 ;18
	CMPNE?TCL	_PORTD??7, 000h, L00161
	MOVE?CT	000h, _INPUTS2??0
	LABEL?L	L00161	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00465	    if PORTB.0 = 0 then inputs2.1 = 0 ;19
	CMPNE?TCL	_PORTB??0, 000h, L00163
	MOVE?CT	000h, _INPUTS2??1
	LABEL?L	L00163	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00466	    if PORTB.1 = 0 then inputs2.2 = 0 ;20
	CMPNE?TCL	_PORTB??1, 000h, L00165
	MOVE?CT	000h, _INPUTS2??2
	LABEL?L	L00165	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00467	    if PORTB.2 = 0 then inputs2.3 = 0 ;21
	CMPNE?TCL	_PORTB??2, 000h, L00167
	MOVE?CT	000h, _INPUTS2??3
	LABEL?L	L00167	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00468	    if PORTB.3 = 0 then COL0 = 0;22
	CMPNE?TCL	_PORTB??3, 000h, L00169
	MOVE?CT	000h, _COL0
	LABEL?L	L00169	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00470	    if PORTB.4 = 0 then COL1 = 0 ;23
	CMPNE?TCL	_PORTB??4, 000h, L00171
	MOVE?CT	000h, _COL1
	LABEL?L	L00171	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00471	    if PORTB.5 = 0 then COL2 = 0 ;24
	CMPNE?TCL	_PORTB??5, 000h, L00173
	MOVE?CT	000h, _COL2
	LABEL?L	L00173	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00475	    if PORTE.2 = 0 then INPUTS3.0 = 0 ;J4-3
	CMPNE?TCL	_PORTE??2, 000h, L00175
	MOVE?CT	000h, _INPUTS3??0
	LABEL?L	L00175	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00476	    if PORTE.1 = 0 then INPUTS3.2 = 0 ;J4-5
	CMPNE?TCL	_PORTE??1, 000h, L00177
	MOVE?CT	000h, _INPUTS3??2
	LABEL?L	L00177	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00477	    if PORTE.0 = 0 then INPUTS3.4 = 0 ;J4-7
	CMPNE?TCL	_PORTE??0, 000h, L00179
	MOVE?CT	000h, _INPUTS3??4
	LABEL?L	L00179	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00478	    if PORTE.3 = 0 then INPUTS3.6 = 0 ;J4-9
	CMPNE?TCL	_PORTE??3, 000h, L00181
	MOVE?CT	000h, _INPUTS3??6
	LABEL?L	L00181	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00480	return
	RETURN?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00485	READANALOG:

	LABEL?L	_READANALOG	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00486	    LOW PORTA.2
	LOW?T	_PORTA??2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00487	    LOW PORTA.3
	LOW?T	_PORTA??3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00488	    ADCIN 0, aninput0     
	ADCIN?CW	000h, _ANINPUT0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00489	    ADCIN 1, aninput1
	ADCIN?CW	001h, _ANINPUT1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00490	    aninput0=aninput0>>2
	SHIFTR?WCW	_ANINPUT0, 002h, _ANINPUT0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00491	    aninput1=aninput1>>2
	SHIFTR?WCW	_ANINPUT1, 002h, _ANINPUT1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00493	    ANALOG0=aninput0
	MOVE?WB	_ANINPUT0, _ANALOG0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00494	    ANALOG1=aninput1
	MOVE?WB	_ANINPUT1, _ANALOG1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00496	    HIGH PORTA.2
	HIGH?T	_PORTA??2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00497	    LOW PORTA.3    
	LOW?T	_PORTA??3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00498	    ADCIN 0, aninput0     
	ADCIN?CW	000h, _ANINPUT0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00499	    ADCIN 1, aninput1
	ADCIN?CW	001h, _ANINPUT1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00500	    aninput0=aninput0>>2
	SHIFTR?WCW	_ANINPUT0, 002h, _ANINPUT0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00501	    aninput1=aninput1>>2
	SHIFTR?WCW	_ANINPUT1, 002h, _ANINPUT1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00503	    ANALOG2=aninput0
	MOVE?WB	_ANINPUT0, _ANALOG2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00504	    ANALOG3=aninput1
	MOVE?WB	_ANINPUT1, _ANALOG3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00506	    LOW PORTA.2
	LOW?T	_PORTA??2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00507	    HIGH PORTA.3
	HIGH?T	_PORTA??3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00508	    ADCIN 0, aninput0     
	ADCIN?CW	000h, _ANINPUT0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00509	    ADCIN 1, aninput1
	ADCIN?CW	001h, _ANINPUT1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00510	    aninput0=aninput0>>2
	SHIFTR?WCW	_ANINPUT0, 002h, _ANINPUT0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00511	    aninput1=aninput1>>2
	SHIFTR?WCW	_ANINPUT1, 002h, _ANINPUT1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00513	    ANALOG4=aninput0
	MOVE?WB	_ANINPUT0, _ANALOG4

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00514	    ANALOG5=aninput1
	MOVE?WB	_ANINPUT1, _ANALOG5

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00516	    HIGH PORTA.2
	HIGH?T	_PORTA??2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00517	    HIGH PORTA.3
	HIGH?T	_PORTA??3

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00518	    ADCIN 0, aninput0     
	ADCIN?CW	000h, _ANINPUT0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00519	    ADCIN 1, aninput1
	ADCIN?CW	001h, _ANINPUT1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00520	    aninput0=aninput0>>2
	SHIFTR?WCW	_ANINPUT0, 002h, _ANINPUT0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00521	    aninput1=aninput1>>2
	SHIFTR?WCW	_ANINPUT1, 002h, _ANINPUT1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00523	    ANALOG6=aninput0
	MOVE?WB	_ANINPUT0, _ANALOG6

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00524	    ANALOG7=aninput1
	MOVE?WB	_ANINPUT1, _ANALOG7

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00526	RETURN
	RETURN?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00530	WOUT:

	LABEL?L	_WOUT	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00531	    high portd.0
	HIGH?T	_PORTD??0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00532	    high portd.1
	HIGH?T	_PORTD??1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00533	    Shiftout  portd.3 , portd.1, 5, [OUTPUTS2,OUTPUTS1,OUTPUTS0]
	SHIFTDATA?T	_PORTD??3
	SHIFTCLOCK?T	_PORTD??1
	SHIFTMODE?C	005h
	SHIFTOUT?BC	_OUTPUTS2, 008h
	SHIFTOUT?BC	_OUTPUTS1, 008h
	SHIFTOUT?BC	_OUTPUTS0, 008h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00534	    high portd.2
	HIGH?T	_PORTD??2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00535	    pauseus 2
	PAUSEUS?C	002h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00536	    low portd.2
	LOW?T	_PORTD??2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00537	    pauseus 360
	PAUSEUS?C	00168h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00538	return
	RETURN?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00543	DoUSBIn:

	LABEL?L	_DoUSBIn	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00544	    USBBufferCount = USBBufferSizeRX              ' RX buffer size
	MOVE?CB	_USBBufferSizeRX, _USBBufferCount

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00545	    USBService                                    ' keep connection alive
	USBSERVICE?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00546	    USBIn 2, USBBuffer, USBBufferCount, DoUSBIn   ' read data, if available
	USBIN?CBBL	002h, _USBBuffer, _USBBufferCount, _DoUSBIn

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00548	    if BUFFIN0 <> USBBuffer[0]then
	CMPEQ?BBL	_BUFFIN0, _USBBuffer, L00183

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00549	        INARC=1
	MOVE?CT	001h, _INARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00550	        BUFFIN0=USBBuffer[0]
	MOVE?BB	_USBBuffer, _BUFFIN0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00551	    endif
	LABEL?L	L00183	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00553	    if BUFFIN1 <> USBBuffer[1] then
	CMPEQ?BBL	_BUFFIN1, _USBBuffer + 00001h, L00185

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00554	        inarc=1
	MOVE?CT	001h, _INARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00555	        BUFFIN1=USBBuffer[1]
	MOVE?BB	_USBBuffer + 00001h, _BUFFIN1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00556	    endif
	LABEL?L	L00185	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00558	    if BUFFIN2 <> USBBuffer[2] then
	CMPEQ?BBL	_BUFFIN2, _USBBuffer + 00002h, L00187

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00559	        inarc=1
	MOVE?CT	001h, _INARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00560	        BUFFIN2=USBBuffer[2]
	MOVE?BB	_USBBuffer + 00002h, _BUFFIN2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00561	    endif
	LABEL?L	L00187	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00563	    USBBuffer[0]=0
	MOVE?CB	000h, _USBBuffer

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00564	    USBBuffer[1]=0
	MOVE?CB	000h, _USBBuffer + 00001h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00565	    USBBuffer[2]=0
	MOVE?CB	000h, _USBBuffer + 00002h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00566	    USBBuffer[3]=0
	MOVE?CB	000h, _USBBuffer + 00003h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00567	    USBBuffer[4]=0
	MOVE?CB	000h, _USBBuffer + 00004h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00568	    USBBuffer[5]=0
	MOVE?CB	000h, _USBBuffer + 00005h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00569	    USBBuffer[6]=0
	MOVE?CB	000h, _USBBuffer + 00006h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00570	    USBBuffer[7]=0
	MOVE?CB	000h, _USBBuffer + 00007h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00571	    if OPERATE=1 then Toggle porta.6                                ' Message received
	CMPNE?TCL	_OPERATE, 001h, L00189
	TOGGLE?T	_PORTA??6
	LABEL?L	L00189	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00572	return
	RETURN?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00577	DoUSBOut:

	LABEL?L	_DoUSBOut	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00578	    USBBufferCount = USBBufferSizeTX              ' TX buffer size 
	MOVE?CB	_USBBufferSizeTX, _USBBufferCount

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00579	    USBService                                    ' keep connection alive
	USBSERVICE?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00580	    USBOut 1, USBBuffer, USBBufferCount, DoUSBOut ' if bus available, transmit data
	USBOUT?CBBL	001h, _USBBuffer, _USBBufferCount, _DoUSBOut

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00581	    USBBuffer[0]=0
	MOVE?CB	000h, _USBBuffer

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00582	    USBBuffer[1]=0
	MOVE?CB	000h, _USBBuffer + 00001h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00583	    USBBuffer[2]=0
	MOVE?CB	000h, _USBBuffer + 00002h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00584	    USBBuffer[3]=0
	MOVE?CB	000h, _USBBuffer + 00003h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00585	    USBBuffer[4]=0
	MOVE?CB	000h, _USBBuffer + 00004h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00586	    USBBuffer[5]=0
	MOVE?CB	000h, _USBBuffer + 00005h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00587	    USBBuffer[6]=0
	MOVE?CB	000h, _USBBuffer + 00006h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00588	    USBBuffer[7]=0
	MOVE?CB	000h, _USBBuffer + 00007h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00589	    Toggle porta.6                                ' Message received
	TOGGLE?T	_PORTA??6

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00590	return
	RETURN?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00595	READ485:

	LABEL?L	_READ485	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00596	return
	RETURN?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00601	WRITE485:

	LABEL?L	_WRITE485	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00602	return
	RETURN?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00607	DoUSBIn2:

	LABEL?L	_DoUSBIn2	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00608	    USBBufferCount = USBBufferSizeRX              ' RX buffer size
	MOVE?CB	_USBBufferSizeRX, _USBBufferCount

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00609	    USBService                                    ' keep connection alive
	USBSERVICE?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00610	    USBIn 2, USBBuffer, USBBufferCount, ARCUSB   ' read data, if available
	USBIN?CBBL	002h, _USBBuffer, _USBBufferCount, _ARCUSB

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00612	    if usb_arc=1 then
	CMPNE?TCL	_USB_ARC, 001h, L00191

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00613	        if BUFFIN0 <> USBBuffer[0]then
	CMPEQ?BBL	_BUFFIN0, _USBBuffer, L00193

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00614	            INARC=1
	MOVE?CT	001h, _INARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00615	            BUFFIN0=USBBuffer[0]
	MOVE?BB	_USBBuffer, _BUFFIN0

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00616	        endif
	LABEL?L	L00193	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00618	        if BUFFIN1 <> USBBuffer[1] then
	CMPEQ?BBL	_BUFFIN1, _USBBuffer + 00001h, L00195

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00619	            inarc=1
	MOVE?CT	001h, _INARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00620	            BUFFIN1=USBBuffer[1]
	MOVE?BB	_USBBuffer + 00001h, _BUFFIN1

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00621	        endif
	LABEL?L	L00195	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00623	        if BUFFIN2 <> USBBuffer[2] then
	CMPEQ?BBL	_BUFFIN2, _USBBuffer + 00002h, L00197

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00624	            inarc=1
	MOVE?CT	001h, _INARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00625	            BUFFIN2=USBBuffer[2]
	MOVE?BB	_USBBuffer + 00002h, _BUFFIN2

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00626	        endif
	LABEL?L	L00197	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00627	        usb_arc=0
	MOVE?CT	000h, _USB_ARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00628	    endif
	LABEL?L	L00191	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00630	    USBBuffer[0]=0
	MOVE?CB	000h, _USBBuffer

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00631	    USBBuffer[1]=0
	MOVE?CB	000h, _USBBuffer + 00001h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00632	    USBBuffer[2]=0
	MOVE?CB	000h, _USBBuffer + 00002h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00633	    USBBuffer[3]=0
	MOVE?CB	000h, _USBBuffer + 00003h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00634	    USBBuffer[4]=0
	MOVE?CB	000h, _USBBuffer + 00004h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00635	    USBBuffer[5]=0
	MOVE?CB	000h, _USBBuffer + 00005h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00636	    USBBuffer[6]=0
	MOVE?CB	000h, _USBBuffer + 00006h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00637	    USBBuffer[7]=0
	MOVE?CB	000h, _USBBuffer + 00007h

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00638	return
	RETURN?	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00640	ARCUSB:

	LABEL?L	_ARCUSB	

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00641	    usb_arc=1
	MOVE?CT	001h, _USB_ARC

; C:\DATOS\DISEñOS\DCL I-O SAMPLE\FIRMRARE\RAW THRILLS RELEASE4\FIRMWARE\TESTIO\RELEASE4.PBP	00642	return
	RETURN?	

	END
