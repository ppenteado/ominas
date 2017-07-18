;=============================================================================
; pgs_name_sort
;
;
;=============================================================================
function pgs_name_sort, _names

 names = strtrim(_names,2)

 n_names = n_elements(names)
 return_subs = lindgen(n_names)

 i=0
 repeat $
  begin
   w = where(names EQ names[i])

   if(n_elements(w) GT 1) then $
    begin
     retain_subs = complement(names, w[1:*])
     names = names[retain_subs] 
     return_subs = return_subs[retain_subs] 
    end

   n_names = n_elements(names) 
   i=i+1
  endrep until(i GE n_names)


 return, return_subs
end
;=============================================================================
