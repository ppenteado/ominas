;===========================================================================
;+
; NAME:
;	glb_hide_points_limb
;
;
; PURPOSE:
;	Hides points lying on the surface of a GLOBE object that are 
;	obscured by the limb with respect to a given viewpoint.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	sub = glb_hide_points_limb(gbx, r, p)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	Array (nt) of any subclass of GLOBE descriptors.
;
;	r:	Columns vector givnng the BODY-frame position of the viewer.
;
;	p:	Array (nv) of BODY-frame vectors giving the points to hide.
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
;	Subscripts of the points in p that are hidden by the object.  
;	Note that this routine is only valid for points that lie on
;	the surface of the globe.  This routine is faster than
;	glb_hide_points.
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
function glb_hide_points_limb, gbxp, r, points
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')

 nt = n_elements(gbdp)
 nv = (size(points))[1]

 x = points - r[gen3y(nv,3,nt)]
 n = glb_get_surface_normal_body(gbdp, points)

 sub = where(v_inner(n,x) GT 0)

 return, sub
end
;===========================================================================
