;===========================================================================
; dh_get_sclarr
;
;
;===========================================================================
function dh_get_sclarr, dh, keyword, n_obj=n_obj, dim=dim, ndv=ndv, $
                  section=section, status=status, history_index=history_index

 status=-1

 ;------------------------------------------
 ; get all values matching the prefix
 ;------------------------------------------
 val = dh_get_value(dh, keyword, history_index=history_index, $ 
                   /all_match, /all_obj, match_obj=match_obj, section=section)
 if(NOT keyword_set(val)) then return, 0
 status=0

 ;------------------------------------------
 ; determine number of objects
 ;------------------------------------------
 n_obj = max(match_obj)+1
 type = size(val, /type)
 if(type NE 7) then type = 5

 ;------------------------------------------
 ; create array of vectors
 ;------------------------------------------
 for i=0, n_obj-1 do $
  begin
   w = where(match_obj EQ i)
   if(w[0] NE -1) then $
    begin
     if(NOT keyword_set(result)) then $
      begin
       nj = n_elements(w)
       result = make_array(nj,n_obj, type=type)
       dim=[nj]
      end

     result[*,i] = val[w]
    end
  end


 return, reform(result, nj,n_obj, /overwrite)
end
;===========================================================================
