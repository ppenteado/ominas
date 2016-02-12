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
 gbd = plt_globe(pd)
 sld = glb_solid(gbd)
 bd = sld_body(sld)

 sd = str_init_descriptors(n_obj, $
		name=get_core_name(pd), $
		orient=bod_orient(bd), $
		avel=bod_avel(bd), $
		pos=bod_pos(bd), $
		lum=3.862d26, $
		mass=1.98892d30, $
		vel=bod_vel(bd), $
		time=bod_time(bd), $
		lref=glb_lref(gbd), $
		radii=glb_radii(gbd), $
		lora=glb_lora(gbd))

 return, sd

end
;===========================================================================



