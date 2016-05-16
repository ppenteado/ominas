;==============================================================================
; orb_compute_ta
;
;==============================================================================
function orb_compute_ta, rx

 e = orb_get_ecc(rx)
 _e = e

 ea = orb_compute_ea(rx)

 cos_ea = cos(ea)
 cos_ta = (e - cos_ea) / (e*cos_ea - 1d)

 ta = acos(cos_ta)
 w = where(ea GT !dpi)
 if(w[0] NE -1) then ta[w] = 2d*!dpi - ta[w]

 return, ta
end
;==============================================================================
