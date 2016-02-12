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
;	radius = glb_get_radius(gbx, lat, lon)
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
;	Array (nv, nt) of radius values.
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
function glb_get_radius, gbxp, lat, lon
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 nv_notify, gbdp, type = 1
 gbd = nv_dereference(gbdp)

 nt = n_elements(gbd)
; np = (size(lat))[1]
 np = n_elements(lat)/nt

 M = make_array(np,val=1)

 a2 = [(gbd.radii[0,*]^2)]##M
 b2 = [(gbd.radii[1,*]^2)]##M
 c2 = [(gbd.radii[2,*]^2)]##M

 lon1 = lon-[(gbd.lora)]##M
 cos_lat = cos(lat)

 return, sqrt(a2*b2*c2 / $
                   (a2*b2*sin(lat)^2 + $
                           b2*c2*cos_lat^2*cos(lon1)^2 + $
                                      a2*c2*cos_lat^2*sin(lon1)^2))
end
;===========================================================================



