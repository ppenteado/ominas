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
;       v = get_solar_ref(dkx, sund)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	Array (nt) of any subclass of DISK.
;
;	sund:	Array (nt) of any subclass of STAR representing the sun.
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
function get_solar_ref, dkx, sund

 dsk_bd = class_extract(dkx, 'BODY')
 sun_bd = class_extract(sund, 'BODY')

 v = bod_pos(sun_bd) - bod_pos(dsk_bd)
 vv = bod_inertial_to_body(dsk_bd, v)

 vv[*,2,*] = 0

 result = bod_body_to_inertial(dsk_bd, v_unit(vv))

 return, result
end
;===========================================================================



