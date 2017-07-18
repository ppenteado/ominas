;==============================================================================
; orb_arg_to_anom_rate
;
;  Converts angles meaured from the ascending node to angles measured from 
;  periapse.
;
;==============================================================================
function orb_arg_to_anom_rate, xd, dargdt, frame_bd, dapdt=dapdt

 dim = size([dargdt], /dim)
 if(NOT keyword_set(dapdt)) then $
     dapdt = make_array(dim, val=orb_get_dapdt(xd, frame_bd))

 danomdt = dargdt - dapdt

 return, danomdt
end
;==============================================================================
