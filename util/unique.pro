;================================================================================
; unique
;
;================================================================================
function unique, _x, ss, sort=sort, reverse_indices=iii

 if(keyword_set(sort)) then ss = sort(_x)

 if defined(ss) then x = _x[ss] $
 else x = [_x]

 d  = shift(x, -1) - x
 ii = where(d NE 0)

 if(ii[0] EQ -1) then ii = n_elements(x)-1

 if(arg_present(iii)) then $
  begin
   n = n_elements(x)

   iii = long(total(d<1, /cum))
   iii = [0,iii[0:n-2]]

   iii = reform(iii, size(_x, /dim), /over)
  end

 return, ii
end
;================================================================================

; u = unique(x, rev=ii)
; xx=x[u]
; xx[ii] should = x
