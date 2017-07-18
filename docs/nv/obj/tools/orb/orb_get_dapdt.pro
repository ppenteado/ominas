;===========================================================================
; orb_get_dapdt
;
;
;===========================================================================
function orb_get_dapdt, xd, frame_bd

 nt = n_elements(xd)

 orient = bod_orient(xd)
 avel = bod_avel(xd)

 dapdt = reform(v_mag(avel[0,*,*]), nt, /over) 
 sign = sign(v_inner(orient[2,*,*], avel[0,*,*]))

 return, sign*dapdt
end
;===========================================================================
