;===========================================================================
; cas_radar_spice_time
;
;  Returns ET of center of observation
;
;===========================================================================
function __cas_radar_spice_time, label, dt=dt, string=string, status=status

 status = -1
 startt = pdspar(label, 'START_TIME')
 if(NOT keyword_set(startt)) then return, -1d100
 status = 0

 endt = pdspar(label, 'STOP_TIME')

 if(strmid(startt,strlen(startt)-1,1) EQ 'Z') then $
	                startt = strmid(startt,0,strlen(startt)-1)
 if(strmid(endt,strlen(startt)-1,1) EQ 'Z') then $
	                startt = strmid(startt,0,strlen(startt)-1)

 if(keyword_set(string)) then return, endt
 return, mean([spice_str2et(startt), spice_str2et(endt)])
end
;===========================================================================



;===========================================================================
; cas_radar_spice_time
;
;  Returns ET of center of observation
;  dt returns offset applied from shutter close
;
;===========================================================================
function cas_radar_spice_time, dd, dt=dt, string=string, status=status

 status = -1
 meta = dat_header_info(dd)
 if(NOT keyword_set(meta)) then return, -1d100
 status = 0

 dt = meta.dt
 if(keyword_set(string)) then return, meta.stime
 return, meta.time
end
;===========================================================================



