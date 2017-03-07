;=============================================================================
; dh_write_multi.pro
;
;=============================================================================
pro dh_write_multi, dd, nodata=nodata

 if(keyword_set(nodata)) then return

 filename = dat_filename(dd)
 label = dat_header(dd)
 data = dat_data(dd)

 write_multi, filename, data
end
;=============================================================================
