;=============================================================================
;+
; NAME:
;       get_ring_profile
;
;
; PURPOSE:
;       Generates a ring profile in radius or longitude.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = get_ring_profile(image, cd, dkd, lon, rad)
;
; ARGUMENTS:
;  INPUT:
;           image:      The image to scan
;
;              cd:      Camera descriptor
;
;             dkd:      Disk descriptor
;
;             lon:      Array of longitudes at which to sample image
;
;             rad:      Array of radii at which to sample image
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;  INPUT:
;       azimuthal:      If set, a longitudinal scan is done instead.
;
;  OUTPUT:
;       NONE
;
;
; RETURN:
;       An array of averaged dn values that match the given rad or
;       match the given lon if /azimuthal selected.
;
;
; PROCEDURE:
;       The profile is calculated by applying a grid of (radius, longitude)
;       given by rad and lon on a ring sector, interpolating the dn in
;       the image, and averaging along a direction to give a radius profile,
;       or a longitudinal profile.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Haemmerle, 6/1998
;
;-
;=============================================================================
function get_ring_profile, image, cd, dkd, lon_pts, rad_pts, $
           azimuthal=azimuthal, $
           interp=interp, im_pts=im_pts, dx=dx, dsk_pts=dsk_pts, $
           sigma=sigma, width=width, nn=nn, arg_interp=arg_interp


 s = size(rad_pts)
 n_rad = s[1]
 n_lon = s[2]
 n_points = n_elements(rad_pts)

 ;-------------------------------
 ; convert to image coordinates
 ;-------------------------------
 if(NOT keyword_set(im_pts)) then $ 
  begin
   rp_pts = dblarr(n_points,3)
   rp_pts[*,0] = rad_pts
   rp_pts[*,1] = lon_pts

   im_pts = disk_to_image(cd, dkd, rp_pts)
  end


 ;---------------------------------------------------------
 ; general method, but assumes uniform delta 
 ;---------------------------------------------------------
 if(keyword_set(dx)) then $
  begin
   grid_x = reform(im_pts[0,*])
   grid_y = reform(im_pts[1,*])
   val = image_interp_cam(cd=cd, image, grid_x, grid_y, interp=interp)

   if(keyword_set(azimuthal)) then h = histogram(lon_pts, rev=ii, bin=dx) $
   else h = histogram(rad_pts, rev=ii, bin=dx)

   nh = n_elements(h)
   profile = dblarr(nh)
   dsk_pts = dblarr(nh,3)
   sigma = dblarr(nh)
   width = (nn = h)
   keep = bytarr(nh)
   for i=0, nh-1 do $
    begin
     sub = -1
     if(ii[i] NE ii[i+1]) then sub = ii[ii[i]:ii[i+1]-1]
     if(n_elements(sub) GT 1) then $
      begin
       profile[i] = total(val[sub])/h[i]
       dsk_pts[i,0] = total(rad_pts[sub])/h[i]
       dsk_pts[i,1] = total(lon_pts[sub])/h[i]
       sigma[i] = stdev(val[sub])
       keep[i] = 1
      end
    end   

   w = where(keep)
   if(w[0] EQ -1) then return, 0

   profile = profile[w]
   width = width[w]
   nn = nn[w]
   sigma = sigma[w]
   dsk_pts = dsk_pts[w,*]
  end $
 ;---------------------------------------------------------
 ; better method when using lines of constant radius
 ;---------------------------------------------------------
 else $
  begin
   grid_x = reform(im_pts[0,*], n_rad, n_lon, /overwrite)
   grid_y = reform(im_pts[1,*], n_rad, n_lon, /overwrite)

   s = size(image)
   ww = where((grid_x LT 0) OR (grid_x GE s[1]) $
               OR (grid_y LT 0) OR (grid_y GE s[2]))
;plots, grid_x, grid_y, psym=3

   strip = image_interp_cam(cd=cd, image, grid_x, grid_y, arg_interp, interp=interp)

   if(keyword_set(azimuthal)) then $
    begin
     nn = make_array(n_lon, val=n_rad)
     width = sqrt((grid_x[0,*]-grid_x[n_rad-1,*])^2 + $
                              (grid_y[0,*]-grid_y[n_rad-1,*])^2)

     weight = intarr(n_rad,n_lon)+1
     if(ww[0] NE -1) then weight[ww] = 0
     weight = total(weight, 1)

     profile = total(strip, 1)/weight
     pp = profile ## make_array(n_rad,val=1d)
     sigma = sqrt(total((strip-pp)^2,1)/((weight-1d)>1))
    end $
   else $
    begin
     nn = make_array(n_rad, val=n_lon)
     width = sqrt((grid_x[*,0]-grid_x[*,n_lon-1])^2 + $
                              (grid_y[*,0]-grid_y[*,n_lon-1])^2)

     weight = intarr(n_rad,n_lon)+1
     if(ww[0] NE -1) then weight[ww] = 0
     weight = total(weight, 2)

     profile = total(strip, 2)/weight
     pp = profile # make_array(n_lon,val=1d)
     sigma = sqrt(total((strip-pp)^2,2)/((weight-1d)>1))
    end

   if(keyword_set(azimuthal)) then $
    begin
     dsk_pts = dblarr(n_lon,3)
     dsk_pts[*,0] = total(rad_pts,1)/n_rad
     dsk_pts[*,1] = lon_pts[0,*]
    end $
   else $
    begin
     dsk_pts = dblarr(n_rad,3)
     dsk_pts[*,0] = rad_pts[*,0]
     dsk_pts[*,1] = total(lon_pts,2)/n_lon
    end

  end

 return, profile
end
;===========================================================================



