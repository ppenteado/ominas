;==============================================================================
;+
; NAME:
;	map_clone_descriptor
;
;
; PURPOSE:
;       Allocates new map descriptors as copies of the given
;       (existing) map descriptors.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	new_md = map_clone_descriptor(md)
;
;
; ARGUMENTS:
;  INPUT:
;	md:	 Array (nt) of MAP descriptors.
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
;       Newly created map descriptors with all fields identical to
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
function map_clone_descriptor, mdp
nv_message, /con, name='map_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'
@nv_lib.include
 nv_notify, mdp, type = 1
 md = nv_dereference(mdp)

 new_md = md
 new_md.fn_data_p = ptr_copy_recurse(md.fn_data_p)
 new_md.crd = cor_clone_descriptor(md.crd)

 new_mdp = ptrarr(n_elements(md))
 nv_rereference, new_mdp, new_md

 return, new_mdp
end
;==============================================================================
