;==============================================================================
; pr_combine
;
;==============================================================================
function pr_combine, p, seg_ps, sub_ps, used

 nsegs = n_elements(seg_ps)
 n = n_elements(p)/2 

 pp = dblarr(2,n, /nozero)
 sub = lonarr(n)
 order = 0
 iii = -1
 ii = 0

; for i=0, nsegs-1 do if(NOT is_member(i, used)) then $
 for i=0, nsegs-1 do $
  begin
   pii = *seg_ps[ii]
   subii = *sub_ps[ii]
   npii = n_elements(pii)/2

   if(order) then $
    begin
     pii = rotate(pii,7)
     subii = rotate(subii,2)
    end

   iii = max(iii) + 1 + lindgen(npii)
   pp[*,iii] = pii
   sub[iii] = subii

   used = append_array(used, [ii])
   tried = append_array(tried, [ii])

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; find segment with end closest to end of this segment
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   dd2min = 1d100
   pii_start = pii[*,0]
   pii_end = pii[*,npii-1]
   for j=0, nsegs-1 do if(NOT is_member(j, tried)) then $
    begin
     pj = *seg_ps[j]
     npj = n_elements(pj)/2

     pj_start = pj[*,0]
     pj_end = pj[*,npj-1]

     dd2_start_end = total((pj_start - pii_end)^2)
     dd2_end_end = total((pj_end - pii_end)^2)
     dd2_start_start = total((pj_start - pii_start)^2)
     dd2_end_start = total((pj_end - pii_start)^2)

     if(dd2_start_end LE dd2min) then $
      begin
       ii = j
       order = 0
       dd2min = dd2_start_end
      end

     if(dd2_end_end LE dd2min) then $
      begin
       ii = j
       order = 1
       dd2min = dd2_end_end
      end

     if(dd2_end_start LE dd2min) then $
      begin
       ii = j
       order = 0
       dd2min = dd2_end_start
      end

     if(dd2_start_start LE dd2min) then $
      begin
       ii = j
       order = 1
       dd2min = dd2_start_start
      end

    end
  end

 return, pp
end
;==============================================================================



;==============================================================================
; poly_rectify
;
;  This routine assumes that the given vertices are piecewise consecutive.
;
;==============================================================================
function poly_rectify, p, lengths, sub=sub

 n = n_elements(p)/2 
 sub = lindgen(n_elements(p)/2)

 if(keyword_set(lengths)) then $
  begin
   nsegs = n_elements(lengths)   
   w = lonarr(nsegs)
   w[0] = lengths[0]-1
   if(nsegs GT 0) then for i=1, nsegs-1 do w[i] = w[i-1] + lengths[i]
  end $
 else $
  begin
   ;----------------------------------------------------
   ; compute avg distance between consecutive points
   ;----------------------------------------------------
   d2 = total((p - shift(p, 0,-1))^2, 1)
   d2_avg = mean(d2)
;d2_avg = median(d2)
   d2max = max(d2)

   ;----------------------------------------------------
   ; find segment boundaries 
   ;----------------------------------------------------
   w = where(d2 GT d2_avg*10)
   if(n_elements(w) EQ 1) then return, p
   nsegs = n_elements(w)
  end

 ;----------------------------------------------------
 ; extract segments 
 ;----------------------------------------------------
 seg_ps = ptrarr(nsegs) 
 sub_ps = ptrarr(nsegs)

 w = [-1,w]

 for i=0, nsegs-1 do $
  begin
   nn = w[i+1]-w[i] 
   ii = lindgen(nn) + w[i] + 1
   seg_ps[i] = nv_ptr_new(p[*,ii])
   sub_ps[i] = nv_ptr_new(ii)
  end

 ;----------------------------------------------------
 ; combine segments 
 ;----------------------------------------------------
 pp = pr_combine(p, seg_ps, sub_ps, used)

 return, pp
end
;==============================================================================

