;===========================================================================
; clget
;
;  NOTE -- This routine is provided for diagnostic purposes, allowing one
;          to conveniently inspect the fields in a descriptor.  It should
;	   NEVER be used in actual code because it circumvents the object
;          methods.
;
;===========================================================================
function clget, odp, tag_name, found=found
 return, class_get_field(odp, tag_name, found=found)
end
;===========================================================================
