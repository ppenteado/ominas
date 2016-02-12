;===========================================================================
; textedit_event
;
;===========================================================================
pro textedit_event, event

 txt = widget_info(event.id, /child)
 widget_control, txt, scr_xsize=event.x, scr_ysize=event.y

end
;===========================================================================



;===========================================================================
; textedit
;
;===========================================================================
function textedit, text, xsize=xsize, ysize=ysize, base=base, $
   editable=editable, resource_prefix=resource_prefix

 if(NOT keyword__set(xsize)) then xsize = 80
 if(NOT keyword__set(ysize)) then ysize = 25

 ;------------------------------
 ; widgets
 ;------------------------------
 base = widget_base(/tlb_size_events, $
                         resource_name=resource_prefix + '_base')
 txt = widget_text(base, xsize=xsize, ysize=ysize, $
                    /scroll, /wrap, editable=editable, $
                         resource_name=resource_prefix + '_text')
 widget_control, txt, set_value = text


 widget_control, base, /realize

 xmanager, 'textedit', base, /no_block

 return, txt
end
;===========================================================================
