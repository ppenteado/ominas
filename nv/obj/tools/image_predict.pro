;=============================================================================
; image_predict
;
;  Inputs: nt camera descriptors, nt ring (orbit) descriptors.  For best 
;  results, the epoch of each ring descriptor should be pretty close 
;  (within a couple of light-travel times) to that of the corresponding 
;  camera descriptor.
;
;  Return: Array of indices of all input camera descriptors for which an
;          object on the given orbit is likely to be observed.
;
;  The Camera twist angle is neglected.  This routine just looks at the 
;  angle between the optic axis and the body position.
;
;=============================================================================
function image_predict, cd, rx, gbx, c=c, GG=GG, pos=pos

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
 ; compute orbit positions
 ;----------------------------------
 t0 = (bod_time(rx))[0]
 dt = bod_time(cd) - t0					; nt

 pos = dblarr(nt,3)

 for i=0, nt-1 do $
         pos[i,*] = orb_to_cartesian_lt(cd[i], rx[i], gbx[i], c=c, GG=GG)


 ;----------------------------------
 ; test each observation
 ;----------------------------------
 nn = 1.5*(cam_size(cd))[0]
 theta_max = (cam_scale(cd))[0,*] * nn

 vv = v_unit(pos - r)
 theta = v_angle(v, vv)
 w = where(theta LT theta_max)


 return, w
end
;=============================================================================
