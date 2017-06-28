;=============================================================================
;+
; NAME:
;	dat_filetype
;
;
; PURPOSE:
;	Returns the filetype associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	filetype = dat_filetype(dd)
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
;	String giving the filetype.
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
function dat_filetype, dd, noevent=noevent
@core.include
 nv_notify, dd, type = 1, noevent=noevent
 _dd = cor_dereference(dd)

 return, (*_dd.dd0p).filetype
end
;===========================================================================



