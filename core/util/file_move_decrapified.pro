;==============================================================================
; file_move_decrapified
;
;  Like file_move, except suppresses the errors that make file_move unuseable.
;
;==============================================================================
pro file_move_decrapified, src, dst, _extra=_extra

 catch, error
 if(error NE 0) then $
  begin
   return
   catch, /cancel
  end

 file_move, src, dst, _extra=_extra

end
;==============================================================================



