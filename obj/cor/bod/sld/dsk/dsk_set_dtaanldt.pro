;=============================================================================
;+
; NAME:
;	dsk_set_dtaanldt
;
;
; PURPOSE:
;	Replaces dtaanldt in each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dsk_set_dtaanldt, bx, dtaanldt
;
;
; ARGUMENTS:
;  INPUT: 
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	dtaanldt:	 New dtaanldt value.
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
pro dsk_set_dtaanldt, dkd, dtaanldt, noevent=noevent
@core.include
 
 _dkd = cor_dereference(dkd)

 _dkd.dtaanldt = dtaanldt

 cor_rereference, dkd, _dkd
 nv_notify, dkd, type = 0, noevent=noevent
end
;===========================================================================



