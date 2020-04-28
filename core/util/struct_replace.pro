;=============================================================================
; struct_replace
;
;=============================================================================
function struct_replace, struct, tag, val

 tag_struct = create_struct(tag, val)
 if(NOT keyword_set(struct)) then return, tag_struct

 tags = tag_names(struct)
 w = where(tags EQ strupcase(tag))
 if(w[0] EQ -1) then return, append_struct(struct, tag_struct) 

 return, append_struct(struct_select(struct, w[0], /rm), tag_struct)
end
;=============================================================================
