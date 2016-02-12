;=============================================================================
; str_isvar
;
;=============================================================================
function str_isvar, ss

 nss = n_elements(ss)

 bb = byte(ss)
 nn = n_elements(bb)/nss
 w = where((bb NE 95) AND $
         ( (bb LT 48) OR (bb GT 122) OR $
               ((bb GT 90) AND (bb LT 97)) OR ((bb GT 57) AND (bb LT 65)) ))
 if(w[0] EQ -1) then return, lindgen(nss)
 ww = fix(w/nn)
 ww = ww[uniq(ww)]
 www = complement(ss, ww)

 return, www
end
;=============================================================================
