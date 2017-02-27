;=============================================================================
; dh_read_tdl.pro
;
;=============================================================================
function dh_read_tdl, filename, label, udata, dim, type, min, max, abscissa=abscissa, $
                          silent=silent, nodata=nodata, gff=gff, $
                          sample=sample, returned_samples=returned_samples

 if(keyword_set(sample)) then return, 0

 tag_list_set, udata, 'DETACHED_HEADER', $
               dh_read(dh_fname(filename), silent=silent)

 data = read_tdl(filename, label, silent=silent, nodata=nodata, $
                                   get_nl=nl, get_ns=ns, get_nb=nb, type=type)
 dim = degen_array([ns, nl, nb])
min=0
max=0

 return, data
end
;=============================================================================
