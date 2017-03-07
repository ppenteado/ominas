;=============================================================================
; dh_write_occ.pro
;
;=============================================================================
pro dh_write_occ, dd, nodata=nodata

 if(keyword_set(nodata)) then return

 filename = dat_filename(dd)
 label = dat_header(dd)
 data = dat_data(dd)


; dsk_pts = tag_list_get(udata, 'DISK_PTS')
 dsk_pts = cor_udata(dd, 'DISK_PTS')

 dn = transpose(data[1,*])
 rad = transpose(data[0,*])
 lon = dsk_pts[*,1]
 times = dblarr(n_elements(dn))

 write_occ, filename, times, dn, rad, lon
end
;=============================================================================
