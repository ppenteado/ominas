;=============================================================================
; dh_write_occ.pro
;
;=============================================================================
pro dh_write_occ, dd, filename, data, header, abscissa=abscissa, nodata=nodata

 if(keyword_set(nodata)) then return

 if(NOT keyword_set(filename)) then filename = dat_filename(dd)
 if(NOT keyword_set(label)) then label = dat_header(dd)
 if(NOT keyword_set(data)) then data = dat_data(dd, abscissa=_abscissa)
 if(NOT keyword_set(abscissa)) then abscissa = _abscissa


 dsk_pts = cor_udata(dd, 'DISK_PTS')

 dn = transpose(data[1,*])
 rad = transpose(data[0,*])
 lon = dsk_pts[*,1]
 times = dblarr(n_elements(dn))

 write_occ, filename, times, dn, rad, lon
end
;=============================================================================
