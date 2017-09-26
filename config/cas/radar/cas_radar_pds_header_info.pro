;===========================================================================
; cas_radar_pds_header_info
;
;===========================================================================
function cas_radar_pds_header_info, dd

 ndd = n_elements(dd)

 time = dblarr(ndd)
 target = strarr(ndd)

 for i=0, ndd-1 do $
  begin
   label = dat_header(dd[i])
   if(keyword_set(label)) then $
    begin
     ;-----------------------------------
     ; time
     ;-----------------------------------
     if(NOT keyword_set(_time)) then time[i] = cas_radar_spice_time(label)

     ;-----------------------------------
     ; target
     ;-----------------------------------
     target[i] = pdspar(label, 'TARGET_NAME')
    end
  end

 if(NOT keyword_set(_time)) then _time = time


 return, {time: time, $
          target: target}
end 
;===========================================================================



