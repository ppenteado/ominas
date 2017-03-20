;=============================================================================
; dh_read_tdl.pro
;
;=============================================================================
function dh_read_tdl, dd, label, dim, type, min, max, abscissa=abscissa, $
                          nodata=nodata, gff=gff, $
                          sample=sample, returned_samples=returned_samples

 if(keyword_set(sample)) then return, 0
 filename = dat_filename(dd)

 data = read_tdl(filename, label, nodata=nodata, $
                                   get_nl=nl, get_ns=ns, get_nb=nb, type=type)
 dim = degen_array([ns, nl, nb])
min=0
max=0

 return, data
end
;=============================================================================
