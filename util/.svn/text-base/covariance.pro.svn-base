;=============================================================================
;+
; NAME:
;	covariance
;
;
; PURPOSE:
;	Computes a covariance matrix for the problem specified by the input
;	matrix.
;
;
; CATEGORY:
;	UTIL/ICV
;
;
; CALLING SEQUENCE:
;	result = covariance(M)
;
;
; ARGUMENTS:
;  INPUT:
;	M:	Array (3,3,n) of coefficient matrices as computed by 
;		icv_coeff or ipt_coeff, as input to mbfit.  Coefficients from
;		the two sources may be mixed.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT:
;	status:	0 is successful, -1 otherwise.
;
;
; RETURN:
;	Covariance matrix.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2002
;	
;-
;=============================================================================
function covariance, M, status=status

 MM = M

 ;-------------------------------------------
 ; sum coefficients from all objects
 ;-------------------------------------------
 s = size(M)
 if(s[0] EQ 3) then MM = total(M,3)

 ;-------------------------------------------
 ; compute covariance
 ;-------------------------------------------
 return, invert(MM, status)
end
;=============================================================================
