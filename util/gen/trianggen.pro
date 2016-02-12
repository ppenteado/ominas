;=============================================================================
;+
; NAME:
;	trianggen
;
;
; PURPOSE:
;	Constructs 1d subscripts of triangular elements of an nxn matrix.
;
;
; CATEGORY:
;	UTIL/GEN
;
;
; CALLING SEQUENCE:
;	sub = trianggen(n)
;
;
; ARGUMENTS:
;  INPUT:
;	n:	 Degree of matrix, i.e., number of rows / columns.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	lower:	Generates indices for the lower triangle.
;
;	upper:	Generates indices for the upper triangle.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (n x n) of subscripts.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function trianggen, n, lower=lower, upper=upper

 x = lindgen(n)#make_array(n,val=1)
 y = transpose(x)
 if(keyword_set(lower)) then w = where(x GE y) $
 else w = where(y GE x)

 return, w
end
;===========================================================================
