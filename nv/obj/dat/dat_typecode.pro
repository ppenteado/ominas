;=============================================================================
;+
; NAME:
;	dat_typecode
;
;
; PURPOSE:
;	Returns the type code associated with a data descriptor.  
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	typecode = dat_typecode(dd)
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
;	Integer giving the typecode.
;
;
; STATUS: Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dat_typecode, dd, noevent=noevent
@core.include
 nv_notify, dd, type = 1, noevent=noevent
 _dd = cor_dereference(dd)

 return, (*_dd.dd0p).typecode
end
;===========================================================================



