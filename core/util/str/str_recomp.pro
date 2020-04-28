;=============================================================================
; str_recomp
;
;  Converts RD array of characters into 1D array of strings.
;
;=============================================================================
function str_recomp, s

 b = byte(s)
 dim = size(b, /dim)
 if(n_elements(dim) EQ 2) then dim = [dim,1] 

 bb = reform(b, dim[1], dim[2], /over)

 return, string(bb)
end
;=============================================================================
