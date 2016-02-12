;===========================================================================
; orb_get_dlandt
;
;
;===========================================================================
function orb_get_dlandt, xd, frame_bd

 nt = n_elements(xd)

 bd = class_extract(xd, 'BODY')

 orient = bod_orient(bd)
 avel = bod_avel(bd)

 dlandt = reform(v_mag(avel[1,*,*]), nt, /over)
 sign = sign(v_inner(orient[2,*,*], avel[1,*,*]))

 return, sign*dlandt
end
;===========================================================================
