;==============================================================================
;+
; NAME:
;	cam_clone_descriptor
;
;
; PURPOSE:
;       Allocates new camera descriptors as copies of the given
;       (existing) camera descriptors.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	new_cd = cam_clone_descriptor(cd)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	 Array (nt) of CAMERA descriptors.
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
;       Newly created camera descriptors with all fields identical to
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
function cam_clone_descriptor, cdp
nv_message, /con, name='cam_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'
@nv_lib.include
 nv_notify, cdp, type = 1

 cd = nv_dereference(cdp)

 new_cd = cd
 new_cd.fn_data_p = ptr_copy_recurse(cd.fn_data_p)
 new_cd.bd = bod_clone_descriptor(cd.bd)

 new_cdp = ptrarr(n_elements(cd))
 nv_rereference, new_cdp, new_cd

 return, new_cdp
end
;==============================================================================
