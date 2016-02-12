;===========================================================================
; orb_get_liba_ap
;
;
;===========================================================================
function orb_get_liba_ap, xd, frame_bd

 nt = n_elements(xd)

 bd = class_extract(xd, 'BODY')

 liba = v_mag(bod_libv(bd))

 liba_ap = reform(liba[0,*], nt, /over) 

 return, liba_ap
end
;===========================================================================
