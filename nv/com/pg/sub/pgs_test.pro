;===========================================================================
; pgs_test
;
;===========================================================================
function pgs_test, ps
nv_message, /con, name='pgs_test', 'This routine is obsolete.'

 if(NOT keyword_set(ps)) then return, 0
 if(n_elements(ps) GT 1) then return, 1 

 if(NOT ptr_valid(ps.points_p)) then return, 0

; if(pgs_npoints(ps) EQ 0) then return, 0 

 return, 1
end
;===========================================================================
