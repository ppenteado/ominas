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
;	n = glb_sub_point(gbx, r)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	Array (nt) of any subclass of GLOBE descriptors.
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
;	
;-
;===========================================================================
function glb_sub_point, gbxp, v, noevent=noevent
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 nv_notify, gbdp, type = 1, noevent=noevent
 gbd = nv_dereference(gbdp)

 nv = (size(v))[1]
 nt = n_elements(gbd)

; a = gbd.radii[0]
; b = gbd.radii[1]
; c = gbd.radii[2]

 surf_pts = glb_body_to_globe(gbdp, v)
; surf_pts[*,2,*] = glb_get_radius(gbdp, surf_pts[*,0,*], surf_pts[*,1,*])
 surf_pts[*,2,*] = 0d

 result = glb_globe_to_body(gbdp, surf_pts)

 return, result
end
;==============================================================================
