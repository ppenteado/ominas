;=============================================================================
;+
; NAME:
;       inertial_to_disk_pos
;
;
; PURPOSE:
;       Transforms position vectors in inertial coordinates to disk 
;	coordinates.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = inertial_to_disk_pos(dkx, v, frame_bd=frame_bd)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	Array of nt descritors, subclass of DISK.
;
;	v:	Array (nv x 3 x nt) of inertial vectors
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
;   OUTPUT: NONE
;
;
; RETURN:
;       Array (nv x 3 x nt) of disk points.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale, 3/2004
;
;-
;=============================================================================
function inertial_to_disk_pos, dkx, v, frame_bd=frame_bd
 return, dsk_body_to_disk(dkx, $
           bod_inertial_to_body_pos(dkx, v), frame_bd=frame_bd)
end
;=============================================================================
