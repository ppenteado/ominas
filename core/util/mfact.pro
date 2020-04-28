;=============================================================================
;+
; NAME:
;       mfact
;
;
; PURPOSE:
;       Computes the factorial of each element of x
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = mfact(x)
;
;
; ARGUMENTS:
;  INPUT:
;           x:  Float or double matrix
;
;  OUTPUT:
;       NONE
;
;
; RETURN:
;       Array of factorials for each element of x
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
function mfact, _x

 s = size(_x)
 x = reform(_x, s[1]*s[2])

; max = max(x)
 max = max(x) > 1.
 M = make_array(max,val=1)
 MM = make_array(n_elements(x),val=1)
 array = fix(((dindgen(max)+1)#MM)*((x/max)##M))
 w = where(array EQ 0)
 if(w[0] NE -1) then array[w] = 1

 return, reform(exp(total(alog(array),1)), s[1], s[2], /overwrite)
end
;===========================================================================
