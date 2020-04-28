;===============================================================================
; mv_list_item
;
;===============================================================================
function mv_list_item, list, index, _new_index

 new_index = _new_index
 if(new_index GT index) then new_index = new_index + 1

 n = n_elements(list)
 indices = lindgen(n)

 indices[index] = -1

 indices = insert_list_item(indices, new_index, index)

 w = where(indices EQ -1)
 indices = rm_list_item(indices, w)

 return, list[indices]
end
;===============================================================================

