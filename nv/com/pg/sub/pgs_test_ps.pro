;=============================================================================
;+
; NAME:
;	pgs_test_ps
;
;
; PURPOSE:
;	Determines whether the argument is a points structure.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	status = pgs_test_ps(x)
;
;
; ARGUMENTS:
;  INPUT:
;	x:		Point structure.
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
;
; RETURN: 
;	True if x is a points structure, false otherwise. 
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1997
;	
;-
;=============================================================================
function pgs_test_ps, ps
nv_message, /con, name='pgs_test_ps', 'This routine is obsolete.'
 return, tag_exists(ps, 'POINTS_P')
end
;====================================================================================
