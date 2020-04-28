;=============================================================================
;+
; NAME:
;       complement
;
;
; PURPOSE:
;       Determines the complement of an array of subscripts.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = complement(array, sub)
;
;
; ARGUMENTS:
;  INPUT:
;       array:  An array, to find the range of subscripts.
;
;         sub:  An array of subscripts.
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       An array of subscripts giving the complement of the input subscripts.
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
function complement, array, _sub

 n = n_elements(array)
 if(NOT defined(_sub)) then _sub = -1

 w = where(_sub NE -1)
 if(w[0] EQ -1)then return, lindgen(n)
 sub = _sub[w]

 xx = bytarr(n)
 xx[sub] = 1

 return, where(xx EQ 0)
end
;=============================================================================
