;===========================================================================
; class_set_field
;
;  NOTE -- This routine is provided for diagnostic purposes, allowing one
;          to conveniently inspect the fields in a descriptor.  It should
;	   NEVER be used in actual code because it circumvents the object
;          methods.
;
;
;===========================================================================
pro class_set_field, odp, tag_name, value, found=found, noevent=noevent
 ods = nv_dereference(odp)

 found = 1
 _odp = odp
 _ods = ods

 while (size(_ods, /type) EQ 8) do $
  begin
   od=_ods[0]
   tags = tag_names(od)
   ntags = n_elements(tags)
   for i=0, ntags-1 do if(tags[i] EQ strupcase(tag_name)) then $
    begin
     _ods.(i) = value
     nv_rereference, _odp, _ods
     nv_notify, _odp, type = 0, noevent=noevent
     return
    end
   _odp = _ods.(0)
   if(ptr_valid(_odp)) then _ods = nv_dereference(_odp)
  end 


 found = 0

end
;===========================================================================




; rd = rds0[0]
; clset, rd, 'pos', tr([1,2,3d])
; help, *rd
; print, clget(rd, 'pos')
