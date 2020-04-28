;==============================================================================
; orb_arg_to_lon
;
;  Converts angles measured from the ascending node to angles measured from 
;  the reference direction.
;
;==============================================================================
function orb_arg_to_lon, xd, arg, frame_bd, lan=lan

 if(NOT keyword_set(lan)) then lan = orb_get_lan(xd, frame_bd)
 lon = arg + lan

 return, lon
end
;==============================================================================
