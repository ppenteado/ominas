;=============================================================================
; dh_read_occ.pro
;
;=============================================================================
function dh_read_occ, dd, label, dim, type, min, max, abscissa=abscissa, $
                          nodata=nodata, gff=gff, $
                          sample=sample, returned_samples=returned_samples

 if(keyword_set(sample)) then return, 0
 filename = dat_filename(dd)

min=0
max=0
 read_occ, filename, label, disk_pts=disk_pts, $
                     sample=sample, nodata=nodata, $
                     time_offset=time_offset, time_units=time_units, $
                     times=times, dn=dn, rad=rad, lon=lon, dim=_dim, type=type
 dim = _dim[1]
 if(keyword_set(nodata)) then return, 0

 n = n_elements(times)

 result = transpose(dn)
 abscissa = transpose(rad)

 disk_pts = dblarr(n,3)
 disk_pts[*,0] = rad
 disk_pts[*,1] = lon

 cor_set_udata, dd, 'DISK_PTS', disk_pts
 cor_set_udata, dd, 'TIME_OFFSET', time_offset
 cor_set_udata, dd, 'TIME_UNITS', time_units
 cor_set_udata, dd, 'TIMES', times

 return, result
end
;=============================================================================
