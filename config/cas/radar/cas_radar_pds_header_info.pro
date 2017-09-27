;===========================================================================
; cas_radar_pds_header_info
;
;===========================================================================
function cas_radar_pds_header_info, dd

 meta = {cas_radar_spice_label_struct}

 label = dat_header(dd)
 if(NOT keyword_set(label)) then return, 0

 ;-----------------------------------
 ; time
 ;-----------------------------------
 meta.time = cas_radar_spice_time(label)

 ;-----------------------------------
 ; target
 ;-----------------------------------
 meta.target = pdspar(label, 'TARGET_NAME')

 return, meta
end 
;===========================================================================



