;===========================================================================
; orb_get_lib_ap
;
;
;===========================================================================
function orb_get_lib_ap, xd, frame_bd

 nt = n_elements(xd)

 bd = class_extract(xd, 'BODY')

 lib = bod_lib(bd)

 lib_ap = reform(lib[0,*], nt, /over) 

 return, lib_ap
end
;===========================================================================
