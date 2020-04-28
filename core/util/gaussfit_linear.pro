;==============================================================================
; gaussfit_linear
;
;  Fits the function y(x) = A0 exp(-(x-A1)^2/A2^2) using a linear least-square
;  fit in log space.
;
;  returns [A0, A1, A2]
;
; All data points must be positive.
;
; **** This routine does not work correctly because the weights are incorrect.
;
;==============================================================================
function gaussfit_linear, x, _y

 y = alog(_y)

 weights = exp(_y)
 coeff = polyfitw(x, y, weights, 2)

 cc = [exp(coeff[0] - 0.25d*coeff[1]^2/coeff[2]), $
      -coeff[1]/(2d*coeff[2]), $
       sqrt(-1d/coeff[2])]

 return, cc
end
;==============================================================================
