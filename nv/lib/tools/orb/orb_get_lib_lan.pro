;===========================================================================
; orb_get_lib_lan
;
;
;===========================================================================
function orb_get_lib_lan, xd, frame_bd

 nt = n_elements(xd)

 bd = class_extract(xd, 'BODY')

 lib = bod_lib(bd)

 lib_lan = reform(lib[1,*], nt, /over)

 return, lib_lan
end
;===========================================================================
