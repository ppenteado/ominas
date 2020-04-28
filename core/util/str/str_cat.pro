;=============================================================================
; str_cat
;
;  Concatenates an array of strings into one string.
;
;=============================================================================
function str_cat, s, insert=insert

 if(n_elements(insert) EQ 0) then insert = ''

 n = n_elements(s)
 ss = s[0]
 for i=1, n-1 do ss = ss + insert + s[i]

 return, string(ss)
end
;=============================================================================
