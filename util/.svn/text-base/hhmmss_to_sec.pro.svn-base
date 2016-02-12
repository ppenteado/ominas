;=============================================================================
; hhmmss_to_sec
;
;=============================================================================
function hhmmss_to_sec, hhmmss

 hh = str_nnsplit(hhmmss, ':', rem=mmss)
 mm = str_nnsplit(mmss, ':', rem=ss)

 sec = double(hh)*3600d + double(mm)*60d + double(ss)

 return, sec
end
;=============================================================================
