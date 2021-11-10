
' USB descriptors for a HID device
'USBMEMORYADDRESS Con	$400	' USB RAM starts here (set in device header file)
USBMEMORYSIZE	Con	256	' USB RAM size in bytes
USBReservedMemory Var Byte[USBMEMORYSIZE] USBMEMORYADDRESS	' Reserve memory used by USB assembler code

goto	hid_desc_end	' Skip over all of the USB assembler code
asm

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


endasm
hid_desc_end
 
 
