;===========================================================================
; clset
;
;  NOTE -- This routine is provided for diagnostic purposes, allowing one
;          to conveniently inspect the fields in a descriptor.  It should
;	   NEVER be used in actual code because it circumvents the object
;          methods.
;
;
;===========================================================================
pro clset, odp, tag_name, value, found=found
 class_set_field, odp, tag_name, value, found=found
end
;===========================================================================
