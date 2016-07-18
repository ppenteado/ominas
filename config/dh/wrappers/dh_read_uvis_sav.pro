;=============================================================================
; dh_read_uvis_sav.pro
;
;=============================================================================
function dh_read_uvis_sav, filename, label, udata, dim, type, abscissa=abscissa, $
                          silent=silent, sample=sample, nodata=nodata
 udata = dh_read(dh_fname(filename), silent=silent)
 label = ''

 return, read_uvis_sav(filename, nodata=nodata)
end
;=============================================================================
