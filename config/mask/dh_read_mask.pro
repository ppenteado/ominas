;=============================================================================
; dh_read_mask.pro
;
;=============================================================================
function dh_read_mask, filename, header, udata, dim, type, min, max, abscissa=abscissa, $
                          silent=silent, nodata=nodata, gff=gff, $
                          sample=sample, returned_samples=returned_samples

 if(keyword_set(sample)) then return, 0

; tag_list_set, udata, 'DETACHED_HEADER', $
;               dh_read(dh_fname(filename), silent=silent)

 data = read_mask(filename, header=header, dim=dim, type=type)
min=0
max=0

 return, data
end
;=============================================================================
