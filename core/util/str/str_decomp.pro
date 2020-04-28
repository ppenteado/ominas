;=============================================================================
; str_decomp
;
;  Converts 1D array of strings into 2D array of characters.
;
;=============================================================================
function str_decomp, s

 b = byte(s)
 dim = size(b, /dim)
 if(n_elements(dim) EQ 1) then dim = [dim,1]

 bb = reform(b, 1, dim[0], dim[1], /over)

 return, string(bb)
end
;=============================================================================
