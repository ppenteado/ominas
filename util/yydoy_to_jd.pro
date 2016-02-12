;=============================================================================
; yydoy_to_jd
;
;=============================================================================
function yydoy_to_jd, yydoy, century=century

 if(NOT keyword__set(century)) then century = 1900

 yy = long(strmid(yydoy, 0, 2))

 w = where(yy LT 50)
 if(w[0] NE -1) then yy[w] = yy[w] + 100
 yy = century + yy

 s = str_decomp(yydoy)
 doy = long(str_recomp(s[2:*,*]))

; newyear = julday(1, 1, yy, 0, 0, 0)
 nyy = n_elements(yy)
 newyear = dblarr(nyy)
 for i=0, nyy-1 do newyear[i] = julday(1, 1, yy[i], 0, 0, 0)

 jd = newyear + doy-1
 return, jd
end
;=============================================================================
