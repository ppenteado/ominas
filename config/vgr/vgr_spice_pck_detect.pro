;=============================================================================
; vgr_spice_pck_detect
;
;
;=============================================================================
function vgr_spice_pck_detect, dd, kpath, time=time, strict=strict, all=all

 return, eph_spice_pck_detect( $
         dd, kpath, time=time, strict=strict, all=all)
end
;=============================================================================
