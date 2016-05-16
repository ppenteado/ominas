;=============================================================================
; gll_to_ominas
;
;=============================================================================
function gll_to_ominas, _od, orient_fn

 if(NOT keyword__set(_od)) then return, 0

 od = nv_clone(_od)

 bod_set_orient, od, call_function(orient_fn, bod_orient(od))
 bod_set_pos, od, bod_pos(od)*1000d		; km --> m
 bod_set_vel, od, bod_vel(od)*1000d		; km/s --> m/s
 return, od


 return, od
end
;=============================================================================
