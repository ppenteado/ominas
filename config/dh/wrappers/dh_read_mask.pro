;=============================================================================
; dh_read_mask.pro
;
;=============================================================================
function dh_read_mask, filename, header, udata, dim, type, $
                          silent=silent, sample=sample, nodata=nodata
; tag_list_set, udata, 'DETACHED_HEADER', $
;               dh_read(dh_fname(filename), silent=silent)

 data = read_mask(filename, header=header, dim=dim, type=type)

 return, data
end
;=============================================================================
