;=============================================================================
; vgr_to_ominas
;
;=============================================================================
function vgr_to_ominas, _od, orient_fn

 if(NOT keyword__set(_od)) then return, 0

 od = nv_clone(_od)

 cd = class_extract(od, 'CAMERA')
 bd = cam_body(cd)
 bod_set_orient, bd, call_function(orient_fn, bod_orient(bd))
 bod_set_pos, bd, bod_pos(bd)*1000d		; km --> m
 bod_set_vel, bd, bod_vel(bd)*1000d		; km/s --> m/s
 cam_set_body, cd, bd
 return, od


 return, od
end
;=============================================================================
