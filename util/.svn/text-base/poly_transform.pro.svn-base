;=============================================================================
;+
; NAME:
;       poly_transform
;
;
; PURPOSE:
;       Transforms an array of points given a polynomial transformation
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = poly_transform(Dx, Dy, v)
;
;
; ARGUMENTS:
;  INPUT:
;       Dx:     Polynominal distortion coefficients in x.
;
;       Dy:     Polynominal distortion coefficients in y.
;
;        v:     Array of points to transform.
;
;  OUTPUT:
;       NONE
;
;
; RETURN:
;       Array of transformed points.
;
;
; SEE ALSO:
;       power_matrix, vecgen, mxgen, trace
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale, 6/1998
;
;-
;=============================================================================
function poly_transform, Dx, Dy, v

 order = (size(Dx))[1]
 sv = size(v)
 n = 1
 if (sv[0] GT 1) then n = sv[2]

 ;-----------------------------------------
 ; generate a power matrix for each point
 ;-----------------------------------------
 PP = power_matrix(v[0,*], v[1,*], order)

 ;------------------------------
 ; perform the multiplications
 ;------------------------------
 Mxv = Dx[linegen3z(order,order,n)] * PP
 Myv = Dy[linegen3z(order,order,n)] * PP

 ;------------------------------
 ; add up the matrix products
 ;------------------------------
 p = [total(total(Mxv, 1), 1)]
 q = [total(total(Myv, 1), 1)]


 return, [transpose(p), transpose(q)]
end
;===========================================================================



