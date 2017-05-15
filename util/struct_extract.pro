;===========================================================================
; struct_extract
;
;===========================================================================
function struct_extract, struct, prefix

 len = strlen(prefix)
 tags = tag_names(struct)

 w = where(strmid(tags, 0, len) EQ prefix)
 if(w[0] EQ -1) then return, !null

 for i=0, n_elements(w)-1 do $
     new_struct = append_struct(new_struct, $
                       create_struct(strmid(tags[w[i]], len, 256), struct.(w[i])))

 return, new_struct
end
;===========================================================================
