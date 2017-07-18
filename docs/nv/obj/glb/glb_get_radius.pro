;===========================================================================
;+
; NAME:
;	glb_get_radius
;
;
; PURPOSE:
;	Computes the local radius of a GLOBE object at the given lat/lon.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	radius = glb_get_radius(gbd, lat, lon)
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
;	Array (nv, nt) of radius values.
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
function glb_get_radius, gbd, lat, lon, noevent=noevent
@core.include
 
 nv_notify, gbd, type = 1, noevent=noevent
 _gbd = cor_dereference(gbd)

 nt = n_elements(_gbd)
; np = (size(lat))[1]
 np = n_elements(lat)/nt

 M = make_array(np,val=1)

 a2 = [(_gbd.radii[0,*]^2)]##M
 b2 = [(_gbd.radii[1,*]^2)]##M
 c2 = [(_gbd.radii[2,*]^2)]##M

 lon1 = lon-[(_gbd.lora)]##M
 cos_lat = cos(lat)

 return, sqrt(a2*b2*c2 / $
                   (a2*b2*sin(lat)^2 + $
                           b2*c2*cos_lat^2*cos(lon1)^2 + $
                                      a2*c2*cos_lat^2*sin(lon1)^2))
end
;===========================================================================



