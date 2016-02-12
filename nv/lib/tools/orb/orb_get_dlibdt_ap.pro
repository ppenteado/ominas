;===========================================================================
; orb_get_dlibdt_ap
;
;
;===========================================================================
function orb_get_dlibdt_ap, xd, frame_bd

 nt = n_elements(xd)

 bd = class_extract(xd, 'BODY')

 dlibdt = bod_dlibdt(bd)

 dlibdt_ap = reform(dlibdt[0,*], nt, /over) 

 return, dlibdt_ap
end
;===========================================================================
