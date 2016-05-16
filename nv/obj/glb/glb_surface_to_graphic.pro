;===========================================================================
; glb_surface_to_graphic
;
; v is array (nv,3,nt) of 3-element column vectors. result is array 
; (nv,3,nt) of 3-element column vectors.
;
;===========================================================================
function glb_surface_to_graphic, gbd, v
 nv_message, /con, name='glb_surface_to_graphic', $
   'WARNING: this routine is obsolete.  Use glb_globe_to_graphic instead.'
 return, glb_globe_to_graphic(gbd, v)
end
;===========================================================================



;===========================================================================
; glb_surface_to_graphic
;
; v is array (nv,3,nt) of 3-element column vectors. result is array 
; (nv,3,nt) of 3-element column vectors.
;
;===========================================================================
function _glb_surface_to_graphic, gbd, v
@core.include
 
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

 tan_glat = a2*b2/c2 / sqrt(b4*cos(v[*,1,*])^2 + a4*sin(v[*,1,*])^2) * $
                                                               tan(v[*,0,*])
 tan_glon = a2/b2 * tan(v[*,1,*])

 result[*,0,*] = atan(tan_glat)
 result[*,1,*] = atan(tan_glon)

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


 return, result
end
;===========================================================================



