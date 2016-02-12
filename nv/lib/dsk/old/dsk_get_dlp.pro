;===========================================================================
; dsk_get_ap
;
;
;===========================================================================
function dsk_get_ap, dkx, frame_bd
 dkd = class_extract(dkx, 'DISK')

 if(NOT keyword__set(frame_bd)) then frame_bd = bod_inertial()
 ap = orb_get_ap(dkd, frame_bd)

 return, ap
end
;===========================================================================



