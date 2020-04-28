;=============================================================================
;+
; NAME:
;       ntrace
;
;
; PURPOSE:
;       Computes the traces of square matrices
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = ntrace(matrix)
;
;
; ARGUMENTS:
;  INPUT:
;       matrix:         Array (n,n,m) of nxn matrices.
;
;  OUTPUT:
;       NONE
;
;
; RETURN:
;       Array (m) giving the traces of the matrices.
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
function ntrace, matrix
 return, total(matrix[diaggen((size(matrix))[1],n_elements(matrix[0,0,*]))],2)
end
;===========================================================================
