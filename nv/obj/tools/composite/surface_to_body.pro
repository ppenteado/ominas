;=============================================================================
;+
; NAME:
;       surface_to_body
;
;
; PURPOSE:
;       Transforms points in any surface coordinate system to body
;	coordinates.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = surface_to_body(bx, surface_pts)
;
;
; ARGUMENTS:
;  INPUT:
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
;   OUTPUT: NONE
;
;
; RETURN:
;       Array (nv x 3 x nt) of body coordinates.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;-
;=============================================================================
function surface_to_body, bx, p, frame_bd=frame_bd

 if(NOT keyword_set(p)) then return, 0

 gbx = cor_select(bx, 'GLOBE', /class)
 dkx = cor_select(bx, 'DISK', /class)

 if(keyword_set(gbx)) then return, glb_globe_to_body(gbx, p)
 if(keyword_set(dkx)) then return, dsk_disk_to_body(dkx, p, frame_bd=frame_bd)
 return, bod_radec_to_body(bx, p)

end
;===========================================================================
