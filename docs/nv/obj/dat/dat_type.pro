;=============================================================================
;+
; NAME:
;	dat_type
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
;	type = dat_type(dd)
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
;	Integer giving the type.
;
;
; STATUS:
;	This data descriptor functonality is not complete.  A 'type' field
; 	needs to be added to the input functions similar to the 'dim' field.
;	Then dat_read would include that argument in its call to input_fn and
;	it should work.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dat_type, dd, noevent=noevent
@core.include
 nv_notify, dd, type = 1, noevent=noevent
 _dd = cor_dereference(dd)

 return, _dd.type
end
;===========================================================================



