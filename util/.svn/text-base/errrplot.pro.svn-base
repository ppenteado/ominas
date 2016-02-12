;=============================================================================
; errrplot
;
;
;=============================================================================
pro errrplot, x, y, sigx=sigx, sigy=sigy, color=color


 n = n_elements(x)

 for i=0, n-1 do $
  begin
   if(keyword_set(sigx)) then $
    begin
     oplot, [x[i]-sigx[i], x[i]+sigx[i]], [y[i], y[i]], color=color
    end

   if(keyword_set(sigy)) then $
    begin
     oplot, [x[i], x[i]], [y[i]-sigy[i], y[i]+sigy[i]], color=color
    end

  end


end
;=============================================================================
