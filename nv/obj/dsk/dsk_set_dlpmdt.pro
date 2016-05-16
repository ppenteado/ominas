;=============================================================================
;+
; NAME:
;	dsk_set_dlpmdt
;
;
; PURPOSE:
;	Replaces dlpmdt in each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dsk_set_dlpmdt, bx, dlpmdt
;
;
; ARGUMENTS:
;  INPUT: 
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	dlpmdt:	 New dlpmdt value.
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
pro dsk_set_dlpmdt, dkd, dlpmdt, noevent=noevent
@core.include
 
 _dkd = cor_dereference(dkd)

 _dkd.dlpmdt = dlpmdt

 cor_rereference, dkd, _dkd
 nv_notify, dkd, type = 0, noevent=noevent
end
;===========================================================================



