;=============================================================================
; dh_read_w10n_pds.pro
;
;=============================================================================
function dh_read_w10n_pds, dd, label, dim, type, min, max, abscissa=abscissa, $
                          nodata=nodata, gff=gff, $
                          sample=sample, returned_samples=returned_samples

 if(keyword_set(sample)) then return, 0
 url = dat_filename(dd)

 ;-----------------------------------------------------------------------
 ; min , max set to zero because no way to determine without reading
 ; entire data array
 ;-----------------------------------------------------------------------
 min=0
 max=0

 ;-----------------------------------------------------------------------
 ; read data array, subject to /nodata
 ;-----------------------------------------------------------------------
 data = read_w10n_pds(url, label, nodata=nodata, dim=dim, /silent)

 return, data
end
;=============================================================================
