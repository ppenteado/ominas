;=============================================================================
;+
; NAME:
;	dsk_set_sma
;
;
; PURPOSE:
;	Replaces the sma in each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dsk_set_sma, bx, sma
;
;
; ARGUMENTS:
;  INPUT: 
;	dkx:	 Array (nt) of any subclass of DISK.
;
;	sma:	 New sma value.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
pro dsk_set_sma, dkxp, sma
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 dkd = nv_dereference(dkdp)

; dkd.sma[*,0,*] = sma[*,0,*]
; dkd.sma[*,1,*] = sma[*,1,*]

dkd.sma = sma

 nv_rereference, dkdp, dkd
 nv_notify, dkdp, type = 0
end
;===========================================================================



