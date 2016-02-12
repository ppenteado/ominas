;=======================================================================================
; spice_sct2et
;
;=======================================================================================
function spice_sct2et, times, sc

 if(NOT keyword_set(sc)) then nv_message, name='spice_sct2et', $
                                          'Spacecraft must be specified.'


  cspice_scencd, sc, times, sclkdp
  cspice_sct2e, sc, sclkdp, et

  return, et








stop

 if(NOT keyword_set(sc)) then nv_message, name='spice_sct2et', $
                                          'Spacecraft must be specified.'

 sc = long(sc)
 n = n_elements(times)

 ets = dblarr(n)

 for i=0, n-1 do $
  begin
   time = times[i]

   et = 0d

   path = spice_bin_path()
   status = call_external(path + 'spice_io.so', '__sct2et', $
                        value=[1,0,0], $
			time, et, sc) 

   if(status NE 0) then $
    begin
     nv_message, name = 'spice_sct2et', 'Unable to get ephemeris time."
     return, -1
    end

   ets[i] = et
  end


 return, ets
end
;=======================================================================================
