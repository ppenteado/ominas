;=============================================================================
;+
; NAME:
;	ps_test
;
;
; PURPOSE:
;	Assesses the validity of a single points structure.  This function
;	differs from ps_valid in that it simply returns true or false, rather
;	than a list of validity flags. 
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	test = ps_test(ps)
;
;
; ARGUMENTS:
;  INPUT: 
;	ps:	Array of points structures.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	generic:	If set, a generic input is test to determine whether
;			it is a points structure.  Its validity is not tested.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	1 if the given points structure is valid and contains points, 0 otherwise.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ps_test
;
;
; MODIFICATION HISTORY:
;  Spitale, 12/2015; 	Adapted from pgs_test
;	
;-
;=============================================================================
function ps_test, psp, generic=generic
 if(NOT keyword_set(psp)) then return, 0
 if(size(psp, /type) NE 10) then return, 0

 nv_notify, psp, type = 1
 ps = nv_dereference(psp)

 if(keyword_set(generic)) then return, tag_exists(ps[0], 'POINTS_P')

;;; if(n_elements(ps) GT 1) then return, 1 

 if(NOT ptr_valid(ps[0].points_p)) then return, 0

 return, 1
end
;===========================================================================
