;=============================================================================
; mmm_to_mm
;
;
;=============================================================================
function mmm_to_mm, _mmm

 n = n_elements(_mmm)
 mm = strarr(n)

 mmm = strupcase(_mmm)

 w = where(mmm EQ 'JAN')
 if(w[0] NE -1) then mm[w] = '01'
 w = where(mmm EQ 'FEB')
 if(w[0] NE -1) then mm[w] = '02'
 w = where(mmm EQ 'MAR')
 if(w[0] NE -1) then mm[w] = '03'
 w = where(mmm EQ 'APR')
 if(w[0] NE -1) then mm[w] = '04'
 w = where(mmm EQ 'MAY')
 if(w[0] NE -1) then mm[w] = '05'
 w = where(mmm EQ 'JUN')
 if(w[0] NE -1) then mm[w] = '06'
 w = where(mmm EQ 'JUL')
 if(w[0] NE -1) then mm[w] = '07'
 w = where(mmm EQ 'AUG')
 if(w[0] NE -1) then mm[w] = '08'
 w = where(mmm EQ 'SEP')
 if(w[0] NE -1) then mm[w] = '09'
 w = where(mmm EQ 'OCT')
 if(w[0] NE -1) then mm[w] = '10'
 w = where(mmm EQ 'NOV')
 if(w[0] NE -1) then mm[w] = '11'
 w = where(mmm EQ 'DEC')
 if(w[0] NE -1) then mm[w] = '12'



 return, mm
end
;=============================================================================
