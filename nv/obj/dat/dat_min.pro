;=============================================================================
;+
; NAME:
;	dat_min
;
;
; PURPOSE:
;	Returns the min value associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	data = dat_min(dd)
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
;	The min value associated with the data descriptor.
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
function dat_min, dd, noevent=noevent
@core.include
 nv_notify, dd, type = 1, noevent=noevent
 _dd = cor_dereference(dd)
 return, _dd.min
end
;===========================================================================



