;===========================================================================
; glb_graphic_to_surface
;
;===========================================================================
function glb_graphic_to_surface, gbd, v
 nv_message, /con, name='glb_graphic_to_surface', $
   'WARNING: this routine is obsolete.  Use glb_graphic_to_globe instead.'
 return, glb_graphic_to_globe(gbd, v)
end
;===========================================================================



;===========================================================================
; glb_graphic_to_surface
;
; v is array (nv,3,nt) of 3-element column vectors. result is array 
; (nv,3,nt) of 3-element column vectors.
;
;===========================================================================
function _glb_graphic_to_surface, gbd, v, noevent=noevent
@core.include
 
 nv_notify, gbd, type = 1, noevent=noevent
 _gbd = cor_dereference(gbd)

 sv = size(v)
 nv = sv[1]
 nt = n_elements(_gbd)

 result = dblarr(nv,3,nt)

 a2 = _gbd.radii[0]^2
 b2 = _gbd.radii[1]^2
 c2 = _gbd.radii[2]^2
 a4 = a2^2
 b4 = b2^2


 tan_lon = b2/a2 * tan(v[*,1,*])
 result[*,1,*] = atan(tan_lon)

 w = where(v[*,1,*] GT !dpi/2d)
 if(w[0] NE -1) then $
  begin
   xx = result[*,1,*]
   xx[w] = xx[w] + !dpi
   result[*,1,*] = xx
  end

 w = where(v[*,1,*] LT -!dpi/2d)
 if(w[0] NE -1) then $
  begin
   xx = result[*,1,*]
   xx[w] = xx[w] - !dpi
   result[*,1,*] = xx
  end


 tan_lat = c2/a2/b2 * $
      sqrt(b4*cos(result[*,1,*])^2 + a4*sin(result[*,1,*])^2) * tan(v[*,0,*])
 result[*,0,*] = atan(tan_lat)

 w = where(v[*,0,*] GT !dpi/2d)
 if(w[0] NE -1) then $
  begin
   xx = result[*,0,*]
   xx[w] = xx[w] + !dpi
   result[*,0,*] = xx
  end

 w = where(v[*,0,*] LT -!dpi/2d)
 if(w[0] NE -1) then $
  begin
   xx = result[*,0,*]
   xx[w] = xx[w] - !dpi
   result[*,0,*] = xx
  end


 return, result
end
;===========================================================================



