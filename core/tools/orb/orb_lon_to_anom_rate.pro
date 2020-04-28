;==============================================================================
; orb_lon_to_anom_rate
;
;
;==============================================================================
function orb_lon_to_anom_rate, xd, dlondt, frame_bd, dapdt=dapdt, dlandt=dlandt
 return, orb_arg_to_anom_rate(xd, $
           orb_lon_to_arg_rate(xd, dlondt, frame_bd, dlandt=dlandt), frame_bd, dapdt=dapdt)
end
;==============================================================================
