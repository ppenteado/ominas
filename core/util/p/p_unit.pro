;=============================================================================
;+
; NAME:
;       p_unit
;
;
; PURPOSE:
;       Converts image vectors to unit image vectors.
;
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = p_unit(p)
;
;
; ARGUMENTS:
;  INPUT:
;	p:	An array of np x nt image vectors (i.e., 2 x np x nt).
;
;  OUTPUT:
;       mag:	Array of np x nt magnitudes.
;
; RETURN:
;       An array of np x nt unit image vectors (i.e., 2 x np x nt).
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
function p_unit, p, mag=pmag

 pmag = sqrt(total(p*p, 1))
 q = p
 q[0,*,*] = p[0,*,*]/pmag
 q[1,*,*] = p[1,*,*]/pmag
 return, q
end
;===========================================================================
