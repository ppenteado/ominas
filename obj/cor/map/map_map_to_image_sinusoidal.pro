;===========================================================================
; map_map_to_image_sinusoidal
;
;
;===========================================================================
function map_map_to_image_sinusoidal, md, map_pts
@core.include
 _md = cor_dereference(md)

 ecc = map_radii_to_ecc(_md.radii)

 nt = n_elements(_md)
 sv = size(map_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 result = dblarr(2,nv,nt, /nozero)



 a = 0.25*min(_md.size)*_md.scale





 result[0,*,*] = $
       a*(map_pts[1,*,*]-_md.center[1])*cos(map_pts[0,*,*]) / $
                        (1d - ecc^2*sin(map_pts[0,*,*])^2) + _md.origin[0]

; M = 
 result[1,*,*] = M + _md.origin[1]



 return, result
end
;===========================================================================



