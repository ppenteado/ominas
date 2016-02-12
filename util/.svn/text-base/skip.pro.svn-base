;============================================================================
; skip
;
;  Returns every jth element of array x.
;
;============================================================================
function skip, x, j, offset=offset

 if(NOT keyword_set(j)) then j = 0

 n = n_elements(x)
 if(n LT j) then return, x[0]

 i = lindgen(n/j)*j 

 if(keyword_set(offset)) then i = i + offset

 return, x[i]
end
;============================================================================
