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
;	sub = glb_hide_points(gbd, r, p)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	Array (nt) of any subclass of GLOBE descriptors.
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
;  INPUT: 
;	rm:	If set, points are flagged for being in front of or behind
;		the globe, rather then just behind it.
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
; 	Adapted by:	Spitale, 5/2016
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
; gbd -- nt
; v -- 1 x 3 x nt or nv x 3 x nt
; points, nv x 3 x nt
;
;===========================================================================
function glb_hide_points, gbd, v, points, rm=rm
@core.include
 

 nt = n_elements(gbd)
 nv = (size(points))[1]

 vv = v[linegen3x(nv,3,nt)] 
 r = points - vv 

 discriminant = glb_intersect_discriminant(gbd, vv, r)

 if(keyword_set(rm)) then sub = where(discriminant GE 0d) $
 else sub = where((discriminant GE 0d) AND (v_mag(r) GE v_mag(vv)))

 return, sub
end
;===========================================================================
