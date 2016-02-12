;=============================================================================
; str_isfloat
;
;=============================================================================
function str_isfloat, ss

 nss = n_elements(ss)

 bb = byte(ss)
 nn = n_elements(bb)/nss
 w = where((bb NE 0) AND (bb NE 46) AND (bb NE 45) AND ((bb LT 48) OR (bb GT 57)))
 if(w[0] EQ -1) then return, lindgen(nss)
 ww = fix(w/nn)
 ww = ww[uniq(ww)]
 www = complement(ss, ww)

 return, www
end
;=============================================================================
