;=============================================================================
;+
; NAME:
;       map_to_image
;
;
; PURPOSE:
;       Transforms points from map coordinates to image coordinates.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;
;       result = map_to_image(md, cd, bx, map_pts)
;
;
; ARGUMENTS:
;  INPUT:
;	md:	Array of nt map descriptors describing the initial coordinate system.
;		If bx is given, then this descriptor is not needed, though
;		it may still be used to select between graphic/centric 
;		latitudes.
;
;	cd:	Array of nt camera or map descriptor describing the final 
;		coordinate system.
;
;	bx:	Array of nt Object descriptors (subclass of BODY).
;
;	map_pts:       Array (2 x nv x nt) of map points
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;   INPUT: 
;	valid:	Indices of valid output points.
;
;	body_pts:	Body coordinates of output points.
;
;
;   OUTPUT: NONE
;
;
; RETURN:
;       Array (2 x nv x nt) of image points.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;-
;=============================================================================
function map_to_image, md, cd, bx, map_pts, body_pts=body_pts, valid=valid

 if(NOT keyword_set(map_pts)) then return, 0

 if(NOT keyword_set(bx)) then return, map_map_to_image(md, map_pts, valid=valid)

 return, surface_to_image(cd, bx, body_pts=body_pts, $
           map_to_surface(md, bx, map_pts), valid=valid)

end
;===========================================================================
