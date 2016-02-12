;==============================================================================
; w_to_xy
;
;
;==============================================================================
function w_to_xy, im, w, sx=sx, sy=sy

 if(n_elements(im) EQ 2) then $
  begin
    sx = im[0]
    sy = im[1] 
  end $
 else $
  begin
   s = size(im)
   if(NOT keyword_set(sx)) then sx = s[1]
   if(NOT keyword_set(sy)) then sy = s[2]
  end

 xarr = w mod sx
 yarr = w / sx

 return, [tr(xarr), tr(yarr)]
end
;==============================================================================
