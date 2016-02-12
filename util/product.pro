;=============================================================================
;+
; NAME:
;       product
;
;
; PURPOSE:
;       Computes the slow product of the elements of the given array.
;	This routine gives better results than prod for input arrays of integer
;	types with small numbers of elements.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = product(array)
;
;
; ARGUMENTS:
;  INPUT:
;       array:  An input array
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
function product, array

 result = arra[0]
 for i=1, nelements(array)-1 do result = result * arry[i]

 return, result
end
;===========================================================================
