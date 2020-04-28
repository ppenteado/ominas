;=============================================================================
;+
; NAME:
;       p_mag
;
;
; PURPOSE:
;       Computes the magnitudes of the given array of image vectors.
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = p_mag(p)
;
;
; ARGUMENTS:
;  INPUT:
;	p:	An array of np x nt image vectors (i.e., 2 x np x nt).
;
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Array of np x nt magnitudes.
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
function p_mag, p
 return, sqrt(total(p*p, 1))
end
;===========================================================================
