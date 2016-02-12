;=============================================================================
; cas_time_to_jd
;
;=============================================================================
function cas_time_to_jd, time

 n = n_elements(time)

 yy = fix(strmid(time, 0, 4))
 doy = fix(strmid(time, 5, 3))
 hh = fix(strmid(time, 9, 2))
 mm = fix(strmid(time, 12, 2))
 ss = fix(strmid(time, 15, 6))

 newyear = dblarr(n)

 for i=0, n-1 do newyear[i] = julday(1, 1, yy[i], hh[i], mm[i], ss[i])
 jd = newyear + doy-1

 if(n EQ 1) then jd = jd[0]

 return, jd
end
;=============================================================================
