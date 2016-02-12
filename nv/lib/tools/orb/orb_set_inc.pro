;===========================================================================
; orb_set_inc
;
;===========================================================================
pro orb_set_inc, xd, frame_bd, inc

 nt = n_elements(xd)

 bd = class_extract(xd, 'BODY')
 orient = bod_orient(bd)

 node = orb_get_ascending_node(xd, frame_bd, arb=arb)
 w = where(finite(node) NE 1)
 if(w[0] NE -1) then node = orient[0,*,*]

 inc0 = orb_get_inc(xd, frame_bd)
 dinc = inc - inc0

 sin_dinc = sin(dinc)
 cos_dinc = cos(dinc)
 orient[0,*,*] = v_rotate_11(orient[0,*,*], node, sin_dinc, cos_dinc)
 orient[1,*,*] = v_rotate_11(orient[1,*,*], node, sin_dinc, cos_dinc)
 orient[2,*,*] = v_rotate_11(orient[2,*,*], node, sin_dinc, cos_dinc)

 bod_set_orient, bd, orient

 avel = bod_avel(bd)
 avel[0,*,*] = v_rotate_11(avel[0,*,*], node, sin_dinc, cos_dinc)
 bod_set_avel, bd, avel

 if(arb[0] NE -1) then orb_set_lan, xd[arb], frame_bd, 0d

end
;===========================================================================
