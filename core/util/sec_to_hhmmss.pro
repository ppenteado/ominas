;=============================================================================
; sec_to_hhmmss
;
;=============================================================================
function sec_to_hhmmss, sec

 hh = fix(sec/3600.)
 mm = fix((sec - hh*3600.)/60.)
 ss = fix(sec - hh*3600. - mm*60.)
 dd = fix((sec - hh*3600. - mm*60. - ss) * 100.)

 hhmmss = str_pad(strtrim(hh,2), 2, c='0', al=1) + ':' + $
          str_pad(strtrim(mm,2), 2, c='0', al=1) + ':' + $
          str_pad(strtrim(ss,2), 2, c='0', al=1) + '.' + $
          str_pad(strtrim(dd,2), 2, c='0', al=1)

 return, hhmmss
end
;=============================================================================
