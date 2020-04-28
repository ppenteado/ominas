;=============================================================================
; tag_list_match
;
;=============================================================================
function tag_list_match, tlp, name, prefix=prefix

 if(size(tlp, /type) EQ 10) then names = (*tlp).name $
 else names = tlp

 if(NOT keyword__set(prefix)) then return,  where(name EQ names)

 return, where(strpos(names, name) EQ 0)
end
;=============================================================================


