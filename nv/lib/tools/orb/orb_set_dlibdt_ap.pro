;===========================================================================
; orb_set_dlibdt_ap
;
;===========================================================================
pro orb_set_dlibdt_ap, xd, frame_bd, dlibdt
 bd = class_extract(xd, 'BODY')

 _dlibdt = bod_dlibdt(bd)
 _dlibdt[0,*] = dlibdt

 bod_set_dlibdt, bd, _dlibdt
end
;===========================================================================
