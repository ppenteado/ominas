;===========================================================================
; eph_spice_sun
;
;===========================================================================
function eph_spice_sun, dd, ref, n_obj=n_obj, dim=dim, $
                     status=status, time=sc_time, constants=constants, obs=obs

 if(NOT keyword_set(sc)) then sc = 0l

 ;------------------------------
 ; get planet descriptor for sun
 ;------------------------------
 pd = eph_to_ominas( $
	spice_planets(dd, ref, $
		time = sc_time, $
		plt_name = ['SUN'], $
		n_obj=n_obj, dim=dim, status=status, constants=constants, obs=obs) )
 if(status NE 0) then return, 0

 ;------------------------------
 ; convert to star descriptor
 ;------------------------------
 sd = str_create_descriptors(n_obj, $
		name=cor_name(pd), $
		orient=bod_orient(pd), $
		avel=bod_avel(pd), $
		pos=bod_pos(pd), $
		lum=3.862d26, $
		mass=1.98892d30, $
		vel=bod_vel(pd), $
		time=bod_time(pd), $
		lref=glb_lref(pd), $
		radii=glb_radii(pd), $
		lora=glb_lora(pd))

 return, sd

end
;===========================================================================



