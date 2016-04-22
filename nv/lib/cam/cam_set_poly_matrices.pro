;===========================================================================
;+
; NAME:
;	cam_set_poly_matrices
;
;
; PURPOSE:
;       Sets up the camera function data for the polynomial distortion model.
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_set_poly_matrices, cx, XX, YY, PP, QQ
;
;
; ARGUMENTS:
;  INPUT: 
;	cx:	Array (nt) of and subclass of CAMERA.
;
;       XX:     Polynominal distortion coefficients in x.
;
;       YY:     Polynominal distortion coefficients in y.
;
;       PP:     Inverse polynominal distortion coefficients in x.
;
;       QQ:     Inverse polynominal distortion coefficients in y.
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
; 	Written by:	Spitale, 1/1998
;	
;-
;===========================================================================
pro cam_set_poly_matrices, cxp, XX, YY, PP, QQ, noevent=noevent
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)


 if(ptr_valid(cd.fn_data_p)) then nv_ptr_free_recurse, cd.fn_data_p

 cd.fn_data_p = nv_ptr_new([nv_ptr_new(XX), nv_ptr_new(YY), nv_ptr_new(PP), nv_ptr_new(QQ)])

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0, noevent=noevent
end
;===========================================================================



