;===========================================================================
;+
; NAME:
;	glb_get_surface_normal
;
;
; PURPOSE:
;	Computes the surface normals of a GLOBE object at the given 
;	body-frame positions.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	n = glb_get_surface_normal(gbx, r)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	Array (nt) of any subclass of GLOBE descriptors.
;
;	r:	Array (nv,3) of surface positions in the BODY frame.
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
;	Array (nv, 3, nt) of surface unit normals in the BODY frame.
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
function glb_surface_normal, gbxp, r
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 nv_notify, gbdp, type = 1
 gbd = nv_dereference(gbdp)


 nv = (size(r))[1]
 nt = n_elements(gbd)

 radii = (gbd.radii)[linegen3x(nv,3,nt)]

 return, v_unit(r/radii^2)
end
;=============================================================================
