;===========================================================================
; orb_set_liba_ap
;
;===========================================================================
pro orb_set_liba_ap, xd, frame_bd, liba_ap

 nt = n_elements(xd)

 bd = class_extract(xd, 'BODY')

 orient = bod_orient(bd)
 libv = bod_libv(bd)

 _liba_ap = reform(liba_ap ## make_array(3, val=1), 1, 3, nt)
 libv[0,*,*] = orient[2,*,*] * _liba_ap

 bod_set_libv, bd, libv
end
;===========================================================================
