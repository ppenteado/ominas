;==============================================================================
; orb_to_cartesian
;
; result is wrt inertial frame.
;
;==============================================================================
function orb_to_cartesian, _rx, vel=vel, f=_f

 n_rx = n_elements(_rx)
 n_f = n_elements(_f)
 nt = n_rx > n_f

 if(n_rx NE nt) then rx = make_array(nt, val=_rx) $
 else rx = _rx

 if(NOT keyword__set(_f)) then _f = orb_compute_ta(rx)

 sub = linegen3y(1,3,nt)

 a = (orb_get_sma(rx))[sub]
 e = (orb_get_ecc(rx))[sub]
 dmadt = (orb_get_dmadt(rx))[sub]
 orient = bod_orient(rx)

 xx = orient[0,*,*]
 yy = orient[1,*,*]
 zz = orient[2,*,*]

 one_e2 = 1d - e^2
 f = _f[sub]
 sin_f = sin(f) & cos_f = cos(f)
 r = a*one_e2 / (1d + e*cos_f)

 ;--------------------
 ; position
 ;--------------------
 pos = r*cos_f*xx + r*sin_f*yy
 pos = pos + bod_pos(rx)

 ;--------------------
 ; velocity
 ;--------------------
 mu = dmadt^2 * a^3

 h = sqrt(mu*a*one_e2)

 rdot = e*h*sin_f / (a*one_e2)
 fdot = h / r^2

 rr = cos_f*xx + sin_f*yy
 ff = -sin_f*xx + cos_f*yy

 vel = rdot*rr + r*fdot*ff
 vel = vel + bod_vel(rx)
 

 return, pos
end
;==============================================================================
