;=============================================================================
; dh_write_tdl.pro
;
;=============================================================================
pro dh_write_tdl, dd, nodata=nodata

 if(keyword_set(nodata)) then return

 filename = dat_filename(dd)
 label = dat_header(dd)
 data = dat_data(dd)

 write_tdl, filename, data, label
end
;=============================================================================
