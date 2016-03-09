;=============================================================================
; vgr_from_ominas
;
;=============================================================================
function vgr_from_ominas, _od, orient_fn

 if(NOT keyword__set(_od)) then return, 0

 od = nv_clone(_od)

 cd = class_extract(od, 'CAMERA')
 if(keyword__set(cd)) then $
  begin
   bd = cam_body(cd)
   bod_set_orient, bd, call_function(orient_fn, bod_orient(bd))
   bod_set_pos, bd, bod_pos(bd)/1000d			; m --> km
   bod_set_vel, bd, bod_vel(bd)/1000d			; m/s --> km/s
   cam_set_body, cd, bd
   return, od
  end

 gbd = class_extract(od, 'GLOBE')
 if(keyword__set(gbd)) then $
  begin
   bd = class_extract(gbd, 'BODY')
   bod_set_pos, bd, bod_pos(bd)/1000d		; m --> km
   bod_set_vel, bd, bod_vel(bd)/1000d		; m/s --> km/s
   glb_set_radii, gbd, glb_radii(gbd)/1000d	; m --> km
   class_insert, gbd, bd, 'BODY'
   return, od
  end


 return, od
end
;=============================================================================
