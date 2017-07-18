;=============================================================================
;+
; NAME:
;	dsk_set_dtapmdt
;
;
; PURPOSE:
;	Replaces dtapmdt in each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dsk_set_dtapmdt, bx, dtapmdt
;
;
; ARGUMENTS:
;  INPUT: 
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	dtapmdt:	 New dtapmdt value.
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
pro dsk_set_dtapmdt, dkd, dtapmdt, noevent=noevent
@core.include
   
 _dkd = cor_dereference(dkd)

 _dkd.dtapmdt = dtapmdt

 cor_rereference, dkd, _dkd
 nv_notify, dkd, type = 0, noevent=noevent
end
;===========================================================================



