;=============================================================================
; image_predict_wind
;
;  The Camera twist angle is neglected.  This routine just looks at the 
;  angle between the optic axis and the body position.
;
;  This routine works for only one observation at a time.
;
;=============================================================================
function image_predict_wind, cd, gbx, t0, surf_pt, vel, pos=pos, vdeg=vdeg

 nt = n_elements(cd)

 ;----------------------------------
 ; camera vectors
 ;----------------------------------
 orient = bod_orient(cd)
 v = orient[1,*,*]				
 r = bod_pos(cd)
 if(nt GT 1) then $
  begin
   v = tr(v)
   r = tr(r)
  end


 ;-------------------------------------------
 ; compute parcel positions in zonal wind
 ;-------------------------------------------
 dt = bod_time(gbx) - t0					

 lat = surf_pt[0]
 lon0 = surf_pt[1]
; rad = glb_get_radius(gbx[0], lat, lon0)
; surf_pt[2] = rad
 surf_pt[2] = 0d
 dlondt = vel
 if(NOT keyword__set(vdeg)) then dlondt = (dlondt / (rad*cos(lat)))[0]
 lons = dlondt*dt + lon0

 surf_pts = reform(tr(surf_pt) # make_array(1,nt, val=1d), 1,3,nt, /over)
 surf_pts[0,1,*] = lons

 pos_body = glb_globe_to_body(gbx, surf_pts)
 pos = bod_body_to_inertial_pos(gbx, pos_body)
 if(nt GT 1) then pos = tr(pos)


 ;----------------------------------
 ; test each observation
 ;----------------------------------

 ;- - - - - - - - - - - - - - -
 ; in image?
 ;- - - - - - - - - - - - - - -
 nn = 1.5*(cam_size(cd))[0]
 theta_max = (cam_scale(cd))[0,*] * nn

 vv = v_unit(pos - r)
 theta = v_angle(v, vv)
 w = where(theta LT theta_max)

 ;- - - - - - - - - - - - - - - - - - - - - - - - -
 ; hidden by planet?
 ;  This assumes that you're far from the planet
 ;- - - - - - - - - - - - - - - - - - - - - - - - -
 if(w[0] NE -1) then $
  begin
   rr = v_mag(pos-bod_pos(cd))
   r = v_mag(bod_pos(gbx)-bod_pos(cd))

   ww = where(rr LT r)
   if(ww[0] NE -1) then w = w[ww] $
   else w = [-1]
  end


 return, w
end
;=============================================================================
