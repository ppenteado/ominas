;=============================================================================
; str_tailnum
;
;  Determines which strings have numbers at the end.
;
;=============================================================================
function str_tailnum, s, num=num, w_sort=w_sort

 result = -1

 ns = n_elements(s)

 b = byte(s)
 nb = n_elements(b)/ns

 w = where((b GT 0) AND ((b LT 48) OR (b GT 57)))

 i = fix(w/nb)			; s[i] have numbers in them
 ii = w mod nb			; b[ii,i] is numeric
 
 ww = uniq(i)			; ii[ww] is max pos for non-numeric char 
				; i[ww]	gives strings with non-num chars.

 l = (strlen(s))[i[ww]]		; len of strings with non-numeric chars.

 nn = l - ii[ww] - 1		; len of tailing numeric strings
 w = where(nn GT 0)



 if(w[0] NE -1) then $
  begin
   ss = s[w]
   ss = ss[sort(ss)]
   base = str_nnsplit(ss, pos=ii[ww[w]], rem=num)
   uu = uniq(base)
   base = base[uu] & num = num[uu]
   w_sort = i[ww[w[uu]]]
  end


 return, w
end
;=============================================================================
