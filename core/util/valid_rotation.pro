;=============================================================================
;	NOTE:	remove the second '+' on the next line for this header
;		to be recognized by extract_doc.
;++
; NAME:
;	xx
;
;
; PURPOSE:
;	xx
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = xx(xx, xx)
;	xx, xx, xx
;
;
; ARGUMENTS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; KEYWORDS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; ENVIRONMENT VARIABLES:
;	xx:	xx
;
;	xx:	xx
;
;
; RETURN:
;	xx
;
;
; COMMON BLOCKS:
;	xx:	xx
;
;	xx:	xx
;
;
; SIDE EFFECTS:
;	xx
;
;
; RESTRICTIONS:
;	xx
;
;
; PROCEDURE:
;	xx
;
;
; EXAMPLE:
;	xx
;
;
; STATUS:
;	xx
;
;
; SEE ALSO:
;	xx, xx, xx
;
;
; MODIFICATION HISTORY:
; 	Written by:	xx, xx/xx/xxxx
;	
;-
;=============================================================================
function valid_rotation, M, epsilon=epsilon

 if(NOT keyword__set(epsilon)) then epsilon = 1d-8

 mindet = 1d - epsilon
 maxdet = 1d + epsilon

 det = determ(M)

 if(NOT finite(det)) then return, 0
 if((abs(det) LT mindet) OR (abs(det) GT maxdet)) then return, 0

 return, 1
end
;=============================================================================
