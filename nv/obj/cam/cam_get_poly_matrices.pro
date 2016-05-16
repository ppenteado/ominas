;===========================================================================
;+
; NAME:
;	cam_get_poly_matrices
;
;
; PURPOSE:
;       Obtains the camera function data for the polynomial distortion model.
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_get_poly_matrices, cd, XX, YY, PP, QQ
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
pro cam_get_poly_matrices, cd, XX, YY, PP, QQ
@core.include

 _cd = cor_dereference(cd)

 ;---------------------------------------------------------
 ; distortion matrices and inverses are in fn_data
 ;---------------------------------------------------------
 XX = *(*(_cd.fn_data_p))[0] 
 YY = *(*(_cd.fn_data_p))[1]
 PP = *(*(_cd.fn_data_p))[2] 
 QQ = *(*(_cd.fn_data_p))[3]

end
;===========================================================================



