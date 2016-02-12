;=============================================================================
; yymmdd_to_yydoy
;
;=============================================================================
function yymmdd_to_yydoy, yymmdd

 jd = yymmdd_to_jd(yymmdd)

 yy = strmid(yymmdd, 0, 2)
 
 doy = fix(yymmdd_to_jd(yymmdd) - yymmdd_to_jd(yy+'0101')) + 1
 
 return, yy + str_pad(strtrim(doy,2), 3, al=1.0, c='0')
end
;=============================================================================
