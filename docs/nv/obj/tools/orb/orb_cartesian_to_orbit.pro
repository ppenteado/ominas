;==============================================================================
; orb_cartesian_to_orbit
;
; This routine is incomplete.
;
; inputs are wrt inertial frame.
;
;==============================================================================
function orb_cartesian_to_orbit, gbx, _r, _v, GG=GG, circular=circular

 if(keyword_set(GG)) then GM = GG*sld_mass(gbx) $
 else GM = sld_gm(gbx)

 circular = keyword_set(circular)

 nt = n_elements(gbx)
 dim = (size(_r, /dim))[0]
 nv = dim[0]

 sub = linegen3x(nv,3,nt)
 r = bod_inertial_to_body_pos(gbx, _r)

 if(NOT circular) then $
  begin
   v = (_v - (bod_vel(gbx))[0,*,*,*])[sub]
   v = bod_inertial_to_body(gbx, v)
  end


 ;-------------------------
 ; useful quantities
 ;-------------------------
 mu = dblarr(nv,3,nt)
 mu[*] = GM

 orient = bod_orient(gbx)
 xx = orient[0,*,*]
 yy = orient[1,*,*]
 zz = orient[2,*,*]

 rr = v_mag(r)                                  ; r magnitude
 ru = v_unit(r)                                 ; r unit vector

 if(NOT circular) then $
  begin
   v2 = v_inner(v,v)                            ; v squared
   vv = sqrt(v2)                                ; v magnitude
   vu = v_unit(v)                               ; v unit vector
  end

 ;---------------------------
 ; energy => semimajor axis
 ;---------------------------
 if(circular) then a = rr $
 else $
  begin
   energy = v2/2d - mu[0]/rr
   a = -mu[0]/(2d*energy)
  end

 ;----------------------------------------------------------------------
 ; angular momentum => eccentricity
 ;----------------------------------------------------------------------
 e = dblarr(nv,nt)
 if(NOT circular) then $
  begin
   h = v_cross(r,v)

   h2 = v_inner(h,h)
   hh = sqrt(h2)
   hu = v_unit(h)

   e2 = 1d - h2/(mu[0]*a)
   e = e2
   w = where(e2 LT 0)
   ww = where(e2 GE 0)
   if(w[0] NE -1) then $
    begin
     if(NOT keyword__set(neg_e)) then e[w] = 0d $
     else e[w] = -sqrt(-e2[w])
    end
   if(ww[0] NE -1) then e[ww] = sqrt(e2[ww])
  end


 ;--------------------------------------------------------------------
 ; hamilton's integral => true anomaly, argument of pericenter
 ;--------------------------------------------------------------------
 ap = dblarr(nv,nt)
 f = dblarr(nv,nt)
 ma = dblarr(nv,nt)
 if(NOT circular) then $
  begin
   h_x_v = v_cross(h,v)

   p = -mu*ru - h_x_v
   pu = v_unit(p)
   p_x_r = v_cross(p,r)

   cos_f = v_inner(ru,pu)
   f = reduce_angle(acos(cos_f) * double(sign(v_inner(p_x_r,h))))
   ma = orb_compute_ma(ecc=e, f=f)
  end


 ;-------------------------------------
 ; construct initial descriptor
 ;-------------------------------------
 dkx = objarr(nv,nt)
 for j=0, nv-1 do $
  for i=0, nt-1 do $
     dkx[j,i] = orb_construct_descriptor(gbx[i], $
                             sma=a[j,i], ecc=e[j,i], ma=ma[j,i], GG=GG)


 ;-------------------------------------
 ; set orientation (i.e, inc, ap, lan)
 ;-------------------------------------
 if(NOT circular) then $
  begin
   orient = dblarr(3,3,nt)
   orient[2,*,*] = bod_body_to_inertial(gbx, hu)
   orient[0,*,*] = bod_body_to_inertial(gbx, pu)
   orient[1,*,*] = v_cross(orient[2,*,*], orient[0,*,*])
   bod_set_orient, dkx, orient
  end


 ;----------------------------------------------------------
 ; for circular orbit, update mean anomaly 
 ;----------------------------------------------------------
 if(circular) then $
  for j=0, nv-1 do $
   for i=0, nt-1 do $
    begin
     orient = bod_orient(dkx[j,i])
     x = bod_inertial_to_body(gbx, orient[0,*])
     z = bod_inertial_to_body(gbx, orient[2,*])
     ma = v_angle(ru[j,*,i], x)
     test = v_inner(v_cross(x, ru[j,*,i]), z)
     if(test[0] LT 0) then ma = 2d*!dpi - ma
     orb_set_ma, dkx[j,i], ma
    end

 return, reform(dkx)
end
;==============================================================================
