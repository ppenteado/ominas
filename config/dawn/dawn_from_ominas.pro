;=============================================================================
; dawn_from_ominas
;
;=============================================================================
function dawn_from_ominas, _od, orient_fn

 if(NOT keyword__set(_od)) then return, 0

 od = nv_clone(_od)

 if(cor_isa(od, 'CAMERA')) then $
  begin
   bod_set_orient, od, call_function(orient_fn, bod_orient(od))
   bod_set_pos, od, bod_pos(od)/1000d			; m --> km
   bod_set_vel, od, bod_vel(od)/1000d			; m/s --> km/s
   return, od
  end

 if(cor_isa(od, 'GLOBE')) then $
  begin
   bod_set_pos, od, bod_pos(od)/1000d		; m --> km
   bod_set_vel, od, bod_vel(od)/1000d		; m/s --> km/s
   glb_set_radii, god, glb_radii(god)/1000d	; m --> km
   return, od
  end


 return, od
end
;=============================================================================
