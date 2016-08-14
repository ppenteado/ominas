;===========================================================================
; detect_radar.pro
;
;===========================================================================
function detect_radar, label, udata

if total(stregex(label,'INSTRUMENT_NAME[[:blank:]]*=[[:blank:]]*("CASSINI RADAR")|"(CASSINI RADAR)"',/bool)) then return,'CAS_RADAR'

 return, ''
end
;===========================================================================
