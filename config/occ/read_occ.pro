;=============================================================================
; read_occ.pro
;
;=============================================================================
pro read_occ, filename, label, disk_pts=disk_pts, $
                   silent=silent, sample=sample, nodata=nodata, $
                   time_offset=time_offset, time_units=time_units, $
                   times=times, dn=dn, rad=rad, lon=lon, dim=dim, type=type

 data = read_vicar(filename, label, silent=silent, nodata=nodata, $
                                   get_nl=nl, get_ns=ns, get_nb=nb, type=type)
 dim = degen_array([ns, nl, nb])
 if(keyword_set(nodata)) then return

 s = size(data)

 time_offset = vicgetpar(label, 'TIME_OFFSET')
 time_units = vicgetpar(label, 'TIME_UNITS')

 if(NOT keyword_set(time_offset)) then time_offset = 0d
 if(NOT keyword_set(time_units)) then time_units = 1d

 times = (data[0,*] + time_offset) * time_units
 dn = data[1,*]
 if(s[2] GT 2) then rad = data[2,*]
 if(s[2] GT 3) then lon = data[3,*]

end
;=============================================================================
