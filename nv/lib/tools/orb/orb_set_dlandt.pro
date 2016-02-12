;===========================================================================
; orb_set_dlandt
;
;===========================================================================
pro orb_set_dlandt, xd, frame_bd, dlandt

 nt = n_elements(xd)

 bd = class_extract(xd, 'BODY')

 orient0 = (bod_orient(frame_bd))[linegen3z(3,3,nt)]
 avel = bod_avel(bd)

 _dlandt = reform(dlandt ## make_array(3, val=1), 1, 3, nt)
 avel[1,*,*] = orient0[2,*,*] * _dlandt

 bod_set_avel, bd, avel
end
;===========================================================================
