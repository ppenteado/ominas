;=============================================================================
; selgen
;
; Generates an array of subscripts to select only the desired column n-vectors
; from an array with dimensions nv x n x nt.  w is a 1-d array of nv subscripts
; selecting from the (nv x nt) column vectors.  The resulting array has
; dimensions nv x n.
;
;=============================================================================
function selgen, nv, n, nt, w

 nw = n_elements(w)

 ww = lonarr(nv,n)

 ww[*,0] = w * nv*n + lindgen(nv)
 for i=1, n-1 do ww[*,i] = ww[*,i-1] + nv

 return, ww
end
;=============================================================================
