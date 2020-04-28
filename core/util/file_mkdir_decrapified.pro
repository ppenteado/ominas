;==============================================================================
; file_mkdir_decrapified
;
;  Like file_mkdir, except suppresses the errors that make file_mkdir unuseable.
;
;==============================================================================
pro file_mkdir_decrapified, dir, _extra=_extra

 catch, error
 if(error NE 0) then $
  begin
   return
   catch, /cancel
  end

 file_mkdir, dir, _extra=_extra

end
;==============================================================================



