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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function cam_fn_psf, cd, noevent=noevent
@core.include

 nv_notify, cd, type = 1, noevent=noevent
 _cd = cor_dereference(cd)
 return, _cd.fn_psf
end
;===========================================================================



