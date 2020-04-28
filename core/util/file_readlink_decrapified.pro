;==============================================================================
; file_readlink_decrapified
;
;  Like file_readlink, except suppresses the errors that make file_readlink unuseable.
;
;==============================================================================
function file_readlink_decrapified, link, _extra=_extra

 catch, error
 if(error NE 0) then $
  begin
   return, ''
   catch, /cancel
  end

 return, file_readlink(link, _extra=_extra)

end
;==============================================================================



