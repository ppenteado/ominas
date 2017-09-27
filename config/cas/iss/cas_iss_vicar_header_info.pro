;===========================================================================
; cas_iss_vicar_header_info
;
;===========================================================================
function cas_iss_vicar_header_info, dd

 meta = {cas_iss_spice_label_struct}

 label = dat_header(dd)
 if(NOT keyword_set(label)) then return, 0

 ;-----------------------------------
 ; time
 ;-----------------------------------
 meta.time = cas_iss_spice_time(label)

 ;-----------------------------------
 ; exposure time
 ;-----------------------------------
 meta.exposure = vicgetpar(label, 'EXPOSURE_DURATION')/1000d

 ;-----------------------------------
 ; image size
 ;-----------------------------------
 meta.size[0] = double(vicgetpar(label, 'NS'))
 meta.size[1] = double(vicgetpar(label, 'NL'))

 ;-----------------------------------
 ; filters
 ;-----------------------------------
 meta.filters = vicgetpar(label, 'FILTER_NAME')

 ;-----------------------------------
 ; target
 ;-----------------------------------
 target_name = strupcase(vicgetpar(label, 'TARGET_NAME'))
 target_desc = strupcase(vicgetpar(label, 'TARGET_DESC') )
 meta.target = target_name
 obs_id = vicgetpar(label, 'OBSERVATION_ID')
 if((strpos(strupcase(obs_id), 'OPNAV'))[0] NE -1) then meta.target = target_desc

 ;-----------------------------------
 ; optic axis
 ;-----------------------------------
 meta.oaxis = meta.size/2d

 return, meta
end 
;===========================================================================



