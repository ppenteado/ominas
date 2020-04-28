;=============================================================================
; vic_str_pad
;
;=============================================================================
function vic_str_pad, s, n, align=align, c=c

 if(NOT keyword_set(c)) then c = ' '
 if(NOT keyword_set(align)) then align = 0.0

 len = strlen(s) 
 mlen = min(len)

 sp = c
 for i=0, n-mlen-2 do sp = sp + c

 case align of
  0.0 :	result = s + sp
  1.0 :	result = sp + s
  else:	result = strmid(sp, 0, (n-mlen)/2) + s + strmid(sp, 0, (n-mlen)/2)
 endcase

 len = strlen(result)
 w = where(len GT n)
 if(w[0] NE -1) then $
  case align of
   0.0 : result[w] = strmid(result[w], 0, n)
   1.0 : result[w] = strmid_11(result[w], len[w]-n, len[w])
   else: result[w] = strmid(result[w], 0, n)
  endcase

 w = where(strlen(s) EQ n)
 if(w[0] NE -1) then result[w] = s[w]

 return, result
end
;=============================================================================
