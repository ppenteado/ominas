;===========================================================================
;+
; NAME:
;	glb_get_surface_normal_body
;
;
; PURPOSE:
;	Computes the surface normal of a GLOBE object at the given 
;	position in the BODY frame.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	n = glb_get_surface_normal_body(gbx, v)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	Array (nt) of any subclass of GLOBE descriptors.
;
;	v:	Array (nv,3) of BODY-frame vectors.
;
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
;	Array (nv, 3, nt) of surface normals in the BODY frame.  Note that 
;	the output vectors are not normalized.
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
;===========================================================================
function glb_get_surface_normal_body, gbxp, v
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 nv_notify, gbdp, type = 1
 gbd = nv_dereference(gbdp)

 nt = n_elements(gbd)
 np = (size(v))[1]

 M = make_array(np,val=1)

 zz = [0,0,1d]##M
 vv = v_rotate(v, zz, [sin(gbd.lora)], [cos(gbd.lora)])

 rr = transpose(reform(gbd.radii[linegen3z(3,nt,np)], 3,nt,np,/over), [2,0,1])

 return, vv/rr^2
end
;===========================================================================
