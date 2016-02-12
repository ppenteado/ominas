;=============================================================================
;+
; NAME:
;	ps_valid
;
;
; PURPOSE:
;	Assesses the validity of points structures.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	valid = ps_valid(ps)
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
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array of flags, one for each input PS.  1 indicates that the PS 
;	contains points.
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
;  Spitale, 11/2015; 	Adapted from pgs_valid
;	
;-
;=============================================================================
function ps_valid, _psp
 if(NOT keyword_set(_psp)) then return, 0

 n = n_elements(_psp)

 _w = where(ptr_valid(_psp))
 if(_w[0] EQ -1) then return, bytarr(n)

 psp = _psp[_w]

 nv_notify, psp, type = 1
 ps = nv_dereference(psp)

 nps = n_elements(ps)
 valid = bytarr(nps)

 w = where(ptr_valid(ps.points_p))
 if(w[0] NE -1) then valid[w] = 1

 _valid = bytarr(n)
 _valid[_w] = valid

 return, _valid
end
;===========================================================================

