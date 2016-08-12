;=============================================================================
; dh_read_multi.pro
;
;=============================================================================
function dh_read_multi, filename, label, udata, dim, type, min, max, abscissa=abscissa, $
                          silent=silent, sample=sample, nodata=nodata
; tag_list_set, udata, 'DETACHED_HEADER', $
;               dh_read(dh_fname(filename), silent=silent)

 data = read_multi(filename, silent=silent, nodata=nodata, dim=dim, type=type)
min=0
max=0

 return, data
end
;=============================================================================
