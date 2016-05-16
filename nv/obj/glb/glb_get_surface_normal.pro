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
;	n = glb_get_surface_normal_body(gbd, lat, lon)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	Array (nt) of any subclass of GLOBE descriptors.
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
function glb_get_surface_normal, gbd, lat, lon, noevent=noevent
@core.include
 
 nv_notify, gbd, type = 1, noevent=noevent
 _gbd = cor_dereference(gbd)

 nt = n_elements(_gbd)
 np = (size(lat))[1]

 M = make_array(np,val=1)

 a2 = [(_gbd.radii[0,*]^2)]##M
 b2 = [(_gbd.radii[1,*]^2)]##M
 c2 = [(_gbd.radii[2,*]^2)]##M

 lon1 = lon-[(_gbd.lora)]##M
 cos_lat = cos(lat)

 result = dblarr(np,3,nt, /nozero)
 result[*,0,*] = cos_lat*cos(lon1)/a2
 result[*,1,*] = cos_lat*sin(lon1)/b2
 result[*,2,*] = sin(lat)/c2

 return, result
end
;===========================================================================
