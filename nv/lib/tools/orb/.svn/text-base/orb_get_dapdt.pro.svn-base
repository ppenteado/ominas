;===========================================================================
; orb_get_dapdt
;
;
;===========================================================================
function orb_get_dapdt, xd, frame_bd

 nt = n_elements(xd)

 bd = class_extract(xd, 'BODY')

 orient = bod_orient(bd)
 avel = bod_avel(bd)

 dapdt = reform(v_mag(avel[0,*,*]), nt, /over) 
 sign = sign(v_inner(orient[2,*,*], avel[0,*,*]))

 return, sign*dapdt
end
;===========================================================================
