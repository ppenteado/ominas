;===========================================================================
; dsk_get_grid_points.pro
;
; Returns vectors in body coordinates.
;
; This routine is obsolete.  Use map_get_grid_points.
;
;===========================================================================
function dsk_get_grid_points, dkxp, nlpoints, nrpoints, rad=rad, lon=lon, $
                        frame_bd=frame_bd, scan_rad=scan_rad, $
              minlon=lonmin, maxlon=lonmax, minrad=radmin, maxrad=radmax
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')

 if(NOT keyword_set(lonmin)) then lonmin = 0d
 if(NOT keyword_set(lonmax)) then lonmax = 2d*!dpi

 nt = n_elements(dkdp)
 Mt = make_array(nt, val=1)


 ;==============================
 ; generate radius circles
 ;==============================
 n_points = nlpoints
 if(NOT keyword_set(scan_lon)) then $
       scan_lon = dindgen(n_points)/double(n_points)*(lonmax-lonmin) + lonmin

 nrad = n_elements(rad)
 n_points = nlpoints
 np = n_points*nrad

 if(nrad GT 0) then $
  begin
   ;-----------------------------
   ; create initial unit vectors
   ;-----------------------------
   zz = double([0,0,1])##make_array(nrad, val=1)
   init_vectors = double([1,0,0])##make_array(nrad, val=1)

   ;--------------------------
   ; rotate them about z-axis
   ;--------------------------
   vrad_body = v_rotate(init_vectors, zz, [sin(scan_lon)], [cos(scan_lon)])
   vvrad_body = (vrad_body[vecgen(nrad,3,n_points)])[linegen3z(np,3,nt)]

   ;----------------------
   ; make radius vectors
   ;----------------------
   trad = (rad[reform(lindgen(nrad)#make_array(n_points,val=1), np, /over)])#Mt

   rrad_body = dblarr(np,3,nt,/nozero)
   rrad_body[*,0,*] = vvrad_body[*,0,*] * trad
   rrad_body[*,1,*] = vvrad_body[*,1,*] * trad
   rrad_body[*,2,*] = vvrad_body[*,2,*] * trad
  end


 ;==============================
 ; generate longitude lines
 ;==============================
 nlon = n_elements(lon)
 n_points = nrpoints
 np = n_points*nlon
 if(nlon GT 0) then $
  begin
   ;-----------------------------
   ; create initial unit vectors
   ;-----------------------------
   zz = double([0,0,1])##make_array(n_points, val=1)
   init_vectors = double([1,0,0])##make_array(n_points, val=1)

   ;-------------------------------
   ; rotate them about their axes
   ;-------------------------------
   vlon_body = v_rotate(init_vectors, zz, [sin(lon)], [cos(lon)])
   vvlon_body = (vlon_body[vecgen(n_points,3,nlon)])[linegen3z(np,3,nt)]

   ;----------------------
   ; make radius vectors
   ;----------------------
   rads = dsk_get_radius(dkdp, lon, frame_bd)
   sub = (linegen3x(n_points,nt,nlon))[vecgen(n_points,nt,nlon)]

   if(nt EQ 1) then $
    begin
     rads0 = (rads[*,0,*])[sub]
     rads1 = (rads[*,1,*])[sub]
    end $
   else $
    begin
     rads0 = (transpose(rads[*,0,*], [2,0,1]))[sub]
     rads1 = (transpose(rads[*,1,*], [2,0,1]))[sub]
    end
   if(keyword_set(radmin)) then rads0 = rads0 > radmin[sub]
   if(keyword_set(radmax)) then rads1 = rads1 < radmax[sub]

   w = where(rads1-rads0 LE 0)

   p = reform(dindgen(n_points)#make_array(nlon,val=1), np, /over)#Mt
   trad = p*(rads1-rads0)/n_points + rads0
   if(w[0] NE -1) then trad[w] = 0


   rlon_body = dblarr(np,3,nt,/nozero)
   rlon_body[*,0,*] = vvlon_body[*,0,*] * trad
   rlon_body[*,1,*] = vvlon_body[*,1,*] * trad
   rlon_body[*,2,*] = vvlon_body[*,2,*] * trad
  end


 ;==================================
 ; Combine the results and return.
 ;==================================
 rgrid_body = dblarr(nrad*nlpoints+nlon*nrpoints,3,nt)
 if(nrad GT 0) then rgrid_body[0:nrad*nlpoints-1,*,*]=rrad_body
 if(nlon GT 0) then rgrid_body[nrad*nlpoints:*,*,*]=rlon_body

 w = where(v_mag(rgrid_body) NE 0)
 if(w[0] EQ -1) then return, 0
 rgrid_body = rgrid_body[w,*]

 return, rgrid_body
end
;===========================================================================
