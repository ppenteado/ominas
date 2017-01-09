;===========================================================================
; dh_get_string
;
;
;===========================================================================
function dh_get_string, dh, keyword, history_index=history_index, $
                         n_obj=n_obj, dim=dim, status=status, section=section

 status=-1

 ;------------------------------------------
 ; get all values matching the prefix
 ;------------------------------------------
 val = dh_get_value(dh, keyword, history_index=history_index, $
                    /all_match, /all_obj, match_obj=match_obj, section=section)
 if(NOT keyword__set(val)) then return, ''
 status=0

 ;------------------------------------------
 ; determine number of objects
 ;------------------------------------------
 n_obj = max(match_obj)+1

 ;------------------------------------------
 ; create array of scalars
 ;------------------------------------------
 result = strarr(n_obj)
 dim = [1]
 result[match_obj]=val


 return, reform(result, n_obj, /overwrite)
end
;===========================================================================
