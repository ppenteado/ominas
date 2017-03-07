;=============================================================================
; dh_write_fits.pro
;
;=============================================================================
pro dh_write_fits, dd, nodata=nodata

 if(keyword_set(nodata)) then return

 filename = dat_filename(dd)
 header = dat_header(dd)
 data = dat_data(dd)

 write_fits, filename, data, header, /silent
end
;=============================================================================
