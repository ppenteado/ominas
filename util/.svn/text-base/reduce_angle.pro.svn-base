;===========================================================================
; reduce_angle
;
;===========================================================================
function reduce_angle, theta, max=max, min=min

 two_pi = 2d*!dpi

 if(NOT keyword_set(max)) then max = two_pi

 ;---------------------------------------------------
 ; get angles within [0,2pi]
 ;---------------------------------------------------
 phi = theta mod two_pi
 w = where(phi LE 0)
 if(w[0] NE -1) then phi[w] = phi[w] + two_pi


 ;---------------------------------------------------
 ; apply max if given
 ;---------------------------------------------------
 if(n_elements(max) NE 0) then $
  begin
   w = where(phi GE max)
   if(w[0] NE -1) then phi[w] = phi[w] - two_pi
  end

 return, phi
end
;===========================================================================
