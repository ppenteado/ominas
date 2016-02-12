;==============================================================================
; w_to_nd
;
;  result is [nd,n]
;
;==============================================================================
function w_to_nd, _dim, _w

 w = _w
 dim = _dim

 nd = (nd0 = n_elements(dim))
 p = lonarr(nd)

 for i=nd0-1, 1, -1 do $
  begin
   prod = long(prod(dim[0:nd-2]))
   p[i] = w / prod
   w = w mod prod
   dim = dim[0:i-1]
   nd = n_elements(dim)
  end
 p[0] = w

 return, p
end
;==============================================================================
