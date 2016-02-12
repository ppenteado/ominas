;================================================================================
; str_comma_list
;
;================================================================================
function str_comma_list, ss, delim=delim

 if(NOT keyword_set(delim)) then delim = ','
 return, strjoin(ss, delim)
end
;================================================================================



;================================================================================
; str_comma_list
;
;================================================================================
function __str_comma_list, _x, delim=delim

 if(NOT keyword_set(delim)) then delim = ','

 w = where(strtrim(_x,2) NE '')
 if(w[0] EQ -1) then return, ''

 x = _x[w]

 nx = n_elements(x)

 s = ''
 for i=0, nx-2 do s = s + strtrim(x[i],2) + delim
 s = s + strtrim(x[nx-1],2)

 return, s
end
;================================================================================



