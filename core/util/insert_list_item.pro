;===============================================================================
; insert_list_item
;
;===============================================================================
function insert_list_item, list, index, item
 if(index EQ 0) then return, [item, list]
 if(index EQ n_elements(list)) then return, [list, item]
 return, [list[0:index-1], item, list[index:*]]
end
;===============================================================================


