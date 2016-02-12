;=============================================================================
;+
; NAME:
;	linegen3x
;
;
; PURPOSE:
;	Constructs a 3d array of subscripts that looks like indgen(ny, nz) in 
;	the y and z directions and is replicated in the x direction.
;
;
; CATEGORY:
;	UTIL/GEN
;
;
; CALLING SEQUENCE:
;	sub = linegen3x(nx, ny, nz)
;
;
; ARGUMENTS:
;  INPUT:
;	nx:	 Number of elements in the x direction.
;
;	ny:	 Number of elements in the y direction.
;
;	nz:	 Number of elements in the z direction.
;
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
; EXAMPLE:
; 	For nx=6, ny=3, nz=2:
;		0  0  0  0  0  0
;		1  1  1  1  1  1
;		2  2  2  2  2  2
;
;		3  3  3  3  3  3
;		4  4  4  4  4  4
;		5  5  5  5  5  5
;
;
; RETURN:
;	Array (nx x ny x nz) of subscripts.
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
function linegen3x, n, m, l
 return, reform(lindgen(n,m,l)/n, n,m,l, /overwrite)
end
;===========================================================================
