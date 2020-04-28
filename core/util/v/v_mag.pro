;=============================================================================
;+
; NAME:
;       v_mag
;
;
; PURPOSE:
;       Computes the magnitudes of the given array of column vectors.
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = v_mag(v)
;
;
; ARGUMENTS:
;  INPUT:
;       v:     An array of nv x nt column vectors (i.e. nv x 3 x nt).
;
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Array of nv x nt magnitudes.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function v_mag, v
 return, sqrt(total(v*v, 2))
end
;===========================================================================
