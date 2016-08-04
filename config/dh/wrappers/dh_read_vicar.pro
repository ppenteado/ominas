;=============================================================================
; dh_read_vicar.pro
;
;=============================================================================
function dh_read_vicar, filename, label, udata, dim, type, min, max, abscissa=abscissa, $
                          silent=silent, sample=sample, nodata=nodata
 tag_list_set, udata, 'DETACHED_HEADER', $
               dh_read(dh_fname(filename), silent=silent)

min=0
max=0

 data = read_vicar(filename, label, silent=silent, nodata=nodata, $
                                     get_nl=nl, get_ns=ns, get_nb=nb, type=type)
 dim = degen_array([ns, nl, nb])

 return, data
end
;=============================================================================
