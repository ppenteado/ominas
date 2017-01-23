;=============================================================================
; dh_read_mask.pro
;
;=============================================================================
function dh_read_mask, filename, header, udata, dim, type, min, max, abscissa=abscissa, $
                          silent=silent, sample=sample, nodata=nodata, gff=gff
; tag_list_set, udata, 'DETACHED_HEADER', $
;               dh_read(dh_fname(filename), silent=silent)

 data = read_mask(filename, header=header, dim=dim, type=type)
min=0
max=0

 return, data
end
;=============================================================================
