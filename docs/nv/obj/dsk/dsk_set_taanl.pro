;=============================================================================
;+
; NAME:
;	dsk_set_taanl
;
;
; PURPOSE:
;	Replaces taanl in each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dsk_set_taanl, bx, taanl
;
;
; ARGUMENTS:
;  INPUT: 
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	taanl:	 New taanl value.
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
pro dsk_set_taanl, dkd, taanl, noevent=noevent
@core.include
 
 _dkd = cor_dereference(dkd)

 _dkd.taanl = taanl

 cor_rereference, dkd, _dkd
 nv_notify, dkd, type = 0, noevent=noevent
end
;===========================================================================



