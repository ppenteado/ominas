;==============================================================================
; osk_eval
;
;==============================================================================
function osk_eval, EE
common _osk_block, e, ma
 return, EE - e*sin(EE) - ma
end
;==============================================================================



;==============================================================================
; orb_solve_kepler
;
;==============================================================================
function orb_solve_kepler, rx
common _osk_block, e, ma

 e = orb_get_ecc(rx)
 ma = orb_get_ma(rx)

 _e = e & _ma = ma

 n = n_elements(e)
 EE = dblarr(n)

 ;------------------------------------------------------------------------
 ; We loop here because newton is acutally slower when all the equations
 ; are sent in one shot.  Probably because it assumes the equations are
 ; coupled, which is not true in this case.
 ;------------------------------------------------------------------------
 for i=0, n-1 do $
  begin
   e = _e[i]
   ma = _ma[i]
   EE[i] = newton(ma, 'osk_eval', /double)
  end

 cos_EE = cos(EE)
 cos_f = (e - cos_EE) / (e*cos_EE - 1d)

 f = acos(cos_f)

 w = where(EE GT !dpi)
 if(w[0] NE -1) then f[w] = 2d*!dpi - f[w]


 return, f
end
;==============================================================================
