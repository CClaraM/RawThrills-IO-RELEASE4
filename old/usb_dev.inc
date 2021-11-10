; usb_dev.inc
; 7/7/08 microEngineering Labs, Inc.

; Buffer Descriptor Status Register Initialization Parameters
#define	_BSTALL		0x04		; Buffer Stall enable
#define	_DTSEN		0x08		; Data Toggle Synch enable
#define	_INCDIS		0x10		; Address increment disable
#define	_KEN		0x20		; SIE keeps buff descriptors enable
#define	_DAT0		0x00		; DATA0 packet expected next
#define	_DAT1		0x40		; DATA1 packet expected next
#define	_DTSMASK	0x40		; DTS Mask
#define	_USIE		0x80		; SIE owns buffer
#define	_UCPU		0x00		; CPU owns buffer

;#define _STAT_MASK	0xFF

; PIC Endpoint Definitions
; PIC Endpoint Address Format: X:EP3:EP2:EP1:EP0:DIR:PPBI:X
; This is used when checking the value read from USTAT
; NOTE: These definitions are not used in the descriptors.
; EP addresses used in the descriptors have different format.
#define USTAT_EP0_PP_MASK	 ~0x02
#define USTAT_EP_MASK		0x7E
#define USTAT_EP0_OUT		0x00
#define USTAT_EP0_IN		0x04

#define UEP_STALL	0x0001

; USB Endpoint Definitions
; USB Standard EP Address Format: DIR:X:X:X:EP3:EP2:EP1:EP0
; This is used in the descriptors.
; NOTE: Do not use these values for checking against USTAT.
#define _EP_IN		0x80
#define _EP_OUT		0x00
#define _EP01_OUT	0x01
#define _EP01_IN	0x81
#define _EP02_OUT	0x02
#define _EP02_IN	0x82
;#define _EP03_OUT	0x03
;#define _EP03_IN	0x83
;#define _EP04_OUT	0x04
;#define _EP04_IN	0x84
;#define _EP05_OUT	0x05
;#define _EP05_IN	0x85
;#define _EP06_OUT	0x06
;#define _EP06_IN	0x86
;#define _EP07_OUT	0x07
;#define _EP07_IN	0x87
;#define _EP08_OUT	0x08
;#define _EP08_IN	0x88
;#define _EP09_OUT	0x09
;#define _EP09_IN	0x89
;#define _EP10_OUT	0x0A
;#define _EP10_IN	0x8A
;#define _EP11_OUT	0x0B
;#define _EP11_IN	0x8B
;#define _EP12_OUT	0x0C
;#define _EP12_IN	0x8C
;#define _EP13_OUT	0x0D
;#define _EP13_IN	0x8D
;#define _EP14_OUT	0x0E
;#define _EP14_IN	0x8E
;#define _EP15_OUT	0x0F
;#define _EP15_IN	0x8F

; Configuration Attributes
#define _DEFAULT	(0x01<<7)	; Default Value (Bit 7 is set)
#define _SELF		(0x01<<6)	; Self-powered (Supports if set)
#define _RWU		(0x01<<5)	; Remote Wakeup (Supports if set)

; Endpoint Transfer Type
#define _CTRL		0x00		; Control Transfer
#define _ISO		0x01		; Isochronous Transfer
#define _BULK		0x02		; Bulk Transfer
#define _INT		0x03		; Interrupt Transfer

;#define _ROM		USB_INPIPES_ROM
;#define _RAM		USB_INPIPES_RAM

; Various options for setting the PIPES
#define USB_INPIPES_ROM		0x00	; Data comes from RAM
#define USB_INPIPES_RAM		0x01	; Data comes from ROM
#define USB_INPIPES_BUSY	0x80	; The PIPE is busy
#define USB_INPIPES_INCLUDE_ZERO 0x40	; Include a trailing zero packet
#define USB_INPIPES_NO_DATA	0x00	; No data to send
#define USB_INPIPES_NO_OPTIONS	0x00	; No options set

#define USB_EP0_ROM		USB_INPIPES_ROM
#define USB_EP0_RAM		USB_INPIPES_RAM
#define USB_EP0_BUSY		USB_INPIPES_BUSY
#define USB_EP0_INCLUDE_ZERO	USB_INPIPES_INCLUDE_ZERO
#define USB_EP0_NO_DATA		USB_INPIPES_NO_DATA
#define USB_EP0_NO_OPTIONS	USB_INPIPES_NO_OPTIONS

