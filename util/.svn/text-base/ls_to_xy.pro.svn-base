;==============================================================================
; ls_to_xy.pro
;
;==============================================================================
function ls_to_xy, ls, image, order=order, size=size

 s = size(image)
 sx = s[1] & sy = s[2]
 if(keyword_set(size)) then $
  begin
   sx = size[0] & sy = size[1]
  end

 if(keyword__set(order)) then ls[0] = sy+1 - ls[0]
 xy = rotate(ls, 2) - 1d

 return, xy
end
;==============================================================================

