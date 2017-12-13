;=============================================================================
; dh_read_fits.pro
;
;=============================================================================
function dh_read_fits, dd, label, dim, type, min, max, abscissa=abscissa, $
                          nodata=nodata, gff=gff, $
                          sample=sample, returned_samples=returned_samples

 if(keyword_set(sample)) then return, 0
 filename = dat_filename(dd)

 return, read_fits(filename, label, silent=silent, nax=dim, type=type)
end
;=============================================================================