; Standard Request Codes
; USB 2.0 Spec Ref Table 9-4
#define	GET_STATUS	0
#define	CLR_FEATURE	1
#define	SET_FEATURE	3
#define	SET_ADR		5
#define	GET_DSC		6
#define	SET_DSC		7
#define	GET_CFG		8
#define	SET_CFG		9
#define	GET_INTF	10
#define	SET_INTF	11
#define	SYNCH_FRAME	12

; Standard Feature Selectors
#define	DEVICE_REMOTE_WAKEUP	0x01
#define	ENDPOINT_HALT		0x00

; USB Device States - To be used with [USBDeviceState]
#define DETACHED_STATE		0x00
#define ATTACHED_STATE		0x01
#define POWERED_STATE		0x02
#define DEFAULT_STATE		0x04
#define ADR_PENDING_STATE	0x08
#define ADDRESS_STATE		0x10
#define CONFIGURED_STATE	0x20

#define USB_PING_PONG__NO_PING_PONG	0x00	; 0b00
#define USB_PING_PONG__EP0_OUT_ONLY	0x01	; 0b01
#define USB_PING_PONG__FULL_PING_PONG	0x02	; 0b10
#define USB_PING_PONG__ALL_BUT_EP0	0x03	; 0b11

; UCFG Initialization Parameters
#define USB_PULLUP_ENABLE		0x10
#define USB_PULLUP_DISABLED		0x00
    
#define USB_INTERNAL_TRANSCEIVER	0x00
#define USB_EXTERNAL_TRANSCEIVER	0x08
    
#define USB_FULL_SPEED			0x04
#define USB_LOW_SPEED			0x00

; UEPn Initialization Parameters
#define EP_CTRL		0x06		; Cfg Control pipe for this ep
#define EP_OUT		0x0C		; Cfg OUT only pipe for this ep
#define EP_IN		0x0A		; Cfg IN only pipe for this ep
#define EP_OUT_IN	0x0E		; Cfg both OUT & IN pipes for this ep

; Handshake should be disable for isoch
#define USB_HANDSHAKE_ENABLED   0x10
#define USB_HANDSHAKE_DISABLED  0x00

#define USB_OUT_ENABLED         0x04
#define USB_OUT_DISABLED        0x00

#define USB_IN_ENABLED          0x02
#define USB_IN_DISABLED         0x00

#define USB_ALLOW_SETUP         0x00
#define USB_DISALLOW_SETUP      0x08

#define USB_STALL_ENDPOINT      0x01

; Control Transfer States
#define WAIT_SETUP	0
#define CTRL_TRF_TX	1
#define CTRL_TRF_RX	2

; Short Packet States - Used by Control Transfer Read  - CTRL_TRF_TX
#define SHORT_PKT_NOT_USED	0
#define SHORT_PKT_PENDING	1
#define SHORT_PKT_SENT		2

; USB PID: Token Types - See chapter 8 in the USB specification
#define SETUP_TOKEN	0x0D		; 0b00001101
#define OUT_TOKEN	0x01		; 0b00000001
#define IN_TOKEN	0x09		; 0b00001001

; bmRequestType Definitions
#define HOST_TO_DEV	0
#define DEV_TO_HOST	1

#define STANDARD	0x00
#define CLASS		0x01
#define VENDOR		0x02

#define RCPT_DEV	0
#define RCPT_INTF	1
#define RCPT_EP		2
#define RCPT_OTH	3

; Section: USB Descriptors
#define USB_DESCRIPTOR_DEVICE		0x01	; bDescriptorType for a Device Descriptor.
#define USB_DESCRIPTOR_CONFIGURATION	0x02	; bDescriptorType for a Configuration Descriptor.
#define USB_DESCRIPTOR_STRING		0x03	; bDescriptorType for a String Descriptor.
#define USB_DESCRIPTOR_INTERFACE	0x04	; bDescriptorType for an Interface Descriptor.
#define USB_DESCRIPTOR_ENDPOINT		0x05	; bDescriptorType for an Endpoint Descriptor.
#define USB_DESCRIPTOR_DEVICE_QUALIFIER	0x06	; bDescriptorType for a Device Qualifier.
#define USB_DESCRIPTOR_OTHER_SPEED	0x07	; bDescriptorType for a Other Speed Configuration.
#define USB_DESCRIPTOR_INTERFACE_POWER	0x08	; bDescriptorType for Interface Power.
#define USB_DESCRIPTOR_OTG		0x09	; bDescriptorType for an OTG Descriptor.
