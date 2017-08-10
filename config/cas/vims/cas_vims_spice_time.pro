;===========================================================================
; cas_vims_spice_time
;
;===========================================================================
function cas_vims_spice_time, label, dt=dt, string=string, status=status,startjd=startjd,endjd=endjd

 status = -1

 start_time=pp_get_label_value(label,'START_TIME')
 if(NOT keyword_set(start_time)) then return, -1d100
 status = 0

 close_time=pp_get_label_value(label,'STOP_TIME')
 ;close_time = vicgetpar(label, 'IMAGE_TIME')
 if(strmid(close_time,strlen(close_time)-1,1) EQ 'Z') then $
                 close_time = strmid(close_time,0,strlen(close_time)-1)
 ;exposure = vicgetpar(label, 'EXPOSURE_DURATION')/1000d
 endjd=julday(1,strmid(close_time,5,3),strmid(close_time,0,4),$
  strmid(close_time,9,2),strmid(close_time,12,2),strmid(close_time,15,6))
  startjd=julday(1,strmid(start_time,5,3),strmid(start_time,0,4),$
  strmid(start_time,9,2),strmid(start_time,12,2),strmid(start_time,15,6))
  exposure=endjd-startjd
 exposure*=86400d0
 dt = -0.5d*exposure
 nv_message,verb=0.91,'VIMS START_TIME='+strtrim(start_time,2)
 return, close_time
end
;===========================================================================



