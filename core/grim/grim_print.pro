;=============================================================================
; grim_print
;
;=============================================================================
pro grim_print, arg1, arg2, append=append, prefix=prefix, suffix=suffix

 grim_data = arg1

 if(size(arg1, /type) EQ 7) then $
  begin
   s = arg1
   grim_data = grim_get_data()
  end $
 else s = arg2

 s0 = ''
 if(keyword_set(append)) then widget_control, grim_data.label, get_value=s0

 suff = ''
 if(keyword_set(suffix)) then suff = suffix
 pref = ''
 if(keyword_set(prefix)) then pref = prefix

 widget_control, grim_data.label, set_value=pref+s0+s+suff


end
;=============================================================================



