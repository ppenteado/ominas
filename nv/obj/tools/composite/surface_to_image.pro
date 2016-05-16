;=============================================================================
;+
; NAME:
;       surface_to_image
;
;
; PURPOSE:
;       Transforms points in any surface coordinate system to image
;	coordinates.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = surface_to_image(cd, bx, surface_pts)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:      Array of nt camera or map descriptors.
;
;	bx:      Array of nt object descriptors (subclass of BODY).
;
;	surface_pts:       Array (nv x 3 x nt) of surface points
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
function surface_to_image, cd, bx, p, frame_bd=frame_bd, $
                                        body_pts=body_pts, valid=valid

 if(NOT keyword_set(p)) then return, 0

 class = (cor_class(cd))[0]

 if(class EQ 'MAP') then $
      return, map_map_to_image(cd, surface_to_map(cd, bx, p), valid=valid)


 gbx = cor_select(bx, 'GLOBE', /class)
 dkx = cor_select(bx, 'DISK', /class)

 if(keyword_set(gbx)) then $
         return, globe_to_image(cd, gbx, p, body_pts=body_pts, valid=valid)

 if(keyword_set(dkx)) then $
      return, disk_to_image(cd, dkx, p, frame_bd=frame_bd, body_pts=body_pts, valid=valid)

 valid = lindgen(n_elements(p[*,0]))
 return, radec_to_image(cd, p, body_pts=body_pts)

end
;==========================================================================
