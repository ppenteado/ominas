;===========================================================================
;+
; NAME:
;	cam_set_fn_focal_to_image
;
;
; PURPOSE:
;       Sets the user-defined focal --> image transformation function
;       for the given camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_set_fn_focal_to_image, cd, fn
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	 Array (nt) of CAMERA descriptors.
;
;	fn:	 Array (nt) of user-defined focal --> image functions.
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
; RETURN: NONE
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
;===========================================================================
pro cam_set_fn_focal_to_image, cxp, fn_focal_to_image
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 cd.fn_focal_to_image=fn_focal_to_image

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0
end
;===========================================================================



