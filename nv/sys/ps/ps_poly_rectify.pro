;=============================================================================
;+
; NAME:
;	ps_poly_rectify
;
;
; PURPOSE:
;	Cleans out an array of points structures by removing invisible points
;	and empty points structures.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	new_ps = ps_cull(ps)
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
;	Array points structures, or 0 if all were empty.
;
;
;
; MODIFICATION HISTORY:
;  Spitale, 12/2015; 	Adapted from pgs_poly_rectify
;	
;-
;=============================================================================
pro ps_poly_rectify, ps

 p = ps_points(ps)
 v = ps_vectors(ps, /noevent)
 flags = ps_flags(ps, /noevent)

 pp = poly_rectify(p, sub=ii)
 vv = 0
 if(keyword_set(v)) then vv = v[ii,*]
 ff = flags[ii]

 ps_set_points, ps, pp, /noevent
 ps_set_vectors, ps, vv, /noevent
 ps_set_flags, ps, ff

end
;===========================================================================
