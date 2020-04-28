;==============================================================================
; osk_eval
;
;==============================================================================
function osk_eval, ea
common _osk_block, e, ma
 return, ea - e*sin(ea) - ma
end
;==============================================================================



;==============================================================================
; orb_compute_ea
;
;==============================================================================
function orb_compute_ea, rx, ecc=ecc
common _osk_block, e, ma

 if(defined(ecc)) then e = ecc $ 
 else e = orb_get_ecc(rx)
 _e = e
 n = n_elements(e)

 ea = dblarr(n)

 if(size(rx, /type) NE 11) then ma = rx $ 
 else ma = orb_get_ma(rx)
 _ma = ma

 ;------------------------------------------------------------------------
 ; We loop here because newton is actually slower when all the equations
 ; are sent in one shot.  Probably because it assumes the equations are
 ; coupled, which is not true in this case.
 ;------------------------------------------------------------------------
 for i=0, n-1 do $
  begin
   e = _e[i]
   ma = _ma[i]
   ea[i] = newton(ma, 'osk_eval', /double)
  end


 return, ea
end
;==============================================================================
