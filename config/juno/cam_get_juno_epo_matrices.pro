;===========================================================================
;+
; NAME:
;	cam_get_juno_epo_matrices
;
;
; PURPOSE:
;       Obtains the camera function data for the JunoCam distortion model.
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_get_juno_epo_matrices, cd, XX, YY, PP, QQ
;
;
; ARGUMENTS:
;  INPUT: 
;	cd:	Array (nt) of and subclass of CAMERA.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT:
;
;       XX:     Polynominal distortion coefficients in x.
;
;       YY:     Polynominal distortion coefficients in y.
;
;       PP:     Inverse polynominal distortion coefficients in x.
;
;       QQ:     Inverse polynominal distortion coefficients in y.
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
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro cam_get_juno_epo_matrices, cd, k1, k2, x0, y0
@core.include

 data = cam_fi_data(cd)

 ;---------------------------------------------------------
 ; distortion matrices and inverses are in fi_data
 ;---------------------------------------------------------
 k1 = data.k1 
 k2 = data.k2
 x0 = data.x0 
 y0 = data.y0

end
;===========================================================================



