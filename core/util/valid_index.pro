;=============================================================================
;+
; NAME:
;       valid_index
;
;
; PURPOSE:
;       Determines if an index into an array is valid
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = valid_index(array, index)
;
;
; ARGUMENTS:
;  INPUT:
;       array:  An array
;
;       index:  An index into that array
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       A boolean value whether the index is valid
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
function valid_index, array, index
 return, (index GE 0) AND (n_elements(array) GT index)
end
;===========================================================================
