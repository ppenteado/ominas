;=============================================================================
;+
; NAME:
;	nv_compress
;
;
; PURPOSE:
;	Returns the compression function suffix associated with a data 
;	descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	suffix = nv_compress(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
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
; RETURN: 
;	String giving the compression suffix.  The full name
;	of the compression function is nv_compress_data_<suffix>.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function nv_compress, ddp, noevent=noevent
@nv.include
 nv_notify, ddp, type = 1, noevent=noevent
 dd = nv_dereference(ddp)
 return, dd.compress
end
;===========================================================================



