;===========================================================================
; orb_set_dapdt
;
;===========================================================================
pro orb_set_dapdt, xd, frame_bd, dapdt

 nt = n_elements(xd)

 bd = class_extract(xd, 'BODY')

 orient = bod_orient(bd)
 avel = bod_avel(bd)

 _dapdt = reform(dapdt ## make_array(3, val=1), 1, 3, nt)
 avel[0,*,*] = orient[2,*,*] * _dapdt

 bod_set_avel, bd, avel
end
;===========================================================================
