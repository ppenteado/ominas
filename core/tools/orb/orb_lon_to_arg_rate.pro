;==============================================================================
; orb_lon_to_arg_rate
;
;
;==============================================================================
function orb_lon_to_arg_rate, xd, dlondt, frame_bd, dlandt=dlandt

 dim = size([dlondt], /dim)
 if(NOT keyword_set(dlandt)) then $
     dlandt = make_array(dim, val=orb_get_dlandt(xd, frame_bd))

 dargdt = dlondt - dlandt

 return, dargdt
end
;==============================================================================
