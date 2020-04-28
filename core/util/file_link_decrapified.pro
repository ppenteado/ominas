;==============================================================================
; file_link_decrapified
;
;  Like file_link, except suppresses the errors that make file_link unuseable.
;
;==============================================================================
pro file_link_decrapified, src, dst, _extra=_extra

 catch, error
 if(error NE 0) then $
  begin
   return
   catch, /cancel
  end

 file_link, src, dst, _extra=_extra

end
;==============================================================================



