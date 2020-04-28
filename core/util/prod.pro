;=============================================================================
;+
; NAME:
;       prod
;
;
; PURPOSE:
;       Computes the product of the elements of the given array.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = prod(array, dim)
;
;
; ARGUMENTS:
;  INPUT:
;       array:  An input array
;
;         dim:  The dimension over which to multiply.
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;       NONE
;
;
; RETURN:
;       The product of all the elements in the array.
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
function prod, array, dim
; return, exp(total(alog(array), dim))
 
 if(NOT keyword_set(dim)) then dim = 1

 zeroes = array EQ 0
 z = where(total(zeroes, dim) GT 0)

 w = where(array EQ 0)
 if(w[0] NE -1) then array[w] = 1

 signs = 1 - 2*(total(array LT 0, dim) mod 2)
 raw_product = exp(total(alog(abs(array)), dim))

 if(z[0] NE -1) then raw_product[z] = 0

 return, signs * raw_product
end
;===========================================================================
