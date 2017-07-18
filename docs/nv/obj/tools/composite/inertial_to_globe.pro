;=============================================================================
;+
; NAME:
;       inertial_to_globe
;
;
; PURPOSE:
;       Transforms vectors in inertial coordinates to globe coordinates.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = inertial_to_image(gbx, v)
;
;
; ARGUMENTS:
;  INPUT:
;	gbx:	Array of nt descriptors, subclass of globe.
;
;	v:	Array (nv x 3 x nt) of inertial vectors.
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;   INPUT: NONE
;
;   OUTPUT: NONE
;
;
; RETURN:
;       Array (nv x 3 x nt) of globe points.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale, 9/2012
;
;-
;=============================================================================
function inertial_to_globe, gbx, v
 return, glb_body_to_globe(gbx, $
           bod_inertial_to_body(gbx, v))
end
;=============================================================================
