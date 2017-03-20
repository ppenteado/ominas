;=============================================================================
; dhh_separate
;
;=============================================================================
pro dhh_separate, dh, dh_history, dh_sections=dh_sections

 dh_history=(dh_updates='')
 dh_sections = 0

 ;----------------------------------
 ; search for sections
 ;----------------------------------
 s = strmid(dh, 0, 1)
 w = where(s EQ '<')
 n = 0
 if(w[0] EQ -1) then return $
 else n = n_elements(w)

 if(n GT 0) then dh_sections = ptrarr(n)

 for i=0, n-1 do $
  if(i LT n-1) then dh_sections[i] = nv_ptr_new(dh[w[i]:w[i+1]-1]) $
  else dh_sections[i] = nv_ptr_new(dh[w[i]:*])


 ;----------------------------------
 ; separate history section
 ;----------------------------------
 dh_history = dh[0:w[0]-1]


end
;=============================================================================



