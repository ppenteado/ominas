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
;	dkd:	 Array (nt) of any subclass of DISK.
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro dsk_set_sma, dkd, sma, noevent=noevent
@core.include
 
 _dkd = cor_dereference(dkd)

; dkd.sma[*,0,*] = sma[*,0,*]
; _dkd.sma[*,1,*] = sma[*,1,*]

_dkd.sma = sma

 cor_rereference, dkd, _dkd
 nv_notify, dkd, type = 0, noevent=noevent
end
;===========================================================================



