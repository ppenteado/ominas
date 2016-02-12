;=============================================================================
;+
; NAME:
;	pgs_name
;
;
; PURPOSE:
;	Returns the names of all given points structures.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	n = pgs_name(pp)
;
;
; ARGUMENTS:
;  INPUT: 
;	pp:	Array of points structures
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
;	Names of all points structures.
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
function pgs_name, pp
nv_message, /con, name='pgs_name', 'This routine is obsolete.'
 nv_notify, pp, type = 1
 return, pp.name
end
;===========================================================================
