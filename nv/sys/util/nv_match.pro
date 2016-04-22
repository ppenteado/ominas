;===========================================================================
; nv_match
;
;===========================================================================
function nv_match, list, items

 n = n_elements(items)

 result = strarr(n)

 for i=0, n-1 do result[i] = filematch(list, items[i])

 w = where(result NE '')
 if(w[0] EQ -1) then return, ''
 return, result[w]
end
;===========================================================================
