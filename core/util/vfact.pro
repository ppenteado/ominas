;=============================================================================
;+
; NAME:
;       vfact
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
;       result = vfact(x)
;
;
; ARGUMENTS:
;  INPUT:
;           x:  Float or double vector
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
function vfact, x

 max = max(x)
 M = make_array(max,val=1)
 MM = make_array(n_elements(x),val=1)
 array = fix(((dindgen(max)+1)#MM)*((x/max)##M))
 w=where(array EQ 0)
 if(w[0] NE -1) then array[w] = 1

 return, exp(total(alog(array),1))
end
;===========================================================================
