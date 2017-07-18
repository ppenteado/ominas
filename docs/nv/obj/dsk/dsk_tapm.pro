;=============================================================================
;+
; NAME:
;	dsk_tapm
;
;
; PURPOSE:
;	Returns tapm for each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	tapm = dsk_tapm(dkd)
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
;	tapm value associated with each given disk descriptor.
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
function dsk_tapm, dkd, noevent=noevent
@core.include
 
 nv_notify, dkd, type = 1, noevent=noevent
 _dkd = cor_dereference(dkd)
 return, _dkd.tapm
end
;===========================================================================



