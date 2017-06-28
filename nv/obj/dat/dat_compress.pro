;=============================================================================
;+
; NAME:
;	dat_compress
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
;	suffix = dat_compress(dd)
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
;	of the compression function is dat_compress_data_<suffix>.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dat_compress, dd, noevent=noevent
@core.include
 nv_notify, dd, type = 1, noevent=noevent
 _dd = cor_dereference(dd)
 return, (*_dd.dd0p).compress
end
;===========================================================================



