;=============================================================================
;+
; NAME:
;       p_inner
;
;
; PURPOSE:
;       Computes inner products between the given arrays of image vectors.
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = p_inner(p1, p2)
;
;
; ARGUMENTS:
;  INPUT:
;	p1:	An array of np x nt image vectors (i.e., 2 x np x nt).
;
;	p2:	Another array of np x nt image vectors.
;
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Array of np x nt inner products.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale	6/2005
;
;-
;=============================================================================
function p_inner, p1, p2
 return, total(p1*p2, 1)
end
;===========================================================================
