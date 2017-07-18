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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro cam_set_fn_psf, cd, psf, noevent=noevent
@core.include

 _cd = cor_dereference(cd)

 _cd.fn_psf=psf

 cor_rereference, cd, _cd
 nv_notify, cd, type = 0, noevent=noevent
end
;===========================================================================


