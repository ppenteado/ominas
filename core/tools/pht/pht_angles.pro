;=============================================================================
; pht_angles
;
; NOTE: emm, inc, and g are COSINES.
;
;=============================================================================
pro pht_angles, image_pts, cd, bx, ltd, inertial=inertial, $
       emm=emm, inc=inc, g=g, valid=valid, body_pts=body_pts, $
       north=north

 if(keyword_set(body_pts)) then np = n_elements(body_pts)/3 $
 else np = n_elements(image_pts)/2
 nt = n_elements(bx)

 globe = where(cor_isa(bx, 'GLOBE'))

 ;-------------------------------
 ; construct view vectors
 ;-------------------------------
 cam_pos = (bod_pos(cd))[gen3y(np,3,nt)]
 v = bod_inertial_to_body_pos(bx, cam_pos)

 if(keyword_set(body_pts)) then r = v_unit(body_pts - v) $
 else $
  begin
   if(keyword_set(inertial)) then r_inertial = image_pts $
   else r_inertial = (bod_body_to_inertial(cd, $
                        cam_focal_to_body(cd, $
                          cam_image_to_focal(cd, image_pts))))[linegen3z(np,3,nt)]
   r = bod_inertial_to_body(bx, r_inertial)

   ;-------------------------------
   ; compute points on surface
   ;-------------------------------
   body_pts = surface_intersect(bx, v, r, hit=valid)
   if(valid[0] EQ -1) then return
  end

 if(NOT keyword__set(valid)) then valid = lindgen(np*nt)
 nvalid = n_elements(valid)
 ww = colgen(np,3,nt, valid)

 ;-------------------------------
 ; construct light vectors
 ;-------------------------------
 sun_pos_inertial = (bod_pos(ltd))[gen3y(np,3,nt)]
 sun_pos = bod_inertial_to_body_pos(bx, sun_pos_inertial)
 s = v_unit(body_pts - sun_pos)

 ;-------------------------------
 ; compute surface normals
 ;-------------------------------
 normals = surface_normal(bx, v, body_pts, north=north)

 ;-------------------------------
 ; compute cosines
 ;-------------------------------
 rww = r[ww]
 sww = s[ww]

 _emm = v_inner(-rww, normals[ww])
 _inc = v_inner(-sww, normals[ww])
 _g = v_inner(rww, sww)

 emm = dblarr(np,nt)
; emm[valid] = _emm < 1d > 0d
 emm[valid] = _emm < 1d
 if(globe[0] NE -1) then emm[globe] = emm[globe] > 0d

 inc = dblarr(np,nt)
; inc[valid] = _inc < 1d > 0d
 inc[valid] = _inc < 1d
 if(globe[0] NE -1) then inc[globe] = inc[globe] > 0d

 g = dblarr(np,nt)
 g[valid] = _g < 1d

end
;=============================================================================
