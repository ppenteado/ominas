;=============================================================================
;+
; NAME:
;	dsk_taanl
;
;
; PURPOSE:
;	Returns taanl for each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	taanl = dsk_taanl(dkd)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	dkd:	 Any subclass of DISK.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;
;  OUTPUT: NONE
;
;
; RETURN:
;	taanl value associated with each given disk descriptor.
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
function dsk_taanl, dkd, noevent=noevent
@core.include
 
 nv_notify, dkd, type = 1, noevent=noevent
 _dkd = cor_dereference(dkd)
 return, _dkd.taanl
end
;===========================================================================



