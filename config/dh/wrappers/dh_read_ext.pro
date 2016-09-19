;=============================================================================
; dh_read_ext.pro
;
;=============================================================================
function dh_read_ext, filename, label, udata, dim, type, min, max, abscissa=abscissa, $
                          silent=silent, sample=sample, nodata=nodata, gff=gff
 tag_list_set, udata, 'DETACHED_HEADER', $
               dh_read(dh_fname(filename), silent=silent)
min=0
max=0
 return, read_ext(filename, label, silent=silent, dim=dim, type=type)
end
;=============================================================================
