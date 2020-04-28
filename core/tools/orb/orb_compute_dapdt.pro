;===========================================================================
; orb_compute_dapdt
;
;  See Eq. 4 in Ch. 3 of 'Planetary Satellites'
;
;  Accurate to 2nd order in e, i.
;
;===========================================================================
function orb_compute_dapdt, xd, gbx, GG=GG, sma=sma
 
 return, orb_compute_dlpdt(xd, gbx, GG=GG, sma=sma) $
         - orb_compute_dlandt(xd, gbx, GG=GG, sma=sma)
end
;===========================================================================
