;===========================================================================
; glb_body_to_surface
;
;===========================================================================
function glb_body_to_surface, gbxp, v
 nv_message, /con, name='glb_body_to_surface', $
   'WARNING: this routine is obsolete.  Use glb_body_to_globe instead.'
 return, glb_body_to_globe(gbxp, v)
end
;===========================================================================


;===========================================================================
; glb_body_to_surface
;
; v is array (nv,3,nt) of 3-element column vectors. result is array 
; (nv,3,nt) of 3-element column vectors.
;
;===========================================================================
function _glb_body_to_surface, gbxp, v
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 gbd = nv_dereference(gbdp)

 sv = size(v)
 nv = sv[1]
 nt = n_elements(gbd)

 rad = sqrt(total(v*v, 2))

 lat = asin(v[*,2,*]/rad)
 
 lon = atan(v[*,1,*],v[*,0,*])
 w = where(finite(lon) NE 1)
 if(w[0] NE -1) then lon[w]=0.0

 radius = glb_get_radius(gbxp, lat, lon)
 alt = rad - radius

 result = dblarr(nv,3,nt)
 result[*,0,*] = lat
 result[*,1,*] = lon
 result[*,2,*] = alt

 return, result
end
;===========================================================================



