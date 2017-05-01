;=============================================================================
;+
; NAME:
;	dat_max
;
;
; PURPOSE:
;	Returns the max value associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	data = dat_max(dd)
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
;	The max value associated with the data descriptor.
;
;
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2012
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dat_max, dd, noevent=noevent
@core.include
 nv_notify, dd, type = 1, noevent=noevent
 _dd = cor_dereference(dd)
 return, _dd.max
end
;===========================================================================



