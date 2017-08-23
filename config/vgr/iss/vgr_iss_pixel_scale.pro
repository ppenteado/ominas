;=============================================================================
; vgr_iss_pixel_scale
;
;=============================================================================
function vgr_iss_pixel_scale, sc, cam, geom=geom


 names = ['vg1na', 'vg1wa', 'vg2na', 'vg2wa'] 
 fl = [1503.49d, 200.770d, 1500.19d, 200.465d] ; Focal length of VGR cameras

 index = where(names EQ strlowcase(sc+cam))
 scale = 1.d/(fl[index]*84.821428d)            ; 84.. = pixels/mm

 if(NOT keyword_set(geom)) then scale = scale / 0.85d	; this is kind of a guess

 return, [scale, scale]
end
;=============================================================================



