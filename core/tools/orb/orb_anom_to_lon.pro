;==============================================================================
; orb_anom_to_lon
;
;  Converts angles measured from periapse to angles measured from reference 
;  direction.
;
;==============================================================================
function orb_anom_to_lon, xd, anom, frame_bd, ap=ap, lan=lan
 return, orb_arg_to_lon(xd, $
           orb_anom_to_arg(xd, anom, frame_bd, ap=ap), frame_bd, lan=lan)
end
;==============================================================================
