;==============================================================================
; orb_compute_ma
;
;==============================================================================
function orb_compute_ma, rx, ecc=e, f=f, ea=ea

 if(NOT defined(e)) then e = orb_get_ecc(rx)

 if(NOT defined(ea)) then $
  begin
   cos_f = cos(f)
   cos_ea = (e + cos_f) / (1 + e*cos_f)

   ea = acos(cos_ea)
   w = where(reduce_angle(f) GT !dpi)
   if(w[0] NE -1) then ea[w] = -ea[w]
   ea = reduce_angle(ea)
  end

 ma = ea - e*sin(ea)

 return, ma
end
;==============================================================================
