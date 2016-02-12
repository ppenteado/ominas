;===========================================================================
; vgr_spice_time
;
;===========================================================================
function vgr_spice_time, label, dt=dt, status=status

 status = 0

 scet = vicar_vgrkey(label, 'SCET')
 p = strpos(strupcase(scet), 'UNKNOWN')
 if(p[0] NE -1) then $
  begin
   status = -1
   return, 0
  end

 exposure = vicar_vgrkey(label, 'EXP') / 1000d

 close_time = vgr_scet_to_image_time(scet)
 dt = -0.5d*exposure

 return, close_time
end
;===========================================================================



