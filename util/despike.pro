;=============================================================================
; despike
;
;
;=============================================================================
function despike, _image, p, scale=scale, n=n, weight=weight

 np = n_elements(p)/2
 if(NOT keyword_set(weight)) then weight = make_array(np, val=1d)

 image = _image

 w = xy_to_w(image, round(p))

 for i=0, n-1 do $
  begin
   im = smooth(image, scale)
   image[w] = weight*im[w] + (1d - weight)*image[w]
  end

 return, image
end
;=============================================================================
