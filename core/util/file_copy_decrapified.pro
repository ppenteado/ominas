;==============================================================================
; file_copy_decrapified
;
;  Like file_copy, except suppresses the errors that make file_copy unuseable.
;
;==============================================================================
pro file_copy_decrapified, src, dst, _extra=_extra

 catch, error
 if(error NE 0) then $
  begin
   return
   catch, /cancel
  end

 file_copy, src, dst, _extra=_extra

end
;==============================================================================



