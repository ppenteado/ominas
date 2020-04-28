;=============================================================================
; yymmdd_to_jd
;
;  Assumes years < 50 are + 2000.
;
;=============================================================================
function yymmdd_to_jd, yymmdd, century=century

 if(NOT keyword__set(century)) then century = 1900

 n = n_elements(yymmdd)

 yy = fix(strmid(yymmdd, 0, 2))
 mm = fix(strmid(yymmdd, 2, 2))
 dd = fix(strmid(yymmdd, 4, 2))

 w = where(yy LT 50)
 if(w[0] NE -1) then yy[w] = yy[w] + 100
 yy = century + yy


 jd = dblarr(n)
 for i=0, n-1 do jd[i] = julday(mm[i], dd[i], yy[i])

 return, jd
end
;=============================================================================
