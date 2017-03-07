;=============================================================================
; dhh_search
;
;=============================================================================
function dhh_search, dh, keyword, lines=lines

 n = strlen(keyword)

 s = strmid(dh, 0, n)
 lines = where(s EQ keyword)

 if(lines[0] EQ -1) then return, ''

 return, dh[lines]
end
;=============================================================================



