;=============================================================================
; gauss2d
;
;=============================================================================
function gauss2d, x, y, sig_a, sig_b, theta, norm=norm

 if(keyword_set(theta)) then $
  begin
   sin_theta = sin(theta)
   cos_theta = cos(theta)
   x_ = x*cos_theta - y*sin_theta
   y_ = x*sin_theta + y*cos_theta
   end $
 else $
  begin
   x_ = x
   y_ = y
  end

 if(NOT keyword_set(sig_b)) then sig_b = sig_a

 U = (x_/sig_a)^2 + (y_/sig_b)^2

 mag = 1d
; if(keyword_set(norm)) then mag = !dpi/2d / sig_a / sig_b
 if(keyword_set(norm)) then mag = !dpi*2d / sig_a / sig_b


 return, exp(-0.5*U) / mag
end
;=============================================================================
