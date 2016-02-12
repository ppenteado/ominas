;==============================================================================
; nv_override	**obsolete**
;
;==============================================================================
pro nv_override, _name, filename
@nv_block.common

 tags = tag_names(nv_state)
 name = _name + '_filename'

 w = where(tags EQ strupcase(name))
 if(w[0] EQ -1) then return

 nv_state.(w[0]) = filename
end
;==============================================================================
