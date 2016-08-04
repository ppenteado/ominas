;=============================================================================
; dh_read_fits.pro
;
;=============================================================================
function dh_read_fits, filename, label, udata, dim, type, min, max, abscissa=abscissa, $
                          silent=silent, sample=sample, nodata=nodata
 tag_list_set, udata, 'DETACHED_HEADER', $
               dh_read(dh_fname(filename), silent=silent)
min=0
max=0
 return, read_fits(filename, label, silent=silent, nax=dim, type=type)
end
;=============================================================================
