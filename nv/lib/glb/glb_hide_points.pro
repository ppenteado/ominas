;===========================================================================
;+
; NAME:
;	glb_hide_points
;
;
; PURPOSE:
;	Hides points that are obscured by a GLOBE with respect to a given 
;	viewpoint.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	sub = glb_hide_points(gbx, r, p)
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
;===========================================================================
; glb_hide_points.pro
;
; Inputs are in body coordinates.
;
; Returns subscripts of points hidden from the viewer at v by the globe.
;
; gbxp -- nt
; v -- 1 x 3 x nt or nv x 3 x nt
; points, nv x 3 x nt
;
;===========================================================================
function glb_hide_points, gbxp, v, points
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')

 nt = n_elements(gbdp)
 nv = (size(points))[1]

 vv = v[linegen3x(nv,3,nt)] 
 r = points - vv 

 discriminant = glb_intersect_discriminant(gbdp, vv, r)
 sub = where((discriminant GE 0d) AND (v_mag(r) GE v_mag(vv)))

 return, sub
end
;===========================================================================
