;===========================================================================
; vgr_spice_time
;
;===========================================================================
function vgr_spice_time, label, dt=dt, string=close_time

 scet = vicar_vgrkey(label, 'SCET')
 p = strpos(strupcase(scet), 'UNKNOWN')
 if(p[0] NE -1) then return, -1d100

 exposure = vicar_vgrkey(label, 'EXP') / 1000d

 close_time = vgr_scet_to_image_time(scet)
 dt = -0.5d*exposure
 
 ret=spice_str2et(close_time) + dt
 nv_message,verb=0.91,'close_time='+strtrim(close_time,2)+' et='+strtrim(ret,2)
 return, ret
end
;===========================================================================



