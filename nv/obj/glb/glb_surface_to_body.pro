;===========================================================================
; glb_surface_to_body
;
;===========================================================================
function glb_surface_to_body, gbd, v
 nv_message, /con, name='glb_surface_to_body', $
   'WARNING: this routine is obsolete.  Use glb_globe_to_body instead.'
 return, glb_globe_to_body(gbd, v)
end
;===========================================================================



;===========================================================================
; glb_surface_to_body
;
; v is array (nv,3,nt) of 3-element column vectors. result is array 
; (nv,3,nt) of 3-element column vectors.
;
;===========================================================================
function _glb_surface_to_body, gbd, v
@core.include
 
 _gbd = cor_dereference(gbd)

 sv = size(v)
 nv = sv[1]
 nt = n_elements(_gbd)

 lat = v[*,0,*]
 lon = v[*,1,*]
; rad = v[*,2,*]
 alt = v[*,2,*]
 rad = alt + glb_get_radius(gbd, lat, lon)

 result = dblarr(nv,3,nt)
 result[*,0,*] = rad*cos(lat)*cos(lon)
 result[*,1,*] = rad*cos(lat)*sin(lon)
 result[*,2,*] = rad*sin(lat)

 return, result
end
;===========================================================================
