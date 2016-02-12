;=============================================================================
;+
; NAME:
;	cam_set_fn_psf
;
;
; PURPOSE:
;	Sets the user-defined PSF function for the given camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_set_fn_psf, cd, fn
;
;
; ARGUMENTS:
;  INPUT: 
;	cd:	 Camera descriptor.
;
;	fn:	 Name of user-defined PSF function.
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
;=============================================================================
pro cam_set_fn_psf, cxp, psf
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 cd.fn_psf=psf

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0
end
;===========================================================================


