;=============================================================================
; despike
;
;
;=============================================================================
function despike, _image, p, scale=scale, n=n

 image = _image

 w = xy_to_w(image, p)

 for i=0, n-1 do $
  begin
   im = smooth(image, scale)
   image[w] = im[w]
  end

 return, image
end
;=============================================================================
