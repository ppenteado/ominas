;=============================================================================
;+
; NAME:
;       get_ring_profile_bin
;
;
; PURPOSE:
;       Generates a ring profile in radius or longitude using binning.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = get_ring_profile_bin(image, cd, dkd, dlon, rad)
;
; ARGUMENTS:
;  INPUT:
;           image:      The image to scan
;
;              cd:      Camera descriptor
;
;             dkd:      Disk descriptor
;
;            dlon:      Array of disk longitudes of which to sample image
;
;             rad:      Array of disk radii of which to sample image
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
;       match the given dlon if /azimuthal selected.
;
;
; PROCEDURE:
;       A ring sector polygon is calculated from the given dlon and rad
;       arrays.  All the pixels of the image within this polygon are
;       binned in an equally-spaced histogram in radius or longitude.
;
; RESTRICTIONS:
;       The dlon and rad arrays are treated as equally spaced, that is,
;       the binsize is calculated by dividing the spacing in radius by
;       number of points minus one.
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
function get_ring_profile_bin, image, cd, dkd, lon_pts, rad_pts, $
                 slope=slope, azimuthal=azimuthal

 if(NOT keyword__set(slope)) then slope = 0d

 s = size(rad_pts)
 n_rad = s[1]
 n_lon = s[2]
 n_points = n_elements(rad_pts)

 rad = rad_pts[*,0]
 lon = lon_pts[0,*]

 rp_pts = dblarr(n_points,3)
 rp_pts[*,0] = rad_pts
 rp_pts[*,1] = lon_pts

 ;-------------------------------
 ; convert to image coordinates
 ;-------------------------------
 inertial = bod_body_to_inertial_pos(dkd, $
              dsk_disk_to_body(dkd, rp_pts))

 im_pts = cam_focal_to_image(cd, $
            cam_body_to_focal(cd, $
              bod_inertial_to_body_pos(cd, inertial)))

 ;-----------------------
 ; get data within sector
 ;-----------------------
 ; Calculate subs of im_pts
 outline_subs = im_pts[1,*,0]*s[1] + im_pts[0,*,0]
 outline_subs = reform(outline_subs,n_elements(outline_subs),/overwrite)

; subs = polyfillv(im_pts[0,*,0],im_pts[1,*,0],s[1],s[2])
 subs = poly_fillv(im_pts, s)
;print, 'number of points in sector according to polyfillv ',n_elements(subs)
 subs = [subs,outline_subs]
;print, 'number of points in sector including outline ',n_elements(subs)

 image_points=intarr(2,n_elements(subs))
 image_points[0,*] = subs mod s[1]
 image_points[1,*] = subs/s[1]
 image_data = image(subs)

 plane_pts = image_to_disk(cd, dkd, image_points)

 ;-----------------------------
 ; bin according to rad or lon
 ;-----------------------------
 if(keyword__set(azimuthal)) then $
  begin
   lon_pts = plane_pts[*,1,*]
   binsize = (lon[n_lon-1]-lon[0])/(n_lon-1d)
   min = lon[0]-0.5d*binsize
   max = lon[n_lon-1]+0.49999d*binsize
   w = where(lon_pts LT min, count)            ; Fix for wrap-around at pi
   if(count NE 0) then lon_pts[w] = lon_pts[w] + 2d*!dpi
   hist = histogram(lon_pts, min=min, $
           max=max, $
           binsize=binsize, reverse_indices=R)
;;   print, 'min ',min
;;   print, 'max ',max
;;   print, 'binsize ',binsize
;;   print, (max-min)/binsize
;   print, 'points in hist ',total(hist)
;   print, 'number of bins ',n_elements(hist)
;;   print, 'n_lon ',n_lon
  end $
 else $
  begin
   rad_pts = plane_pts[*,0,*]
   binsize=(rad[n_rad-1]-rad[0])/(n_rad-1d)
   min = rad[0]-0.5d*binsize
   max = rad[n_rad-1]+0.49999d*binsize
   hist = histogram(rad_pts, min=min, $
           max=max, $
           binsize=binsize, reverse_indices=R)
;;   print, 'min ',min
;;   print, 'max ',max
;;   print, 'binsize ',binsize
;;   print, (max-min)/binsize
;   print, 'points in hist ',total(hist)
;   print, 'number of bins ',n_elements(hist)
;;   print, 'n_rad ',n_rad
  end

;window, /free, xs=500, ys=300
;plot, hist

;  print, 'number of elements in reverse indices array ',n_elements(R)

  ;-------------------
  ; sum pixels in bins
  ;-------------------
  n_hist = n_elements(hist)
  sum = dblarr(n_hist) 
  for i=0, n_hist-1 do $
   begin
    if(R[i] NE R[i+1]) then sum[i] = total(image_data[ R[R[i]:R[i+1]-1] ])
   end
;print, 'number of elements in sum array ', n_elements(sum)
  w = where(hist EQ 0, count)
;print, 'zero pixels in bin ', w
  hist = hist > 1
  result = sum/hist

  ;--------------------------------------------
  ; fix paradoxical cases with no values in bin
  ;--------------------------------------------
  if(count NE 0) then $
   begin
    for i=0,count-1 do $ 
     if(w[i] EQ 0) then $
      result[0] = result[1] $
     else $
     if(w[i] EQ n_hist-1) then $
      result[n_hist-1] = result[n_hist-2] $
     else $
      result[w[i]] = (result[w[i]-1] + result[w[i]+1])/2d
   end

 return, result
end
;===========================================================================



