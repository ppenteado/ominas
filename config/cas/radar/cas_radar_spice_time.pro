;===========================================================================
; cas_radar_spice_time
;
;  Returns ET of center of observation
;
;===========================================================================
function cas_radar_spice_time, label

 startt = pdspar(label, 'START_TIME')
 endt = pdspar(label, 'STOP_TIME')

 if(strmid(startt,strlen(startt)-1,1) EQ 'Z') then $
	                startt = strmid(startt,0,strlen(startt)-1)
 if(strmid(endt,strlen(startt)-1,1) EQ 'Z') then $
	                startt = strmid(startt,0,strlen(startt)-1)

 return, mean([spice_str2et(startt), spice_str2et(endt)])
end
;===========================================================================



