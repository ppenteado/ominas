;===========================================================================
; detect_cas_radar.pro
;
;===========================================================================
function detect_cas_radar, dd

 label = dat_header(dd) 

if total(stregex(label,'INSTRUMENT_NAME[[:blank:]]*=[[:blank:]]*("CASSINI RADAR")|"(CASSINI RADAR)"',/bool)) then return,'CAS_RADAR'

 return, ''
end
;===========================================================================
