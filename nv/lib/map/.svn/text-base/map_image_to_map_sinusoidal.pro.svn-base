;===========================================================================
; map_image_to_map_sinusoidal
;
;
;===========================================================================
function map_image_to_map_sinusoidal, mdp, _image_pts, valid=valid
 md = nv_dereference(mdp)

 ecc = map_radii_to_ecc(md.radii)

 nt = n_elements(md)
 sv = size(_image_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 result = dblarr(2,nv,nt, /nozero)


 image_pts = dblarr(2,nv,nt, /nozero)
 image_pts[0,*,*] = _image_pts[0,*,*] - md.origin[0]
 image_pts[1,*,*] = _image_pts[1,*,*] - md.origin[1]



 a = 0.25*min(md.size)*md.scale 





; result[0,*,*] =  
 r;esult[1,*,*] =  


 return, result
end
;===========================================================================



