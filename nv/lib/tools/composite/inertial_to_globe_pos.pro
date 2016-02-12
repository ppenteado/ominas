;=============================================================================
;+
; NAME:
;       inertial_to_globe_pos
;
;
; PURPOSE:
;       Transforms position vectors in inertial coordinates to globe 
;	coordinates.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = inertial_to_globe_pos(gbx, v, frame_bd=frame_bd)
;
;
; ARGUMENTS:
;  INPUT:
;	gbx:	Array of nt descritors, subclass of globe.
;
;	v:	Array (nv x 3 x nt) of inertial vectors
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
function inertial_to_globe_pos, gbx, v
 return, glb_body_to_globe(gbx, $
           bod_inertial_to_body_pos(gbx, v))
end
;=============================================================================
