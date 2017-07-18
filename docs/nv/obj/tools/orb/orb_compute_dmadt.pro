;===========================================================================
; orb_compute_dmadt
;
;===========================================================================
function orb_compute_dmadt, xd, gbx, GG=GG, sma=sma

 return, orb_compute_dmldt(xd, gbx, GG=GG, sma=sma) $
         - orb_compute_dlpdt(xd, gbx, GG=GG, sma=sma)
end
;===========================================================================



