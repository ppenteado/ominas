;=============================================================================
; dh_read_occ.pro
;
;=============================================================================
function dh_read_occ, filename, label, udata, dim, type, abscissa=abscissa, $
                   silent=silent, sample=sample, nodata=nodata
 tag_list_set, udata, 'DETACHED_HEADER', $
               dh_read(dh_fname(filename), silent=silent)

 read_occ, filename, label, disk_pts=disk_pts, $
                     silent=silent, sample=sample, nodata=nodata, $
                     time_offset=time_offset, time_units=time_units, $
                     times=times, dn=dn, rad=rad, lon=lon, dim=_dim, type=type
 dim = [2,_dim[1]]
 if(keyword_set(nodata)) then return, 0

 n = n_elements(times)

; result = [times, dn]
 result = [rad, dn]
 disk_pts = dblarr(n,3)
 disk_pts[*,0] = rad
 disk_pts[*,1] = lon

 tag_list_set, udata, 'DISK_PTS', disk_pts
 tag_list_set, udata, 'TIME_OFFSET', time_offset
 tag_list_set, udata, 'TIME_UNITS', time_units
 tag_list_set, udata, 'TIMES', times

 return, result
end
;=============================================================================
