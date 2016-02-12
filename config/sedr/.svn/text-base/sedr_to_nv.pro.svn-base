;=============================================================================
;+
; NAME:
;	sedr_to_nv
;
;
; PURPOSE:
;	Converts a C matrix to NV definition.
;
;
; CATEGORY:
;	UTIL/SEDR
;
;
; CALLING SEQUENCE:
;	result = sedr_to_nv(matrix)
;
;
; ARGUMENTS:
;  INPUT:
;
;	matrix:		A C matrix from sedr_buildcm()
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; PROCEDURE:
;	The C-matrix defines the optic axis as the Z or 3rd axis. However, nv
;	defines the optic axis as the Y (b1) or 2nd axis for the C-matrix
;	and the pole also as the 2nd axis.  This procedure switches the
;	2nd and third columns in a matrix given to it so that it follows
;	the nv definition.
;
;
; RESTRICTIONS:
;	NONE.
;
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Haemmerle, 1/1999
;	
;-
;=============================================================================
function sedr_to_nv, matrix

   nv_matrix = matrix
   nv_matrix[1,*] = matrix[2,*]
   nv_matrix[2,*] = matrix[1,*]

;   nv_matrix = dblarr(3,3)
;   nv_matrix[0,*] = matrix[*,0]
;   nv_matrix[1,*] = matrix[*,2]
;   nv_matrix[2,*] = -matrix[*,1]

 return, nv_matrix
end
;=============================================================================
