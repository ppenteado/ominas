;=============================================================================
;+
; NAME:
;	cam_psf_attrib
;
;
; PURPOSE:
;	Computes attributes of a point-spread function.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_psf_attrib, cd, <attribute keywords...>
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	 Camera descriptor.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: 
;	fwhm:	Full-width at half maximum of the point-spread function.
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
pro cam_psf_attrib, cd, fwhm=fwhm
@nv_lib.include

 psf = cam_psf(cd)
 if(NOT keyword_set(psf)) then return

 n = n_elements(psf)
 zz = 10.
 psf = cam_psf(cd, (dindgen(n*zz)-0.5*(n*zz))/zz)

 max = max(psf)
 hmax = 0.5d*max
 ww = where(psf GE hmax)
 fwhm = (max(ww) - min(ww))/zz
end
;===========================================================================
