;===========================================================================
; orb_set_ap
;
;
;===========================================================================
pro orb_set_ap, xd, frame_bd, ap

 nt = n_elements(xd)

 orient = bod_orient(xd)
 zz = orient[2,*,*]						; 1 x 3 x nt

 ap0 = orb_get_ap(xd, frame_bd)					; nt
 dap = ap - ap0	

 sin_dap = sin(dap)
 cos_dap = cos(dap)
 orient[0,*,*] = v_rotate_11(orient[0,*,*], zz, sin_dap, cos_dap)
 orient[1,*,*] = v_rotate_11(orient[1,*,*], zz, sin_dap, cos_dap)

 bod_set_orient, xd, orient
end
;===========================================================================
