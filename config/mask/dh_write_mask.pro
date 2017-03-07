;=============================================================================
; dh_write_mask.pro
;
;=============================================================================
pro dh_write_mask, dd, nodata=nodata

 if(keyword_set(nodata)) then return

 filename = dat_filename(dd)
 header = dat_header(dd)
 data = dat_data(dd)

 write_mask, filename, data, header
end
;=============================================================================
