;===========================================================================
; pgs_valid
;
;  NOTE: some old pgs_valid calls may now work with pgs_test instead
;
;===========================================================================
function pgs_valid, ps, array=array
nv_message, /con, name='pgs_valid', 'This routine is obsolete.'

 if(NOT keyword_set(ps)) then return, 0

 nps = n_elements(ps)
 valid = bytarr(nps)

 w = where(ptr_valid(ps.points_p))
 if(w[0] NE -1) then valid[w] = 1

 return, valid
end
;===========================================================================

