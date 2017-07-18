;===========================================================================
; map_image_to_map_sinusoidal
;
;
;===========================================================================
function map_image_to_map_sinusoidal, md, _image_pts, valid=valid
 _md = cor_dereference(md)

 ecc = map_radii_to_ecc(_md.radii)

 nt = n_elements(_md)
 sv = size(_image_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 result = dblarr(2,nv,nt, /nozero)


 image_pts = dblarr(2,nv,nt, /nozero)
 image_pts[0,*,*] = _image_pts[0,*,*] - _md.origin[0]
 image_pts[1,*,*] = _image_pts[1,*,*] - _md.origin[1]



 a = 0.25*min(_md.size)*_md.scale 





; result[0,*,*] =  
 r;esult[1,*,*] =  


 return, result
end
;===========================================================================



