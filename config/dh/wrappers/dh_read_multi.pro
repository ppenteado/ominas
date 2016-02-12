;=============================================================================
; dh_read_multi.pro
;
;=============================================================================
function dh_read_multi, filename, label, udata, dim, type, $
                          silent=silent, sample=sample, nodata=nodata
; tag_list_set, udata, 'DETACHED_HEADER', $
;               dh_read(dh_fname(filename), silent=silent)

 data = read_multi(filename, silent=silent, nodata=nodata, dim=dim, type=type)

 return, data
end
;=============================================================================
