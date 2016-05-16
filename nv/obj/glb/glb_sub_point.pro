;===========================================================================
;+
; NAME:
;	glb_sub_point
;
;
; PURPOSE:
;	Computes the planetocentric sub-point in body coordinates.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	n = glb_sub_point(gbd, r)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	Array (nt) of any subclass of GLOBE descriptors.
;
;	r:	Array (nv,3,nt) of points in the BODY frame.
;
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
;	Array (nv,3,nt) points in the BODY frame that lie on the surface
;	of each globe, directly 'beneath' r, i.e., such that each 
;	planetocentric surface normal points at each r.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
function glb_sub_point, gbd, v, noevent=noevent
@core.include
 
 nv_notify, gbd, type = 1, noevent=noevent
 _gbd = cor_dereference(gbd)

 nv = (size(v))[1]
 nt = n_elements(_gbd)

; a = _gbd.radii[0]
; b = _gbd.radii[1]
; c = _gbd.radii[2]

 surf_pts = glb_body_to_globe(gbd, v)
; surf_pts[*,2,*] = glb_get_radius(gbd, surf_pts[*,0,*], surf_pts[*,1,*])
 surf_pts[*,2,*] = 0d

 result = glb_globe_to_body(gbd, surf_pts)

 return, result
end
;==============================================================================
