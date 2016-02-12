;=============================================================================
;+
; NAME:
;       inertial_to_image_pos
;
;
; PURPOSE:
;       Transforms vectors in inertial coordinates to image coordinates
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = inertial_to_image_pos(cd, v)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Array of nt camera descriptors.
;
;	v:	Array (nv x 3 x nt) of inertial vectors
;
;  OUTPUT:
;       NONE
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
;
;-
;=============================================================================
function inertial_to_image_pos, cd, v
 return, cam_focal_to_image(cd, $
           cam_body_to_focal(cd, $
             bod_inertial_to_body_pos(cam_body(cd), v)))
end
;=============================================================================
