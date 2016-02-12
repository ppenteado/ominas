;=============================================================================
; pht_angles
;
; NOTE: emm, inc, and g are COSINES.
;
;=============================================================================
pro pht_angles, image_pts, cd, gbx, sund, emm=emm, inc=inc, g=g, valid=valid

 np = n_elements(image_pts)/2
 nt = n_elements(gbx)

 gbd = class_extract(gbx, 'GLOBE')
 bd = glb_body(gbd)
 cam_bd = cam_body(cd)

 sun_bd = class_extract(sund, 'BODY')

 ;-------------------------------
 ; construct view vectors
 ;-------------------------------
 cam_pos = (bod_pos(cam_bd))[gen3y(np,3,nt)]
 v = bod_inertial_to_body_pos(bd, cam_pos)

 r_inertial = (bod_body_to_inertial(cam_bd, $
                cam_focal_to_body(cd, $
                  cam_image_to_focal(cd, image_pts))))[linegen3z(np,3,nt)]
 r = bod_inertial_to_body(bd, r_inertial)

 ;-------------------------------
 ; compute points on surface
 ;-------------------------------
 body_pts = (glb_intersect(gbd, v, r, d=d))[0:np-1,*,*]
;stop
;valid = where(d GE 0)
;ww = selgen(np,3,nt, valid)


 vsub = vecgen(np,3,nt)
 body_pts = body_pts[vsub]
 r = r[vsub]
 d = reform(d, np*nt, /overwrite)


 valid = where(d GE 0)
 if(valid[0] EQ -1) then return

 nvalid = n_elements(valid)

 body_pts = body_pts[valid,*]
 r = r[valid,*]

 ;-------------------------------
 ; construct sun vectors
 ;-------------------------------
 sun_pos_inertial = $
       reform(tr(bod_pos(sun_bd) ## make_array(np*nt, val=1d)), 1, 3, np*nt)
 sun_pos = (bod_inertial_to_body_pos(bd, sun_pos_inertial))[vsub]
 sun_pos = sun_pos[valid,*]
 s = v_unit(sun_pos - body_pts)

 ;-------------------------------
 ; compute surface normals
 ;-------------------------------
 normals = glb_surface_normal(gbd, body_pts)

 ;-------------------------------
 ; compute angles
 ;-------------------------------
 _emm = v_inner(-r, normals)

 _inc = v_inner(s, normals)
 w = where(_inc LT 0)
 if(w[0] NE -1) then _inc[w] = 0

 _g = v_inner(-r,s)

 emm = dblarr(np,nt)
 emm[valid] = _emm
 
 inc = dblarr(np,nt)
 inc[valid] = _inc

 g = dblarr(np,nt)
 g[valid] = _g


end
;=============================================================================
