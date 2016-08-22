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
end
;=======================================================================================
