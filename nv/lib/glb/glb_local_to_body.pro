;=============================================================================
;+
; NAME:
;	glb_local_to_body
;
; PURPOSE:
;       Converts the given column vectors from the local coordinate
;       system to the body coordinate system.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	body_dir = glb_local_to_body(gbx, body_pts, local_dir)
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
;       local_dir:      Array (3,nt) of column vectors in the local
;                       system, giving the direction from each surface point.
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
;       Array (nv,3,nt) of column vectors in the body frame.
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
function glb_local_to_body, gbxp, v, r
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

 M = dblarr(nv,3,3,nt)
 M[*,0,*,*] = east
 M[*,1,*,*] = north
 M[*,2,*,*] = zenith


 result = dblarr(nv,3,nt, /nozero)
 result[*,0,*] = v_inner(M[*,*,0,*],r)
 result[*,1,*] = v_inner(M[*,*,1,*],r)
 result[*,2,*] = v_inner(M[*,*,2,*],r)

 return, result
end
;=============================================================================
