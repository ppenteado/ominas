;===========================================================================
; cas_iss_vicar_header_info
;
;===========================================================================
function cas_iss_vicar_header_info, dd

 ndd = n_elements(dd)

 time = dblarr(ndd)
 exposure = dblarr(ndd)
 size = make_array(2,ndd, val=1024)
 filters = strarr(2,ndd)
 target = strarr(ndd)
 oaxis = dblarr(2,ndd)

 for i=0, ndd-1 do $
  begin
   label = dat_header(dd[i])
   if(keyword_set(label)) then $
    begin
     ;-----------------------------------
     ; time
     ;-----------------------------------
     if(NOT keyword_set(_time)) then time[i] = cas_iss_spice_time(label)

     ;-----------------------------------
     ; exposure time
     ;-----------------------------------
     exposure[i] = vicgetpar(label, 'EXPOSURE_DURATION')/1000d

     ;-----------------------------------
     ; image size
     ;-----------------------------------
     size[0,i] = double(vicgetpar(label, 'NS'))
     size[1,i] = double(vicgetpar(label, 'NL'))

     ;-----------------------------------
     ; filters
     ;-----------------------------------
     filters[*,i] = vicgetpar(label, 'FILTER_NAME')

     ;-----------------------------------
     ; target
     ;-----------------------------------
     target_name = strupcase(vicgetpar(label, 'TARGET_NAME'))
     target_desc = strupcase(vicgetpar(label, 'TARGET_DESC') )
     target[i] = target_name
     obs_id = vicgetpar(label, 'OBSERVATION_ID')
     if((strpos(strupcase(obs_id), 'OPNAV'))[0] NE -1) then target[i] = target_desc
    end

   ;-----------------------------------
   ; optic axis
   ;-----------------------------------
   oaxis[*,i] = size[*,i]/2d
  end

 if(NOT keyword_set(_time)) then _time = time

 return, {time: time, $
          exposure: exposure, $
          size: size, $
          filters: filters, $
          target: target, $
          oaxis: oaxis}
end 
;===========================================================================



