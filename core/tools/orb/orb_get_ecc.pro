;===========================================================================
; orb_get_ecc
;
;
;===========================================================================
function orb_get_ecc, xd, void
 return, (dsk_ecc(xd))[0,0,*]
end
;===========================================================================