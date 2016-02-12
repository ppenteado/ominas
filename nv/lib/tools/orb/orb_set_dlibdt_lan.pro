;===========================================================================
; orb_set_dlibdt_lan
;
;===========================================================================
pro orb_set_dlibdt_lan, xd, frame_bd, dlibdt
 bd = class_extract(xd, 'BODY')

 _dlibdt = bod_dlibdt(bd)
 _dlibdt[1,*] = dlibdt

 bod_set_dlibdt, bd, _dlibdt
end
;===========================================================================
