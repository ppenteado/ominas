;===========================================================================
; map_map_to_image_sinusoidal
;
;
;===========================================================================
function map_map_to_image_sinusoidal, mdp, map_pts
@nv_lib.include
 md = nv_dereference(mdp)

 ecc = map_radii_to_ecc(md.radii)

 nt = n_elements(md)
 sv = size(map_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 result = dblarr(2,nv,nt, /nozero)



 a = 0.25*min(md.size)*md.scale





 result[0,*,*] = $
       a*(map_pts[1,*,*]-md.center[1])*cos(map_pts[0,*,*]) / $
                        (1d - ecc^2*sin(map_pts[0,*,*])^2) + md.origin[0]

; M = 
 result[1,*,*] = M + md.origin[1]



 return, result
end
;===========================================================================



