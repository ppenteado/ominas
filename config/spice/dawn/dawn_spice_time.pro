;===========================================================================
; dawn_spice_time
;
;===========================================================================
function dawn_spice_time, label, dt=dt, status=status

 status = 0

 close_time = pdspar(label, 'STOP_TIME') 
 if(strmid(close_time,strlen(close_time)-1,1) EQ 'Z') then $
	                close_time = strmid(close_time,0,strlen(close_time)-1)
 exposure = pdspar(label, 'EXPOSURE_DURATION')/1000d

 dt = -0.5d*exposure[0]

 return, close_time[0]
end
;===========================================================================



