;===========================================================================
;+
; NAME:
;	cam_fn_focal_to_image
;
;
; PURPOSE:
;       Returns the name of the user-defined focal --> image
;       transformation function for each given camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	fn = cam_fn_focal_to_image(cd)
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
;       Focal --> image transformation function associated with each
;       given camera descriptor.
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
function cam_fn_focal_to_image, cxp, noevent=noevent
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 nv_notify, cdp, type = 1, noevent=noevent
 cd = nv_dereference(cdp)
 return, cd.fn_focal_to_image
end
;===========================================================================



