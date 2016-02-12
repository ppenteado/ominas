;==============================================================================
;+
; NAME:
;	bod_clone_descriptor
;
;
; PURPOSE:
;       Allocates new body descriptors as copies of the given
;       (existing) body descriptors.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	new_bx = bod_clone_descriptor(bx)
;
;
; ARGUMENTS:
;  INPUT:
;	bx:	 Array (nt) of any subclass of BODY.
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
;       Newly created body descriptors with all fields identical to
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
function bod_clone_descriptor, bdp
nv_message, /con, name='bod_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'
@nv_lib.include
 nv_notify, bdp, type = 1
 bd = nv_dereference(bdp)

 new_bd = bd
 new_bd.crd = cor_clone_descriptor(bd.crd)

 new_bdp = ptrarr(n_elements(bd))
 nv_rereference, new_bdp, new_bd

 return, new_bdp
end
;==============================================================================
