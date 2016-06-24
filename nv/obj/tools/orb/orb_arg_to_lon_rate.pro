;==============================================================================
; orb_arg_to_lon_rate
;
;  Converts angles measured from the ascending node to angles measured from 
;  the reference direction.
;
;==============================================================================
function orb_arg_to_lon_rate, xd, dargdt, frame_bd, dlandt=dlandt

 dim = size([dargdt], /dim)
 if(NOT keyword_set(dlandt)) then $
     dlandt = make_array(dim, val=orb_get_dlandt(xd, frame_bd))

 dlondt = dargdt + dlandt

 return, dlondt
end
;==============================================================================
