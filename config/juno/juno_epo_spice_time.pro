;===========================================================================
; juno_epo_spice_time
;
;  Returns ET of center of observation
;  dt returns offset applied from shutter close
;
;===========================================================================
function juno_epo_spice_time, dd, dt=dt, string=string, status=status

 status = -1
 
 h=dat_header(dd)
 if ~h.haskey('START_TIME') then return,!values.d_nan
 status=0
 if(keyword_set(string)) then return, h['START_TIME']
 cspice_str2et,h['START_TIME'],et
 et=et+60./1000
 expoms=strsplit(h['EXPOSURE_DURATION'],' ',/EXTRACT)
 expos=double(expoms[0])/1000
 time=et+expos/2
 status = 0

 dt = expos/2d0
 return, time
end
;===========================================================================



