;===========================================================================
; tag_list_clone
;
;===========================================================================
function tag_list_clone, tlp

 if(NOT ptr_valid(tlp)) then return, ptr_new()

 list = *tlp

 n = n_elements(list)

 new_list = list

 for i=0, n-1 do new_list[i].data_p = ptr_copy_recurse(list[i].data_p)

 return, nv_ptr_new(new_list)
end
;===========================================================================
