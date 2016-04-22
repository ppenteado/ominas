;=============================================================================
;+
; NAME:
;	nv_type
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
;	type = nv_type(dd)
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
;	Then nv_read would include that argument in its call to input_fn and
;	it should work.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function nv_type, ddp, noevent=noevent
@nv.include
 nv_notify, ddp, type = 1, noevent=noevent
 dd = nv_dereference(ddp)

 return, dd.type
end
;===========================================================================



