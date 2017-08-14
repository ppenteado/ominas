;=============================================================================
; synth_image.pro
;
;=============================================================================
function synth_image, cd, pd, ltd, rd=rd

 cam_size = cam_size(cd)

 xsize = cam_size[0]
 ysize = cam_size[1]
 xysize = xsize*ysize
; limb_pts = ...
; term_pts = ...
; indices = polyfillv(p[0,*], p[1,*], xsize, ysize)

 indices = lindgen(xysize)

 xarray = indices mod ysize
 yarray = fix(indices / ysize) + 1

 nn = n_elements(xarray)

 image_pts = dblarr(2, nn)
 image_pts[0,*] = xarray
 image_pts[1,*] = yarray


stop
 pht_angles, image_pts, cd, pd, ltd, emm=emm, inc=inc, g=g, valid=valid

end
;=============================================================================

