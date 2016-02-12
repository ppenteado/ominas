;=============================================================================
;+
; NAME:
;	glb_body_to_local
;
;
; PURPOSE:
;       Converts the given column vectors from the body coordinate
;       system to the local coordinate system.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	local_dir = glb_body_to_local(gbx, body_pts, body_dir)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	        Array (nt) of any subclass of GLOBE descriptors.
;
;	body_pts:	Array (nv,3,nt) of column vectors in the body
;                       frame (representing points on the surface of 
;                       the globe).
;
;       body_dir:       Array (3,nt) of column vectors in the body
;                       frame, giving the direction from each surface point.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Array (nv,3,nt) of column vectors in the local system.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
function glb_body_to_local, gbxp, v, r
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 gbd = nv_dereference(gbdp)

 sv = size(v)
 nv = sv[1]
 nt = n_elements(gbd)

 z = dblarr(nv,3,nt) & z[*,2,*] = 1d

 zenith = glb_surface_normal(gbdp, v)
 east = v_unit(v_cross(z, zenith))
 north = v_cross(zenith, east)

 result = dblarr(nv,3,nt, /nozero)
 result[*,0,*] = v_inner(east, r)
 result[*,1,*] = v_inner(north, r)
 result[*,2,*] = v_inner(zenith, r)

 return, result
end
;=============================================================================
