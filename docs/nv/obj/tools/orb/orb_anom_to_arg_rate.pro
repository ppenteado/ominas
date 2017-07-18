;==============================================================================
; orb_anom_to_arg_rate
;
;  Converts angles measured from periapse to angles measured from the 
;  ascending node.
;
;==============================================================================
function orb_anom_to_arg_rate, xd, danomdt, frame_bd, dapdt=dapdt
 
 dim = size([danomdt], /dim)
 if(NOT keyword_set(dapdt)) then $
     dapdt = make_array(dim, val=orb_get_dapdt(xd, frame_bd))

 dargdt = danomdt + dapdt

 return, dargdt
end
;==============================================================================
