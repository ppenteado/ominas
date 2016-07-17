;=============================================================================
; gll_spice_pck_detect
;
;
;=============================================================================
function gll_spice_pck_detect, dd, kpath, time=time, reject=reject, strict=strict, all=all

 return, eph_spice_pck_detect( $
         dd, kpath, time=time, reject=reject, strict=strict, all=all)
end
;=============================================================================
