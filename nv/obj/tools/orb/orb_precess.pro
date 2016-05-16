;==============================================================================
; orb_precess
;
;  Returns planet and ring descriptors with same centers and orientations.
;  Orientations are precessed from the given epoch planet descriptor pd0 to 
;  the pd epochs, and the positions are taken from the given current planet 
;  descriptors, pd.  Planet masses are copied from pd0.
;
;==============================================================================
pro orb_precess, obs_bx, _pd0, pd, _rd0, _pd=_pd, _rd=_rd, $
                        pd_precess=pd_precess, rd_precess=rd_precess

 n = n_elements(obs_bx)
 if(n EQ 0) then n = n_elements(_pd0)

 if(n_elements(_pd0) NE n) then pd0 = make_array(n, val=_pd0) $
 else pd0 = _pd0

 if(n_elements(_rd0) NE n) then rd0 = make_array(n, val=_rd0) $
 else rd0 = _rd0


 if(NOT keyword_set(_pd)) then _pd = nv_clone(pd0)
 if(NOT keyword_set(_rd)) then _rd = nv_clone(rd0)

 ;---------------------------------------------
 ; associate scratch descriptors
 ;---------------------------------------------
 ii = lindgen(n)
 pd_precess = _pd[ii]
 rd_precess = _rd[ii]

 ;---------------------------------------------
 ; copy correct positions, velocities, masses
 ;---------------------------------------------
nv_message, /con, name='orb_precess', 'Warning: untested use of nv_copy.'
nv_copy, pd_precess, pd
nv_copy, rd_precess, rd0
; plt_copy_descriptor, pd_precess, pd
; rng_copy_descriptor, rd_precess, rd0

 bod_set_pos, rd_precess, bod_pos(pd_precess)
 bod_set_vel, rd_precess, bod_vel(pd_precess)
 sld_set_gm, pd_precess, sld_gm(pd0)


 ;--------------------------------------------------------
 ; precess from pd0 to find correct planet orientation
 ;--------------------------------------------------------
 dt = bod_time(pd_precess) - bod_time(pd0)
 bdt = objarr(n)
 for i=0, n-1 do bdt[i] = bod_evolve(pd0[i], dt[i])

 bod_set_orient, pd_precess, bod_orient(bdt)
 nv_free, bdt

 ;-----------------------------------------------------------------
 ; precess from rd0 to find correct ring orientation 
 ;-----------------------------------------------------------------
 dt = bod_time(pd_precess) - bod_time(rd0)
 dkdt = objarr(n)
 if(orb_test(rd0[0])) then $
     for i=0, n-1 do dkdt[i] = orb_evolve(rd0[i], dt[i]) $
 else for i=0, n-1 do dkdt[i] = dsk_evolve(rd0[i], dt[i])

 bod_set_orient, rd_precess, bod_orient(dkdt)
 bod_set_time, rd_precess, bod_time(dkdt)
 if(orb_test(rd0[0])) then orb_set_ma, rd_precess, orb_get_ma(dkdt) $
 else dsk_set_lpm, rd_precess, dsk_lpm(dkdt)

 nv_free, dkdt

end
;==============================================================================



