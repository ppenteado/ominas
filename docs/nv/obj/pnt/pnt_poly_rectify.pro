;=============================================================================
;+
; NAME:
;	pnt_poly_rectify
;
;
; PURPOSE:
;	Rearrangs polygon vertices to make them contiguous.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	new_ptd = pnt_cull(ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	ptd:	Array of POINT object.
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
;	Array of POINT object, or 0 if all were empty.
;
;
;
; MODIFICATION HISTORY:
;  Spitale, 12/2015; 	Adapted from pgs_poly_rectify
;	
;-
;=============================================================================
pro pnt_poly_rectify, ptd

 p = pnt_points(ptd)
 v = pnt_vectors(ptd, /noevent)
 flags = pnt_flags(ptd, /noevent)
; data...

 pp = poly_rectify(p, sub=ii)
 vv = 0
 if(keyword_set(v)) then vv = v[ii,*]
 ff = flags[ii]

 pnt_set_points, ptd, pp, /noevent
 pnt_set_vectors, ptd, vv, /noevent
 pnt_set_flags, ptd, ff

end
;===========================================================================
