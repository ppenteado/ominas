;==============================================================================
; orb_lon_to_body
;
;  Computes body coordinates of body on given orbit at given longitude.
;
;==============================================================================
function orb_lon_to_body, xd, lon, frame_bd=frame_bd

 nt = n_elements(xd)
 nv = n_elements(lon)

 rad = (dsk_get_radius(xd, lon, frame_bd))[*,0,*]
 dsk_pts = dblarr(nv,3,nt)
 dsk_pts[*,0,*] = rad
 dsk_pts[*,1,*] = lon
 bod_pts = bod_inertial_to_body_pos(frame_bd, $
              bod_body_to_inertial_pos(xd, $
                dsk_disk_to_body(xd, dsk_pts, frame=frame_bd)))

 return, bod_pts
end
;==============================================================================
