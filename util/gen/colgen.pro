;=============================================================================
;+
; NAME:
;	colgen
;
;
; PURPOSE:
;	Generates an array of subscripts to select only the desired column 
;	n-vectors from an array with dimensions nv x n x nt.
;
; CATEGORY:
;	UTIL/GEN
;
;
; CALLING SEQUENCE:
;	sub = colgen(nv, n, nt, w)
;
;
; ARGUMENTS:
;  INPUT:
;	nv, n, nt:	 Dimensions of array from which to select.
;
;	w:	1-d array of nw subscripts selecting from the (nv x nt) 
;		column vectors.
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
;	Array (nw x n) of subscripts.
;
;
; EXAMPLE:
;	Define the (3 x 3 x 4) array x as follows:
;       	0       1       2
;       	0       1       2
;       	0       1       2
;
;       	3       4       5
;       	3       4       5
;       	3       4       5
;
;       	6       7       8
;       	6       7       8
;       	6       7       8
;
;       	9      10      11
;       	9      10      11
;       	9      10      11
;
;	If c = colgen(3,3,4, [0,2,4,7]), then x[c] is the 4 x 3 array:
;       	0       2       4       7
;       	0       2       4       7
;       	0       2       4       7
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
function colgen, nv, n, nt, w

 wv = w mod nv
 wt = fix(w / nv)

 nnv = n*nv
 nw = n_elements(w)

 ww = lonarr(nw,n)

 ww[*,0] = wt * nnv + wv
 for i=1, n-1 do ww[*,i] = ww[*,i-1] + nv
  

 return, ww
end
;=============================================================================
