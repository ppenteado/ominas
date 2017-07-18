;===========================================================================
;+
; NAME:
;	glb_get_surface_normal
;
;
; PURPOSE:
;	Computes the surface normal of a GLOBE object at the given 
;	globe position.
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	n = glb_get_surface_normal_body(gbd, p)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	Array (nt) of any subclass of GLOBE descriptors.
;
;	p:	Array (nv,3,nt) of points in the GLOBE system.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	nonorm:	If set, the returned vectors are not normalized.
;
;	body:	If set, the inputs given in the BODY system instead of GLOBE.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (nv, 3, nt) of surface normals in the BODY frame.  
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
function glb_get_surface_normal, gbd, globe_pts, noevent=noevent, $
                                                  nonorm=nonorm, body=body
@core.include
 
 nv_notify, gbd, type = 1, noevent=noevent
 _gbd = cor_dereference(gbd)

 if(keyword_set(body)) then return, _glb_get_surface_normal_body(_gbd, globe_pts)

 nt = n_elements(_gbd)
 np = (size(globe_pts, /dim))[0]

 M = make_array(np,val=1)

 a2 = [(_gbd.radii[0,*]^2)]##M				; np x nt
 b2 = [(_gbd.radii[1,*]^2)]##M				; np x nt
 c2 = [(_gbd.radii[2,*]^2)]##M				; np x nt

 lon = globe_pts[*,1,*] - [_gbd.lora]##M		; np x nt
 sin_lat = sin(globe_pts[*,0,*])			; np x nt
 cos_lat = cos(globe_pts[*,0,*])			; np x nt

 result = dblarr(np,3,nt, /nozero)
 result[*,0,*] = cos_lat*cos(lon)/a2
 result[*,1,*] = cos_lat*sin(lon)/b2
 result[*,2,*] = sin_lat/c2

 if(keyword_set(nonorm)) then return, result
 return, v_unit(result)
end
;===========================================================================



;===========================================================================
function ___glb_get_surface_normal, gbd, lat, lon, noevent=noevent
@core.include
 
 nv_notify, gbd, type = 1, noevent=noevent
 _gbd = cor_dereference(gbd)

 nt = n_elements(_gbd)
 np = n_elements(lat)

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
 if(keyword_set(nonorm)) then return, result
 return, v_unit(result)
end
;===========================================================================
