;=============================================================================
; dh_write_occ.pro
;
;=============================================================================
pro dh_write_occ, filename, data, label, udata, abscissa=abscissa, nodata=nodata, silent=silent
 dh_write, dh_fname(filename), tag_list_get(udata, 'DETACHED_HEADER'), silent=silent

 if(keyword_set(nodata)) then return

 dsk_pts = tag_list_get(udata, 'DISK_PTS')

 dn = transpose(data[1,*])
 rad = transpose(data[0,*])
 lon = dsk_pts[*,1]
 times = dblarr(n_elements(dn))

 write_occ, filename, times, dn, rad, lon
end
;=============================================================================
