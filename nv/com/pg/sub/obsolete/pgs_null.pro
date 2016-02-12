;=============================================================================
;+
; NAME:
;	pgs_null
;
;
; PURPOSE:
;	Returns a null points structure.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	ps = pgs_null()
;
;
; ARGUMENTS:
;  INPUT: NONE
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
; RETURN: 
;	A null points structure.
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function pgs_null
nv_message, /con, name='pgs_null', 'This routine is obsolete.'

 return, {pg_points_struct}

end
;===========================================================================
