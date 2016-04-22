;===========================================================================
;+
; NAME:
;	cam_set_fn_image_to_focal
;
;
; PURPOSE:
;       Sets the user-defined image --> focal transformation function
;       for the given camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_set_fn_image_to_focal, cd, fn
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	 Array (nt) of CAMERA descriptors.
;
;	fn:	 Array (nt) of user-defined image --> focal functions.
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
pro cam_set_fn_image_to_focal, cxp, fn_image_to_focal, noevent=noevent
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 cd.fn_image_to_focal=fn_image_to_focal

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0, noevent=noevent
end
;===========================================================================



