;=============================================================================
; dh_write_vicar.pro
;
;=============================================================================
pro dh_write_vicar, dd, nodata=nodata

 if(keyword_set(nodata)) then return

 filename = dat_filename(dd)
 label = dat_header(dd)
 data = dat_data(dd)

 write_vicar, filename, data, label, /silent
end
;=============================================================================
