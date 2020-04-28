;============================================================================
; image_centroid
;
;
;============================================================================
function image_centroid, im

 dim = size(im, /dim)
 x = dindgen(dim[0]) # make_array(dim[1], val=1d)
 y = dindgen(dim[1]) ## make_array(dim[0], val=1d)

 total = total(im)
 cx = total(x*im)/total
 cy = total(y*im)/total

 return, [cx,cy]
end
;============================================================================
