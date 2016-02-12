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
;	cam_get_poly_matrices, cx, XX, YY, PP, QQ
;
;
; ARGUMENTS:
;  INPUT: 
;	cx:	Array (nt) of and subclass of CAMERA.
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
;	
;-
;===========================================================================
pro cam_get_poly_matrices, cxp, XX, YY, PP, QQ
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 ;---------------------------------------------------------
 ; distortion matrices and inverses are in fn_data
 ;---------------------------------------------------------
 XX = *(*(cd.fn_data_p))[0] 
 YY = *(*(cd.fn_data_p))[1]
 PP = *(*(cd.fn_data_p))[2] 
 QQ = *(*(cd.fn_data_p))[3]

end
;===========================================================================



