;===========================================================================
; pht_angles_disk
;
;  Always use /full!
;
; This routine is obsolete.  Use pht_angles instead.
;
;===========================================================================
pro ___pht_angles_disk, image_pts, cd, dkx, sund, frame_bd=frame_bd, $
                    emm=emm, inc=inc, g=g, $
                    valid=valid, ap_valid=ap_valid, full=full

 ap_valid = -1
 emm = (inc = (g = 0))
 if(NOT keyword__set(dkx)) then return

 orient = bod_orient(dkx)
 zz = orient[2,*]

 emm = (inc = (g = 0d))

 ;--------------------
 ; emission angle
 ;--------------------
 scv = image_to_inertial(cd, image_pts)
 scv_bod = bod_inertial_to_body(dkx, scv)

 cam_pos = bod_pos(cd)
 cam_pos_body = bod_inertial_to_body_pos(dkx, bod_pos(cd))
 v = dsk_intersect(dkx, cam_pos_body, scv_bod, hit=valid, frame_bd=frame_bd)
 valid = valid[0]
 cos_emm = v_inner(-scv, zz)

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; with /full, we define the normal as pointing toward the side of 
 ; the rings from which they are viewed.  Therefore, emm will always
 ; be between 0 and pi/2, while inc can range from 0 to pi.  This 
 ; behavior seems the most reasonable, but this code has been used for 
 ; IMDB processing for a while in the default mode.
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 if(keyword_set(full)) then if(cos_emm[0] LT 0) then zz = -zz

 cos_emm = abs(cos_emm) 

 ;--------------------
 ; incidence angle
 ;--------------------
 vv = bod_body_to_inertial_pos(dkx, v)
 sun_pos = bod_pos(sund)
 cos_inc = v_inner(v_unit(sun_pos-vv), zz)

 ;--------------------
 ; phase angle
 ;--------------------
 cos_g = v_inner(v_unit(cam_pos-vv), v_unit(sun_pos-vv))

 ;-----------------------------------------------------------------
 ; determine whether the point is aimed toward or away from ring
 ;-----------------------------------------------------------------
 zzz = zz
 if((v_inner(scv,zz))[0] LT 0) then zzz = -zz
 ap_valid = -1
 if((v_inner(zzz, cam_pos - bod_pos(dkx)))[0] LT 0) then ap_valid = 1

 emm = reduce_angle(acos(cos_emm[0]), max=!dpi)
 inc = reduce_angle(acos(cos_inc[0]), max=!dpi)
 g = reduce_angle(acos(cos_g[0]), max=!dpi)
end
;===========================================================================



;===========================================================================
; pht_angles_disk
;
;
;===========================================================================
pro pht_angles_disk, image_pts, cd, dkx, sund, frame_bd=frame_bd, $
                    emm=emm, inc=inc, g=g, $
                    valid=valid, vv=vv, body_pts=v

 if(keyword_set(v)) then np = (size(v,/dim))[0] $
 else $
  begin
   dim = size(image_pts, /dim)
   if(n_elements(dim) EQ 1) then np = 1 $
   else np = dim[1]
  end
 nt = n_elements(cd)

 ap_valid = -1
 emm = (inc = (g = 0))
 if(NOT keyword_set(dkx)) then return

 orient = bod_orient(dkx)
 zz = (orient[2,*,*])[linegen3x(np,3,nt)]

 emm = (inc = (g = 0d))

 ;--------------------
 ; find intercepts
 ;--------------------
; cam_pos = (bod_pos(cd))[gen3y(np,3,nt)]
 cam_pos = (bod_pos(cd))[linegen3x(np,3,nt)]
 cam_pos_body = bod_inertial_to_body_pos(dkx, cam_pos)

 if(keyword_set(v)) then $
  begin
   scv_body = v_unit(v - bod_inertial_to_body_pos(cd, cam_pos))
   scv = bod_body_to_inertial(cd, scv_body)
  end $
 else $
  begin 
   scv = image_to_inertial(cd, image_pts)
   scv_bod = bod_inertial_to_body(dkx, scv)

   v = dsk_intersect(dkx, cam_pos_body, scv_bod, hit=valid, frame_bd=frame_bd)
  end
 if(NOT keyword_set(valid)) then valid = lindgen(np*nt)

 ;--------------------
 ; emission angle
 ;--------------------
 cos_emm = v_inner(-scv, zz)

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; Here, we define the normal as pointing toward the side of 
 ; the rings from which they are viewed.
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 w = where(cos_emm LT 0) 
 if(w[0] NE -1) then $
  begin
   ii = colgen(np, 3, nt, w)
   zz[ii] = -zz[ii]
  end

 cos_emm = abs(cos_emm) 

 ;--------------------
 ; incidence angle
 ;--------------------
 vv = bod_body_to_inertial_pos(dkx, v)
 sun_pos = (bod_pos(sund))[gen3y(np,3,nt)]
 cos_inc = v_inner(v_unit(sun_pos-vv), zz)

 ;--------------------
 ; phase angle
 ;--------------------
 cos_g = v_inner(v_unit(cam_pos-vv), v_unit(sun_pos-vv))

 emm = reduce_angle(acos(cos_emm), max=!dpi)
 inc = reduce_angle(acos(cos_inc), max=!dpi)
 g = reduce_angle(acos(cos_g), max=!dpi)
end
;===========================================================================


; grim ~/casIss/1493/N1493538900_1.IMG over=ring

; ingrid, cd=cd, pd=pd, rd=rd, sund=sund


; im_pts = tr([tr([500.,500.]), tr([400.,400.])])

; pht_angles_disk, im_pts, cd, rd[0], sund, frame=pd[0], emm=emm, inc=inc, g=g


