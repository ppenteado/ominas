;=============================================================================
; dh_read_ext.pro
;
;=============================================================================
function dh_read_ext, filename, label, udata, dim, type, $
                          silent=silent, sample=sample, nodata=nodata
 tag_list_set, udata, 'DETACHED_HEADER', $
               dh_read(dh_fname(filename), silent=silent)
 return, read_ext(filename, label, silent=silent, dim=dim, type=type)
end
;=============================================================================
