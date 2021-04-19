;=============================================================================
; poly_fillv
;
;  Like polyfillv, but more efficient calling interface, and coordinate 
;  system is fixed.
;
;=============================================================================
function poly_fillv, p, dim, run_length
 return, polyfillv(p[0,*]+1, p[1,*]+1, dim[0], dim[1]);, run_length)
end
;=============================================================================
