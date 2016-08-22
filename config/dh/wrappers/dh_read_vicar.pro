;=============================================================================
; dh_read_vicar.pro
;
;=============================================================================
function dh_read_vicar, filename, label, udata, dim, type, min, max, abscissa=abscissa, $
                          silent=silent, sample=sample, nodata=nodata, gff=gff
 tag_list_set, udata, 'DETACHED_HEADER', $
               dh_read(dh_fname(filename), silent=silent)

 ;-----------------------------------------------------------------------
 ; min , max set to zero because no way to determine without reading
 ; entire data array
 ;-----------------------------------------------------------------------
 min=0
 max=0

 ;-----------------------------------------------------------------------
 ; read data array, subject to /nodata
 ;-----------------------------------------------------------------------
 data = read_vicar(filename, label, silent=silent, nodata=nodata, $
                                     get_nl=nl, get_ns=ns, get_nb=nb, type=type)
 dim = degen_array([ns, nl, nb])

 ;-----------------------------------------------------------------------
 ; construct generic file format descriptor
 ;-----------------------------------------------------------------------
 lblsize = long(vicgetpar(label, 'LBLSIZE'))
 nlb = vicgetpar(label, 'NLB')
 nbb = vicgetpar(label, 'NBB')

 elm_size = sizeof(type, /type)
 bh_size = ((dim[0]*elm_size) + nbb)*nlb

 file_offset = lblsize + bh_size

 data_offset = lonarr(n_elements(dim))
 data_offset[0] = nbb/elm_size

 gff = gff_create(filename[0], dim, type, $
         file_offset=file_offset, data_offset=nd_to_w(dim, data_offset))


 return, data
end
;=============================================================================
