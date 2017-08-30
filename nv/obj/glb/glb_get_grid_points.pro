;===========================================================================
; glb_get_grid_points.pro
;
;  Returns vectors in body coordinates.
;
;  lat,lon are the desired grid lines of const. lat, lon.
;
;  scan_lat, scan_lon are the lats, lons over which to scan for each 
;  grid line.
;
;  This routine is obsolete.  Use map_get_grid_points instead.
;
;===========================================================================
function glb_get_grid_points, gbd, lat=lat, lon=lon, $
                                 scan_lat=scan_lat, scan_lon=scan_lon
@core.include
 
           
 nt = n_elements(gbd)
 Mt = make_array(nt, val=1)

 nplat = n_elements(scan_lat)
 nplon = n_elements(scan_lon)

 ;==============================
 ; generate latitude circles
 ;==============================
 nlat = n_elements(lat)
 np = nplon*nlat
 if(nlat GT 0) then $
  begin
   lats = reform([lat] # $
                     make_array(nplon, val=1), nlat*nplon, /overwrite)#Mt
   lons = reform([scan_lon]##make_array(nlat, val=1), nlat*nplon, /overwrite)#Mt

   rlat_surface = tr([tr(lats), tr(lons), dblarr(1,np)])
   rlat_body = glb_globe_to_body(gbd, rlat_surface)
  end


 ;==============================
 ; generate longitude circles
 ;==============================
 nlon = n_elements(lon)
 np = nplat*nlon
 if(nlon GT 0) then $
  begin
   lons = reform([lon] # $
                      make_array(nplat, val=1), nlon*nplat, /overwrite)#Mt
   lats = reform([scan_lat]##make_array(nlon, val=1), nlon*nplat, /overwrite)#Mt

   rlon_surface = tr([tr(lats), tr(lons), dblarr(1,np)])
   rlon_body = glb_globe_to_body(gbd, rlon_surface)
  end


 ;==================================
 ; Combine the results and return.
 ;==================================
 rgrid_body = dblarr(nlat*nplon + nlon*nplat,3,nt)
 if(nlat GT 0) then rgrid_body[0:nlat*nplon-1,*,*] = rlat_body
 if(nlon GT 0) then rgrid_body[nlat*nplon:*,*,*] = rlon_body

 return, rgrid_body
end
;===========================================================================
