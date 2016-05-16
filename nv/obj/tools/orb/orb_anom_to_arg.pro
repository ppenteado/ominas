;==============================================================================
; orb_anom_to_arg
;
;  Converts angles measured from periapse to angles measured from the 
;  ascending node.
;
;==============================================================================
function orb_anom_to_arg, xd, anom, frame_bd, ap=ap

 if(NOT keyword_set(ap)) then ap = orb_get_ap(xd, frame_bd)
 arg = anom + ap

 return, arg
end
;==============================================================================
