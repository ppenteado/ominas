;=============================================================================
; dh_write_fits.pro
;
;=============================================================================
pro dh_write_fits, dd, filename, data, header, abscissa=abscissa, nodata=nodata

 if(keyword_set(nodata)) then return

 if(NOT keyword_set(filename)) then filename = dat_filename(dd)
 if(NOT keyword_set(header)) then header = dat_header(dd)
 if(NOT keyword_set(data)) then data = dat_data(dd, abscissa=_abscissa)
 if(NOT keyword_set(abscissa)) then abscissa = _abscissa

 write_fits, filename, data, header, /silent
end
;=============================================================================
