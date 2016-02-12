;=============================================================================
; dh_read_fits.pro
;
;=============================================================================
function dh_read_fits, filename, label, udata, dim, type, $
                          silent=silent, sample=sample, nodata=nodata
 tag_list_set, udata, 'DETACHED_HEADER', $
               dh_read(dh_fname(filename), silent=silent)
 return, read_fits(filename, label, silent=silent, nax=dim, type=type)
end
;=============================================================================
