;===========================================================================
;+
; NAME:
;	glb_globe_to_body
;
; PURPOSE:
;       Transforms the given column vectors from the globe coordinate
;       system to the body coordinate system.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	body_pts = glb_globe_to_body(gbd, globe_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	        Array (nt) of any subclass of GLOBE descriptors.
;
;	globe_pts:	Array (nv,3,nt) of column vectors in the globe frame.
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
function glb_globe_to_body, gbd, v
@core.include
 
 _gbd = cor_dereference(gbd)

 sv = size(v)
 nv = sv[1]
 nt = n_elements(_gbd)

 lat = v[*,0,*]
 lon = v[*,1,*]
 alt = v[*,2,*]
 rad = alt + glb_get_radius(gbd, lat, lon)

 result = dblarr(nv,3,nt)
 result[*,0,*] = rad*cos(lat)*cos(lon)
 result[*,1,*] = rad*cos(lat)*sin(lon)
 result[*,2,*] = rad*sin(lat)

 return, result
end
;===========================================================================
