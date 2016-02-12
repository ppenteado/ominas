;===========================================================================
; class_get_field_names

;===========================================================================
function class_get_field_names, xd
 names = tag_names(*(xd[0]))
 if(n_elements(names) LE 2) then names = '' $
 else names = names[2:*]
 return, names
end
;===========================================================================
