;=============================================================================
; to_dec
;
;=============================================================================
function to_dec, s, hexadecimal=hexadecimal, octal=octal

 if(keyword_set(hexadecimal)) then code = 'Z'
 if(keyword_set(octal)) then code = 'O'

 n = n_elements(s)
 y = intarr(n)

 yy = 0l
 for i=0, n-1 do $
  begin
   reads, s[i], yy, format='(' + code + ')'
   y[i] = yy
  end

 return, y
end
;=============================================================================
