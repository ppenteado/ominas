;==============================================================================
; orb_anom_to_lon_rate
;
;  Converts angles measured from periapse to angles measured from reference 
;  direction.
;
;==============================================================================
function orb_anom_to_lon_rate, xd, danomdt, frame_bd, dapdt=dapdt, dlandt=dlandt
 return, orb_arg_to_lon_rate(xd, $
           orb_anom_to_arg_rate(xd, danomdt, frame_bd, dapdt=dapdt), frame_bd, dlandt=dlandt)
end
;==============================================================================
