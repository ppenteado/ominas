;=============================================================================
; correlate_pairs
;
;  returns -1 if no more than one point per bin or if more than one bin
;  contains the max. number of points.
;
;=============================================================================
function correlate_pairs, _pairs, radius, complement=complement, mm=mm

 pairs = _pairs

 dim = size(pairs, /dim)
 ndim = n_elements(dim)
 if(ndim EQ 3) then $
  begin
   s = size(pairs)
   nx = dim[1] & ny = dim[2]
   pairs = reform(pairs, 2, nx*ny, /over)
  end

 n = n_elements(pairs)/2

 ;-------------------------------------
 ; associate pairs with histogram bins
 ;-------------------------------------
 indices = lindgen(n)
 bins = lonarr(n)
; bin = 2.*radius
 bin = 1.1*radius
 xx = pairs[0,*] & yy = pairs[1,*]
 hh = hist__2d(xx, yy, rev=ii, bin1=bin, bin2=bin, $
               max1=max(xx), max2=max(yy), min1=min(xx), min2=min(yy))
;tvim , hh, /new, z=10
 mm = max(hh)
 if(mm EQ 1) then return, -1	; no solution if only one point per bin


 ;----------------------------------------------
 ; map bins/pairs to histogram locations
 ;----------------------------------------------
; for i=1, mm do $
 for i=2, mm do $
  begin
   w = where(hh EQ i)
   j=0l
   if(w[0] NE -1) then $
    while(j LT n_elements(w)) do $
     begin
      a = ii[w[j]]
      b = ii[w[j]+1]
      if(a NE b) then $
       begin
        ss = ii[a:b-1]
        bins[ss] = w[j]
       end
      j = j + 1
     end 
  end


 ;------------------------------------------------------------------------
 ; Compute distances from peak
 ;  If multiple solutions, accept the one corresponding to the smallest 
 ;  scatter.
 ;------------------------------------------------------------------------
 w = where(hh EQ mm)
 r2_avg_min = 1d100


 nw = n_elements(w)
 for i=0, nw-1 do $
  begin
   ww = where(bins EQ w[i])
   if(ww[0] EQ -1) then return, -1

   nww = n_elements(ww)
   pp = total(pairs[*,ww],2)/nww # make_array(nww, val=1d)	; mean offset
   r2 = total((pairs[*,ww] - pp)^2, 1)

   if(NOT keyword__set(complement)) then www = where(r2 LE radius^2) $
   else www = where(r2 GT radius^2)

   if(n_elements(www) GT 1) then $
    begin
     nwww = n_elements(www)
     r2 = r2[www]

     r2_avg = mean(r2)

     if(r2_avg LT r2_avg_min) then $
      begin
       result = indices[ww[www]]
       r2_avg_min = r2_avg
      end
    end
  end




; nw = n_elements(w)
; for i=0, nw-1 do $
;  begin
;   ww = where(bins EQ w[i])
;   if(ww[0] EQ -1) then return, -1
;   nww = n_elements(ww)
;   pp = total(pairs[*,ww],2)/nww # make_array(n, val=1d)	; mean offset
;   r2 = total((pairs - pp)^2, 1)

;   ;------------------------------------------------
;   ; accept only pairs near the most frequent
;   ;------------------------------------------------
;   if(NOT keyword__set(complement)) then www = where(r2 LE radius^2) $
;   else www = where(r2 GT radius^2)

;   if(n_elements(www) GT 1) then $
;    begin
;     nwww = n_elements(www)
;     r2_avg = total( (total(pairs[*,www], 2)/nwww)^2 )

;     if(r2_avg LT r2_avg_min) then $
;      begin
;      result = indices[www]
;       r2_avg_min = r2_avg
;      end
;    end
;  end



 if(NOT keyword__set(result)) then return, -1
 return, result
end
;=============================================================================
