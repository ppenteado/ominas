;=============================================================================
;+
; NAME:
;	dsk_set_tapm
;
;
; PURPOSE:
;	Replaces tapm in each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dsk_set_tapm, bx, tapm
;
;
; ARGUMENTS:
;  INPUT: 
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	tapm:	 New tapm value.
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
; 	Written by:	Spitale, 6/2016
;	
;-
;=============================================================================
pro dsk_set_tapm, dkd, tapm, noevent=noevent
@core.include
 
 _dkd = cor_dereference(dkd)

 _dkd.tapm = tapm

 cor_rereference, dkd, _dkd
 nv_notify, dkd, type = 0, noevent=noevent
end
;===========================================================================



