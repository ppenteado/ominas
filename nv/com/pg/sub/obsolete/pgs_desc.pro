;=============================================================================
;+
; NAME:
;	pgs_desc
;
;
; PURPOSE:
;	Returns the descriptions of all given points structures.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	n = pgs_desc(pp)
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
;	Descriptions of all points structures.
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
function pgs_desc, pp
nv_message, /con, name='pgs_desc', 'This routine is obsolete.'
 nv_notify, pp, type = 1
 return, pp.desc
end
;===========================================================================
