;=============================================================================
; dh_write_multi.pro
;
;=============================================================================
pro dh_write_multi, dd, filename, data, header, abscissa=abscissa, nodata=nodata

 if(keyword_set(nodata)) then return

 if(NOT keyword_set(filename)) then filename = dat_filename(dd)
 if(NOT keyword_set(label)) then label = dat_header(dd)
 if(NOT keyword_set(data)) then data = dat_data(dd, abscissa=_abscissa)
 if(NOT keyword_set(abscissa)) then abscissa = _abscissa

 write_multi, filename, data
end
;=============================================================================
