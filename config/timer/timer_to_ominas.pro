;=============================================================================
; timer_to_ominas
;
;=============================================================================
function timer_to_ominas, _od

 if(NOT keyword__set(_od)) then return, 0

 od = nv_clone(_od)

;;; bod_set_orient, od, timer_cmat_to_orient(bod_orient(od))
 bod_set_pos, od, bod_pos(od)*1000d		; km --> m
 bod_set_vel, od, bod_vel(od)*1000d		; km/s --> m/s
 return, od

end
;=============================================================================
