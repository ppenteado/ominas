;=============================================================================
; dh_write_tdl.pro
;
;=============================================================================
pro dh_write_tdl, dd, filename, data, header, abscissa=abscissa, nodata=nodata

 if(keyword_set(nodata)) then return
 if(defined(abscissa)) then nv_message, /warning, 'Abscissa not supported.'

 if(NOT keyword_set(filename)) then filename = dat_filename(dd)
 if(NOT keyword_set(label)) then label = dat_header(dd)
 if(NOT keyword_set(data)) then data = dat_data(dd, abscissa=_abscissa)
 if(NOT keyword_set(abscissa)) then abscissa = _abscissa

 write_tdl, filename, data, label
end
;=============================================================================




;=============================================================================
; dh_write_tdl.pro
;
;=============================================================================
function dh_write_tdl, dd, filename, nodata=nodata, sample=sample, status=status
 
 if(keyword_set(nodata)) then return, 0
 if(defined(sample)) then return, -1

 filename = dat_filename(dd)
 if(NOT keyword_set(filename)) then filename = dat_filename(dd)

 label = dat_header(dd)
 data = dat_data(dd)
 abscissa = dat_abscissa(dd)

 if(defined(abscissa)) then nv_message, /warning, $
                           'Abscissa not supported; writing data array only.'

 write_tdl, filename, data, label
 return, 0
end
;=============================================================================
