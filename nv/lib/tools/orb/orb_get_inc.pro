;===========================================================================
; orb_get_inc
;
;
;===========================================================================
function orb_get_inc, xd, frame_bd

 nt = n_elements(xd)

 bd = class_extract(xd, 'BODY')
 orient0 = bod_orient(frame_bd)
 orient = bod_orient(bd)
 inc = transpose(v_angle(orient[2,*,*], orient0[2,*,*]))

 return, inc
end
;===========================================================================
