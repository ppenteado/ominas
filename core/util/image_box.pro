;=============================================================================
; image_box
;
;=============================================================================
function image_box, p0, rad, theta=theta, close=close

 p = [ [p0[0]-rad, p0[1]-rad], $
       [p0[0]+rad, p0[1]-rad], $
       [p0[0]+rad, p0[1]+rad], $
       [p0[0]-rad, p0[1]+rad] ]
 if(keyword_set(close)) then p = transpose([transpose(p), transpose(p[*,0])])

; if(keyword_set(theta)) then 

 return, p
end
;=============================================================================
