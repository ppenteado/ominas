;=============================================================================
;+
; NAME:
;       get_solar_ref
;
;
; PURPOSE:
;	Produces inertial unit vectors corresponding to the projection
;	of the sun direction into the given disk plane.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       v = get_solar_ref(dkx, ltd)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	Array (nt) of any subclass of DISK.
;
;	ltd:	Array (nt) of any subclass of STAR representing the sun.
;
;  OUTPUT:  NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (1,3,nt) of inertial vectors.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function get_solar_ref, dkx, ltd

 v = bod_pos(ltd) - bod_pos(dkx)
 vv = bod_inertial_to_body(dkx, v)

 vv[*,2,*] = 0

 result = bod_body_to_inertial(dkx, v_unit(vv))

 return, result
end
;===========================================================================



