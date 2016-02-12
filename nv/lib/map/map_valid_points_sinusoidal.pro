;=============================================================================
; map_valid_points_sinusoidal
;
;=============================================================================
function map_valid_points_sinusoidal, md, map_pts, image_pts

 nt = n_elements(md)
 sv = size(image_pts)
 nv = 1
 if(sv[0] GT 1) then nv = sv[2]

 valid = lindgen(nv*nt)

 return, valid
end
;=============================================================================
