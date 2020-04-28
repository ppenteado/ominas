;=============================================================================
;+
; NAME:
;       p_cross
;
;
; PURPOSE:
;       Computes the cross products between the given arrays image vectors.
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = p_cross(p1, p2)
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
;       Array of np x nt out-of-image components of the cross products.  
;	The in-plane components will always be zero.
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
function p_cross, p1, p2

 z = p1[0,*,*]*p2[1,*,*] - p1[1,*,*]*p2[0,*,*]

 dim = size(p1, /dim)
 ndim = n_elements(dim)

 if(ndim EQ 1) then return, z
 if(ndim EQ 2) then return, reform(z, dim[1], /over)
 return, reform(z, dim[1], dim[2], /over)
end
;===========================================================================
