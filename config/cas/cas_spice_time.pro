;===========================================================================
; cas_spice_time
;
;===========================================================================
function cas_spice_time, label, dt=dt, status=status

 status = 0

 close_time = vicgetpar(label, 'IMAGE_TIME')
 if(strmid(close_time,strlen(close_time)-1,1) EQ 'Z') then $
	                close_time = strmid(close_time,0,strlen(close_time)-1)
 exposure = vicgetpar(label, 'EXPOSURE_DURATION')/1000d

 dt = -0.5d*exposure

 return, close_time
end
;===========================================================================



