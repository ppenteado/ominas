;=======================================================================================
; spice_et2str
;
;=======================================================================================
function spice_et2str, ets, format=format, prec=prec

 if(NOT keyword_set(format)) then format = 'ISOD'
 if(NOT keyword_set(prec)) then prec = 3

 cspice_et2utc, ets, format, prec, times
 return, times

stop






 if(NOT keyword_set(format)) then format = 'ISOD'

 ets = double(_ets)

 n = n_elements(ets)
 times = strarr(n)

 for i=0, n-1 do $
  begin
   et = ets[i]

   time = bytarr(128)

   path = spice_bin_path()
   status = call_external(path + 'spice_io.so', '__et2utc', $
                        value=[0,1,0], $
			et, format, time) 
   if(status NE 0) then $
    begin
     nv_message, name = 'spice_et2utc', 'Unable to convert ephemeris time."
     return, -1
    end

   times[i] = string(time)
  end


 return, times
end
;=======================================================================================
