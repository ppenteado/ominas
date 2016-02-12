;===========================================================================
; dsk_set_dlp
;
;
;===========================================================================
pro dsk_set_dlp, dkx, dlp, frame_bd
 dkd = class_extract(dkx, 'DISK')

; if(NOT keyword__set(frame_bd)) then frame_bd = bod_inertial()
; orb_set_lp, dkd, frame_bd, dlp

end
;===========================================================================
