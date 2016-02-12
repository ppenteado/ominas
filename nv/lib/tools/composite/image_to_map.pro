;=============================================================================
;+
; NAME:
;       image_to_map
;
;
; PURPOSE:
;       Transforms points in image coordinates to map coordinates.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = image_to_map(cd, gbd, p)
;
;
; ARGUMENTS:
;  INPUT:
;	md:	Array of nt map or camera descriptors.
;
;	gbx:	Array of nt object descriptors (of type GLOBE).
;
;	p:	Array (2 x nv x nt) of image points
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;   INPUT:
;	bx:	If md is not a map descriptor, bx gives a subclass of BODY
;		needed for transforming surface to map coordinates.
;
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.  One per bx.
;
;   OUTPUT:
;	valid:	Indices of valid output points.
;
;	body_pts:	Body coordinates of output points.
;
;
; RETURN:
;       Array (nv x 3 x nt) of map points.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale;
;-
;=============================================================================
function image_to_map, md, p, bx=bx, valid=valid, body_pts=body_pts, frame_bd=frame_bd

 if(NOT keyword_set(p)) then return, 0

 if(class_get(md[0]) EQ 'MAP') then return, map_image_to_map(md, p, valid=valid)

 return, surface_to_map(md, bx, $
           image_to_surface(md, bx, p, frame_bd=frame_bd, valid=valid))

end
;==========================================================================



