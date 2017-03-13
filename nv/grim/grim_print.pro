;=============================================================================
; grim_print
;
;=============================================================================
pro grim_print, arg1, arg2, append=append

 grim_data = arg1

 if(size(arg1, /type) EQ 7) then $
  begin
   s = arg1
   grim_data = grim_get_data()
  end $
 else s = arg2

 s0 = ''
 if(keyword_set(append)) then widget_control, grim_data.label, get_value=s0

 widget_control, grim_data.label, set_value=s0+s 


end
;=============================================================================



