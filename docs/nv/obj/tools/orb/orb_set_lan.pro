;===========================================================================
; orb_set_lan
;
;===========================================================================
pro orb_set_lan, xd, frame_bd, lan

 nt = n_elements(xd)

 iframe_bd = orb_inertialize(frame_bd)

 orient0 = bod_orient(iframe_bd)
 iframe_zz = orient0[2,*,*]

 orient = bod_orient(xd)
 lan0 = orb_get_lan(xd, frame_bd)
 dlan = lan - lan0
 
 sin_dlan = sin(dlan)
 cos_dlan = cos(dlan)
 orient[0,*,*] = v_rotate_11(orient[0,*,*], iframe_zz, sin_dlan, cos_dlan)
 orient[1,*,*] = v_rotate_11(orient[1,*,*], iframe_zz, sin_dlan, cos_dlan)
 orient[2,*,*] = v_rotate_11(orient[2,*,*], iframe_zz, sin_dlan, cos_dlan)
 bod_set_orient, xd, orient

 avel = bod_avel(xd)
 avel[0,*,*] = v_rotate_11(avel[0,*,*], iframe_zz, sin_dlan, cos_dlan)
 bod_set_avel, xd, avel

 nv_free, iframe_bd


; if(keyword__set(inertial)) then ...
;orb_set_ma...  keep inertial coordinates the same 
;orb_set_ap...
end
;===========================================================================
