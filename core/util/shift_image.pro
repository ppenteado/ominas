;===================================================================================
; shift_image
;
;
;===================================================================================
function shift_image, image, sx, sy

 s = size(image)
 min = min(image)

 shift_image = shift(image, sx,sy)

 if(sx GT 0) then shift_image[0:sx-1,*] = min
 if(sx LT 0) then shift_image[s[1]+sx-1:*,*] = min

 if(sy GT 0) then shift_image[*,0:sy-1] = min
 if(sy LT 0) then shift_image[*,s[2]+sy-1:*] = min

 return, shift_image
end
;===================================================================================
