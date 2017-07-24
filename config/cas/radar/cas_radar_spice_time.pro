;===========================================================================
; cas_radar_spice_time
;
;  Returns ET of center of observation
;
;===========================================================================
function cas_radar_spice_time, label, dt=dt, string=string, status=status

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



