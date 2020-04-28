;=============================================================================
; ctg_separate
;
;=============================================================================
pro ctg_separate, xx, ii, iip
 
 x = xx[ii]

 nx = n_elements(x)
 if(nx LT 3) then  $
  begin
   iip = append_array(iip, ptr_new(ii))
   return
  end

 dx = x-shift(x,-1)
 dxmed = abs(median(dx))
 sig = stdev(dx[0:nx-2])

 w = where(abs(dx)-dxmed GT 3*sig)
 nw = n_elements(w)

 if(nw EQ 1) then $
  begin
   iip = append_array(iip, ptr_new(ii))
   return
  end

 pp = 0 
 for i=0, nw-1 do $
  begin
   qq = w[i]
   ctg_separate, x, ii[pp:qq], iip
   pp = qq + 1
  end

end
;=============================================================================



;=============================================================================
; contiguous
;
;  Returns indices of contiguous segments.  
;  Returned pointers must be freed by caller.
;  Input points must be sorted.
;
;  Recurses until local variations within each segment are below local stdev.
;
;=============================================================================
function contiguous, x

 iip = 0
 ctg_separate, x, lindgen(n_elements(x)), iip

 return, iip
end
;=============================================================================





