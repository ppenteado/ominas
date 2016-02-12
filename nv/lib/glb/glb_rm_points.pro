;===========================================================================
;+
; NAME:
;	glb_rm_points
;
;
; PURPOSE:
;	Hides points that are obscured by, or that obscure a GLOBE with 
;	respect to a given viewpoint.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	sub = glb_rm_points(gbx, r, p)
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
;	Subscripts of the points in p that are hidden by, or hide the 
;	object.
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
function glb_rm_points, gbxp, r, points
 gbdp = class_extract(gbxp, 'GLOBE')

 nt = n_elements(gbdp)
 nv = (size(points))[1]

 rr = r[gen3y(nv,3,nt)]
 discriminant = glb_intersect_discriminant(gbdp, rr, points-rr)

 sub = where(discriminant GE 0)

 return, sub
end
;===========================================================================
