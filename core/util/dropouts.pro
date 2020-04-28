;=============================================================================
; dropouts.pro
;
;  Scans an image for dropped lines.
;
;=============================================================================
function dropouts, image, nmax=nmax, min=min

 if(NOT keyword__set(nmax)) then nmax = 0

 s = size(image)
 nx = s[1]

 bad = 0
 if(keyword_set(min)) then bad = min(image) > 0

 w = where(image EQ bad)
 nw = n_elements(w)
 if(nw LT nx) then return, 0

 done = 0
 n = 0
 repeat $
  begin
   ww = contiguous_indices(w)
   nww = n_elements(ww)

   if(nww GT 1) then $
    begin
     if(nww GE nx) then $
      begin
       y0 = fix(ww[0]/nx)
;       y1 = fix(ww[nww-1]/nx)
       y1 = y0 + fix(nww/nx) + 1
       lines = append_array(lines, tr([y0,y1]))
      end
     if(nww EQ nw) then done = 1 $
     else w = w[nww:*]
     nw = n_elements(w)
    end

   n = n + 1
  endrep until(done OR (n EQ nmax))

 if(NOT keyword__set(lines)) then return, 0

 if(n EQ nmax) then return, 0

 return, tr(lines) 
end
;=============================================================================
