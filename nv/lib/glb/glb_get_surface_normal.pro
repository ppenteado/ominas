;===========================================================================
;+
; NAME:
;	glb_get_surface_normal
;
;
; PURPOSE:
;	Computes the surface normal of a GLOBE object at the given 
;	lat/lon position.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	n = glb_get_surface_normal_body(gbx, lat, lon)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	Array (nt) of any subclass of GLOBE descriptors.
;
;	lat:	Array (nv) of latitudes.
;
;	lon:	Array (nv) of longitudes.
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
function glb_get_surface_normal, gbxp, lat, lon
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 nv_notify, gbdp, type = 1
 gbd = nv_dereference(gbdp)

 nt = n_elements(gbd)
 np = (size(lat))[1]

 M = make_array(np,val=1)

 a2 = [(gbd.radii[0,*]^2)]##M
 b2 = [(gbd.radii[1,*]^2)]##M
 c2 = [(gbd.radii[2,*]^2)]##M

 lon1 = lon-[(gbd.lora)]##M
 cos_lat = cos(lat)

 result = dblarr(np,3,nt, /nozero)
 result[*,0,*] = cos_lat*cos(lon1)/a2
 result[*,1,*] = cos_lat*sin(lon1)/b2
 result[*,2,*] = sin(lat)/c2

 return, result
end
;===========================================================================
