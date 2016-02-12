;=============================================================================
;+
; NAME:
;	vecgen
;
;
; PURPOSE:
; 	Generates subscripts for an array of nn n x m matrices such that
; 	subscripting the array of matrices will produce an array of column
; 	vectors with each vector being a column of one of the matrices.
;
;
;
; CATEGORY:
;	UTIL/GEN
;
;
; CALLING SEQUENCE:
;	sub = vecgen(n, m, nn)
;
;
; ARGUMENTS:
;  INPUT:
;	n:	 Number of matrix columns.
;
;	m: 	 Number of matrix rows.
;
;	nn:	 Number of matrices.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (n+m x nn) of subscripts.
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
function vecgen, n, m, nn
 if(nn EQ 1) then return, lindgen(n,m)
 return, reform(transpose(lindgen(n,m,nn), [0,2,1]),n*nn,m)
end
;===========================================================================
