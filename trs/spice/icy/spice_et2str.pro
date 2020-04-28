;=======================================================================================
; spice_et2str
;
;=======================================================================================
function spice_et2str, ets, format=format, prec=prec

 if(NOT keyword_set(format)) then format = 'ISOD'
 if(NOT keyword_set(prec)) then prec = 3

 cspice_et2utc, ets, format, prec, times
 return, times
end
;=======================================================================================
