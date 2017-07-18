;===========================================================================
; orb_get_dlandt
;
;
;===========================================================================
function orb_get_dlandt, xd, frame_bd

 nt = n_elements(xd)

 orient = bod_orient(xd)
 avel = bod_avel(xd)

 dlandt = reform(v_mag(avel[1,*,*]), nt, /over)
 sign = sign(v_inner(orient[2,*,*], avel[1,*,*]))

 return, sign*dlandt
end
;===========================================================================
