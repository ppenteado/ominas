;=============================================================================
;+
; NAME:
;       image_to_surface
;
;
; PURPOSE:
;       Transforms points in image coordinates to surface coordinates.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = image_to_surface(cd, bx, surface_pts)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:      Array of nt camera or map descriptor
;
;	bx:      Array of nt object descriptors (subclass of BODY).
;
;	surface_pts:       Array (2 x nv x nt) of surface points.
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;   INPUT: 
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.  One per bx.
;
;
;   OUTPUT: 
;	valid:	Indices of valid output points.
;
;       hit:	Array with one element per input point.  1 if point
;		falls on the body, 0 if not.
;
;	body_pts:	Body coordinates of output points.
;
;	discriminant:	Determinant D from the ray trace.  No solutions for
;			 D<0, two solutions for D=0, one slution for D>0.
;
;
; RETURN:
;       Array (nv x 3 x nt) of surface points.  In the case of a camera descriptor, ray
;	tracing is used.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;-
;=============================================================================
function image_to_surface, cd, bx, p, frame_bd=frame_bd, body_pts=body_pts, $
                                discriminant=discriminant, hit=hit, valid=valid

 if(NOT keyword_set(p)) then return, 0

 gbd = class_extract(bx, 'GLOBE')
 dkd = class_extract(bx, 'DISK')

 if(keyword_set(gbd)) then $
         return, image_to_globe(cd, bx, p, body_pts=body_pts, $
                                           discriminant=discriminant, valid=valid)

 if(keyword_set(dkd)) then $
         return, image_to_disk(cd, bx, p, frame_bd=frame_bd, $
                                           body_pts=body_pts, hit=hit, valid=valid)

 hit = make_array(n_elements(p[0,*]), val=1b)
 valid = lindgen(n_elements(p[0,*]))
 return, image_to_radec(cd, p, body_pts=body_pts)
end
;==========================================================================
