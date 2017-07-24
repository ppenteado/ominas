;===========================================================================
; vgr_iss_spice_time
;
;===========================================================================
function vgr_iss_spice_time, label, dt=dt, string=string, status=status

 status = -1
 scet = vicar_vgrkey(label, 'SCET')
 p = strpos(strupcase(scet), 'UNKNOWN')
 if(p[0] NE -1) then return, -1d100
 status = 0

 exposure = vicar_vgrkey(label, 'EXP') / 1000d

 close_time = vgr_scet_to_image_time(scet)
 dt = -0.5d*exposure
 
 if(keyword_set(string)) then return, close_time

 ret=spice_str2et(close_time) + dt
 nv_message,verb=0.91,'close_time='+strtrim(close_time,2)+' et='+strtrim(string(ret,format='(F20.3)'),2)
 return, ret
end
;===========================================================================



