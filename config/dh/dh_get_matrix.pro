;===========================================================================
; dh_get_matrix
;
;
;===========================================================================
function dh_get_matrix, dh, keyword, history_index=history_index, $
                        n_obj=n_obj, dim=dim, status=status, section=section

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
 ; create array of matrices
 ;------------------------------------------
 result = dblarr(3,3,n_obj)
 dim=[3,3]

 for i=0, n_obj-1 do $
  begin
   w = where(match_obj EQ i)
   if(w[0] NE -1) then result[*,*,i] = val[w]
  end


 return, reform(result, 3,3,n_obj, /overwrite)
end
;===========================================================================
