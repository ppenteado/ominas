;=============================================================================
;+
; NAME:
;       v_inner
;
;
; PURPOSE:
;       Computes the inner products between the given arrays of column
;       vectors.
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = v_inner(v1, v2)
;
;
; ARGUMENTS:
;  INPUT:
;       v1:     An array of nv x nt column vectors (i.e. nv x 3 x nt).
;
;       v2:     Another array of nv x nt column vectors.
;
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Array of nv x nt inner products.
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
function v_inner, v1, v2
 return, total(v1*v2, 2)
end
;===========================================================================
