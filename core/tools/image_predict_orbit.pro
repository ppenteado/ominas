;=============================================================================
; image_predict_orbit
;
;  Inputs: nt camera descriptors, nt ring (orbit) descriptors.  For best 
;  results, the epoch of each ring descriptor should be pretty close 
;  (within a couple of light-travel times) to that of the corresponding 
;  camera descriptor.
;
;  Return: Array of indices of all input camera descriptors for which an
;          object on the given orbit is likely to be observed.
;
;=============================================================================
function image_predict_orbit, cd, gbx, rx, c=c, GG=GG, $
         pos=pos, pp=pp, radec=radec, notest=notest, slop=slop, rxt=_rxt

 nt = n_elements(cd)

 ;----------------------------------
 ; camera vectors
 ;----------------------------------
 orient = bod_orient(cd)
 v = orient[1,*,*]					; 1 x 3 x nt
 r = bod_pos(cd)
 if(nt GT 1) then $
  begin
   v = tr(v)
   r = tr(r)
  end

 ;----------------------------------
 ; evolve orbit
 ;----------------------------------
 dt = bod_time(gbx) - bod_time(rx)			; nt
 rxt = orb_evolve(rx, dt)

 ;-------------------------------------
 ; recenter orbit on planet center
 ;-------------------------------------
 bod_set_pos, rxt, bod_pos(gbx)

 ;----------------------------------
 ; compute orbit positions
 ;----------------------------------
 pos = dblarr(nt,3)

 for i=0, nt-1 do $
  begin
   pos[i,*] = orb_to_cartesian_lt(cd[i], rxt[i], c=c, v=vel)

   cam_pos = bod_pos(cd[i])
   r_rel = pos[i,*] - cam_pos

   v_rel = vel - (bod_vel(cd[i]))[0,*,*]
   rr = stellab_pos(r_rel, v_rel, c=c)

   pos[i,*] = rr + cam_pos
  end

 if(NOT arg_present(_rxt)) then nv_free, rxt $
 else _rxt = rxt


 if(keyword__set(notest)) then return, -1

 ;----------------------------------
 ; test each observation
 ;----------------------------------

 ;- - - - - - - - - - - - - - -
 ; in image?
 ;- - - - - - - - - - - - - - -
 pp = reform(inertial_to_image_pos(cd, pos))
 w = in_image(cd, pp, slop=slop)

 ;- - - - - - - - - - - - - - - - - - - - - - - - -
 ; hidden by planet?
 ;- - - - - - - - - - - - - - - - - - - - - - - - -
 if(w[0] NE -1) then $
  begin
   rr = bod_inertial_to_body_pos(gbx, r)
   p = bod_inertial_to_body_pos(gbx, pos)
   www = glb_hide_points(gbx, rr, p)

   ww = complement(w, www) 
   if(ww[0] NE -1) then w = w[ww] $
   else w = [-1]
  end


 return, w
end
;=============================================================================
