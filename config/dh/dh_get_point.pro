;===========================================================================
; dh_get_point
;
;
;===========================================================================
function dh_get_point, dh, keyword, history_index=history_index, $
              n_obj=n_obj, dim=dim, ndv=ndv, status=status, section=section

 status=-1

 ;------------------------------------------
 ; get all values matching the prefix
 ;------------------------------------------
 val = dh_get_value(dh, keyword, history_index=history_index, $
                  /all_match, /all_obj, match_obj=match_obj, section=section)
 if(NOT keyword__set(val)) then return, 0
 status=0

 type = size(val, /type)

 ;------------------------------------------
 ; determine number of objects
 ;------------------------------------------
 n_obj = max(match_obj)+1

 ;------------------------------------------
 ; create array of points
 ;------------------------------------------
 for i=0, n_obj-1 do $
  begin
   w = where(match_obj EQ i)
   if(w[0] NE -1) then $
    begin
     if(NOT keyword__set(result)) then $
      begin
       ndv = n_elements(w)/2
;       result = dblarr(2,ndv,n_obj)
       result = make_array(2,ndv,n_obj, type=type)
       dim=[2,ndv]
      end

     result[*,*,i] = val[w]
    end
  end


 return, reform(result, 2,ndv,n_obj, /overwrite)
end
;===========================================================================
