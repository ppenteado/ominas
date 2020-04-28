;===========================================================================
; vgr_iss_spice_time
;
;  Returns ET of center of observation
;  dt returns offset applied from shutter close
;
;===========================================================================
function vgr_iss_spice_time, dd, dt=dt, string=string, status=status

 status = -1
 meta = dat_header_info(dd)
 if(NOT keyword_set(meta)) then return, -1d100
 status = 0

 dt = meta.dt
 if(keyword_set(string)) then return, meta.stime
 return, meta.time
end
;===========================================================================



