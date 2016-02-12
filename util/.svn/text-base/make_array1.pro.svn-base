;=============================================================================
;+
; NAME:
;       make_array1
;
;
; PURPOSE:
;       Same as IDL function, make_array, but if n=1 it returns a scalar.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = make_array1(n, value=value)
;
;
; ARGUMENTS:
;  INPUT:
;           n:  Number of elements in resultant array.
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;  INPUT:
;       value:  Values to fill array.
;
;  OUTPUT:
;       NONE
;
;
; RETURN:
;       Array (n) filled with value.  If n=1 then a scalar is returned
;       instead of an array.
;
;
; SEE ALSO:
;	make_array
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
function make_array1, n, value=value

 array=make_array(n, value=value)

 if(n EQ 1) then return, array[0]

 return, array
end
;===========================================================================
