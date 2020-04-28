;=============================================================================
; ddmmmyyyy_to_jd
;
;  Assumes years < 50 are + 2000.
;
;=============================================================================
function ddmmmyyyy_to_jd, ddmmmyyyy

 n = n_elements(ddmmmyyyy)

 dd = fix(strmid(ddmmmyyyy, 0, 2))
 mmm = fix(mmm_to_mm(strmid(ddmmmyyyy, 2, 3)))
 yy = fix(strmid(ddmmmyyyy, 5, 4))


 jd = dblarr(n)
 for i=0, n-1 do jd[i] = julday(mmm[i], dd[i], yy[i])


 return, jd
end
;=============================================================================
