;=============================================================================
;+
; NAME:
;	dat_update
;
;
; PURPOSE:
;	Returns the update flag associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	update = dat_update(dd)
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
;	Data descriptor update flag.
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
function dat_update, dd, noevent=noevent
@core.include
 nv_notify, dd, type = 1, noevent=noevent
 _dd = cor_dereference(dd)
 return, (*_dd.dd0p).update
end
;===========================================================================



