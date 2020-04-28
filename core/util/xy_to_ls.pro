;==============================================================================
; xy_to_ls.pro
;
;==============================================================================
function xy_to_ls, xy, image, order=order, size=size

 s = size(image)
 sx = s[1] & sy = s[2]
 if(keyword_set(size)) then $
  begin
   sx = size[0] & sy = size[1]
  end


 ls = rotate(xy, 2) + 1d
 if(keyword__set(order)) then ls[0] = sy+1 - ls[0]

 return, ls
end
;==============================================================================

