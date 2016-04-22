;===========================================================================
; class_get_field
;
;  NOTE -- This routine is provided for diagnostic purposes, allowing one
;          to conveniently inspect the fields in a descriptor.  It should
;	   NEVER be used in actual code because it circumvents the object
;          methods.
;
;
;===========================================================================
function class_get_field, odp, tag_name, found=found, noevent=noevent
 ods = nv_dereference(odp)
 nv_notify, ods, type = 1, noevent=noevent

 found = 1
 _ods = ods

 while (size(_ods, /type) EQ 8) do $
  begin
   od=_ods[0]
   tags = tag_names(od)
   ntags = n_elements(tags)
   for i=0, ntags-1 do if(tags[i] EQ strupcase(tag_name)) then return, _ods.(i)
   _ods = _ods.(0)
   if(ptr_valid(_ods[0])) then _ods = nv_dereference(_ods)
  end 


 found = 0
 return, 0
end
;===========================================================================
