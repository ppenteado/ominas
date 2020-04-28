;==============================================================================
; orb_evolve_ma
;
;==============================================================================
function orb_evolve_ma, rx, dt

 ndt = n_elements(dt)

 ma = make_array(1, ndt, val=orb_get_ma(rx))
 dmadt = orb_get_dmadt(rx)
 mat = reduce_angle(ma + dmadt*dt)

 return, mat
end
;==============================================================================
