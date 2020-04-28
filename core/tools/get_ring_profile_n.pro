;=============================================================================
;+
; NAME:
;       get_ring_profile_n
;
;
; PURPOSE:
;       Calculate the number of points in radius and longitude for
;       a ring profile.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = get_ring_profile_n(outline_pts, cd, dkd, lon, rad)
;
;
; ARGUMENTS:
;  INPUT:
;       outline_pts:    Outline sector image points which are the result
;                       of calling get_ring_profile_outline()
;
;                cd:    Camera descriptor
;
;               dkd:    Disk descriptor
;
;              lon:    Equally spaced longitude array
;
;               rad:    Equally spaced radius array
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;  INPUT:
;          oversamp:    Oversample factor compared to regular calculation of
;                       radius and longitude spacing which would put maximum
;                       spacing at 1 pixel.
;
;  OUTPUT:
;       NONE
;
;
; RETURN:
;       Array containg n_rad and n_lon to be used by get_ring_profile() or
;       get_ring_profile_bin().
;
;
; PROCEDURE:
;       Routine goes along the radial and longitudinal edges of a ring
;       profile sector and calculates the minimum spacing between the
;       points in image space, then derives the n_rad and n_lon points
;       to make the minimum spacing 1 pixel.  If the oversamp parameter
;       is given, the numbers are multiplied by this factor.
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
function get_ring_profile_n, outline_pts, cd, dkd, lon, rad, $
                             oversamp=oversamp

 if(NOT keyword__set(oversamp)) then oversamp=1.
 n_lon = n_elements(lon)
 n_rad = n_elements(rad)
 n_points = 2*n_rad + 2*n_lon

 nextto_dist = sqrt(total((outline_pts-shift(outline_pts,0,1))^2,1))
 across_dist = sqrt(total((outline_pts-shift(outline_pts,0,n_points/2))^2,1))

 ;---------------------------------
 ; determine oversampling n_lon_os
 ;---------------------------------
 delta_lon = [nextto_dist[1:n_lon-1], $
               nextto_dist[n_rad+n_lon+1:n_rad+2*n_lon-1]]
 n_lon_os = long(n_lon*max(delta_lon)*oversamp+1)

 ;--------------------------------------------------
 ; find lon at max sector width in radius direction 
 ;--------------------------------------------------
 delta_sector_rad = across_dist[1:n_lon-1]
 w = where(delta_sector_rad EQ max(delta_sector_rad))
 max_lon = lon(w[0]+1)

 rp_pts = dblarr(n_rad,3)
 rp_pts[*,0] = rad
 rp_pts[*,1] = max_lon

 ;-------------------------------
 ; convert to image coordinates
 ;-------------------------------
 inertial = bod_body_to_inertial_pos(dkd, $
              dsk_disk_to_body(dkd, rp_pts))

 im_pts = cam_focal_to_image(cd, $
            cam_body_to_focal(cd, $
              bod_inertial_to_body_pos(cd, inertial)))

 nextto_dist = sqrt(total((im_pts-shift(im_pts,0,1,0))^2,1))

 ;---------------------------------
 ; determine oversampling n_rad_os
 ;---------------------------------
 delta_rad = nextto_dist[1:n_rad-1]
 n_rad_os = long(n_rad*max(delta_rad)*oversamp+1)

 return, [n_lon_os,n_rad_os]
end
;===========================================================================
