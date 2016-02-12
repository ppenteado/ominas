;=============================================================================
; image_dlon  **incomplete**
;
;=============================================================================
function image_dlon, cd, dkd, dlon, image_pts, status=status, max=max

 status=0

 ;------------------------------
 ; compute point spacing
 ;------------------------------
 dist = sqrt(total((image_points - shift(image_points,1))^2, 1))

 ext_sub = external_points(image_points, x0, x1, y0, y1)

; if(dist LE max) then return


 



end
;=============================================================================
