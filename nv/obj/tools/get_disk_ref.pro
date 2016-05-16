;=============================================================================
;+
; NAME:
;       get_disk_ref
;
;
; PURPOSE:
;	Produces inertial unit vectors corresponding to the projection
;	of the given body 2-axis direction into the given disk plane.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       dkx_cat = get_disk_ref(dkx, bx)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	Array (nt) of any subclass of DISK.
;
;	bx:	Array (nt) of any subclass of BODY.
;
;  OUTPUT:
;       NONE
;
;
; KEYOWRDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (1,3,nt) of inertial unit vectors.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function get_disk_ref, dkx, bx

 v = bod_pos(bx) - bod_pos(dkx)
 vv = bod_inertial_to_body(dkx, v)

 vv[*,2,*] = 0

 result = bod_body_to_inertial(dkx, v_unit(vv))

 return, result
end
;===========================================================================



