;=============================================================================
;+
; NAME:
;	trans_solve
;
;
; PURPOSE:
;	Solves the transcendental equation x = f(x) using iteration.
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
; 	Written by:	Spitale, 5/2002
;	
;-
;=============================================================================
function trans_solve, fn, x0, data, epsilon=epsilon

 if(NOT keyword__set(epsilon)) then epsilon = 1d-9
 n = n_elements(x0)

 xx = x0
 x = xx
 w = lindgen(n)
 
 repeat $
  begin
   x[w] = xx[w]
   xx[w] = call_function(fn, x[w], data[*,w])

   w = where(abs(xx-x) GT epsilon)
  endrep until(w[0] EQ -1)

 return, x
end
;=============================================================================
