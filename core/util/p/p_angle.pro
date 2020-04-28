;=============================================================================
;+
; NAME:
;       p_angle
;
;
; PURPOSE:
;       Computes the angles between the given arrays of image vectors.
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = p_angle(p1, p2)
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
;       Array of np x nt angles in radians.
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
function p_angle, p1, p2

 dot = -1d > p_inner(p_unit(p1), p_unit(p2)) < 1d

 return, acos(dot)
end
;===========================================================================
