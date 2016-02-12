;===========================================================================
; orb_get_liba_lan
;
;
;===========================================================================
function orb_get_liba_lan, xd, frame_bd

 nt = n_elements(xd)

 bd = class_extract(xd, 'BODY')

 liba = v_mag(bod_libv(bd))

 liba_lan = reform(liba[1,*], nt, /over)

 return, liba_lan
end
;===========================================================================
