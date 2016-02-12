;==============================================================================
;+
; NAME:
;	arr_clone_descriptor
;
;
; PURPOSE:
;       Allocates new array descriptors as copies of the given
;       (existing) array descriptors.
;
;
; CATEGORY:
;	NV/LIB/arr
;
;
; CALLING SEQUENCE:
;	new_arx = arr_clone_descriptor(arx)
;
;
; ARGUMENTS:
;  INPUT:
;	arx:	 Array (nt) of any subclass of ARRAY.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;       Newly created array descriptors with all fields identical to
;       the input descriptors.
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
;==============================================================================
function arr_clone_descriptor, ardp
nv_message, /con, name='arr_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'
@nv_lib.include
 nv_notify, ardp, type = 1
 ard = nv_dereference(ardp)

 new_ard = ard
 new_ard.bd = bod_clone_descriptor(ard.bd)

 new_ardp = ptrarr(n_elements(ard))
 nv_rereference, new_ardp, new_ard

 return, new_ardp
end
;==============================================================================
