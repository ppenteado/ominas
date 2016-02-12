;=============================================================================
;+
; NAME:
;	cam_fn_psf
;
;
; PURPOSE:
;	Returns the user-defined psf function for the given camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	fn = cam_fn_psf(cd)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	cd:	 Camera descriptor.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;
;  OUTPUT: NONE
;
;
; RETURN:
;	PSF function associated with each given camera descriptor.
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
function cam_fn_psf, cxp
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 nv_notify, cdp, type = 1
 cd = nv_dereference(cdp)
 return, cd.fn_psf
end
;===========================================================================



