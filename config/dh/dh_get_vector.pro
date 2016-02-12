;===========================================================================
; dh_get_vector
;
;
;===========================================================================
function dh_get_vector, dh, keyword, n_obj=n_obj, dim=dim, ndv=ndv, $
                  section=section, status=status, history_index=history_index

 status=-1

 ;------------------------------------------
 ; get all values matching the prefix
 ;------------------------------------------
 val = dh_get_value(dh, keyword, history_index=history_index, $ 
                   /all_match, /all_obj, match_obj=match_obj, section=section)
 if(NOT keyword__set(val)) then return, 0
 status=0

 ;------------------------------------------
 ; determine number of objects
 ;------------------------------------------
 n_obj = max(match_obj)+1

 ;------------------------------------------
 ; create array of vectors
 ;------------------------------------------
 for i=0, n_obj-1 do $
  begin
   w = where(match_obj EQ i)
   if(w[0] NE -1) then $
    begin
     if(NOT keyword__set(result)) then $
      begin
       ndv = n_elements(w)/3
       result = dblarr(ndv,3,n_obj)
       dim=[ndv,3]
      end

     result[*,*,i] = val[w]
    end
  end


 return, reform(result, ndv,3,n_obj, /overwrite)
end
;===========================================================================
