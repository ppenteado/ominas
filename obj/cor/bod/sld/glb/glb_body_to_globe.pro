;===========================================================================
;+
; NAME:
;	glb_body_to_globe
;
;
; PURPOSE:
;       Transforms the given column vectors from the body coordinate
;       system to the globe coordinate system.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	globe_pts = glb_body_to_globe(gbd, body_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	        Array (nt) of any subclass of GLOBE descriptors.
;
;	body_pts:	Array (nv,3,nt) of column vectors in the body frame.
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
;       Array (nv,3,nt) of column vectors in the globe frame.
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
function glb_body_to_globe, gbd, v
@core.include
 
 _gbd = cor_dereference(gbd)

 sv = size(v)
 nv = sv[1]
 nt = n_elements(_gbd)

 rad = sqrt(total(v*v, 2))

 lat = asin(v[*,2,*]/rad)
 
 lon = atan(v[*,1,*],v[*,0,*])
 w = where(finite(lon) NE 1)
 if(w[0] NE -1) then lon[w]=0.0

 radius = glb_get_radius(gbd, lat, lon)
 alt = rad - radius

 result = dblarr(nv,3,nt)
 result[*,0,*] = lat
 result[*,1,*] = lon
 result[*,2,*] = alt

 return, result
end
;===========================================================================



