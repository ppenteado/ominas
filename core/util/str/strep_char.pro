;=============================================================================
; strep_char
;
;  Replaces every occurence of character c in string s with character cc.
;
;=============================================================================
function strep_char, s, c, cc

 bs = byte(s)
 bc = byte(c)
 bcc = byte(cc)

 w = where(bs EQ bc[0])
 if(w[0] EQ -1) then return, s

 bs[w] = bcc[0]

 return, string(bs)
end
;=============================================================================
