;=============================================================================
; xwin_event
;
;=============================================================================
pro xwin_event, event

 widget_control, event.top, get_uvalue=data

 if(keyword__set(data.fn)) then call_procedure, data.fn, data, event

end
;=============================================================================



;=============================================================================
; xwin
;
;=============================================================================
pro xwin, wid, fn=fn, xsize=xsize, ysize=ysize, wnum=wnum, widgets=widgets

 if(NOT keyword__set(xsize)) then xsize = 512
 if(NOT keyword__set(ysize)) then ysize = 512
 if(NOT keyword__set(fn)) then fn = ''
 if(NOT keyword__set(wid)) then $
    wid = {type:'slider'}


 base = widget_base(/col, /tlb_size_events)
 draw = widget_draw(base, xsize=xsize, ysize=ysize, /button_events)

 wid_base = widget_base(base, /row, space=0, xpad=0, ypad=0)

 nwid = n_elements(wid)
 widgets = lonarr(nwid)
 for i=0, nwid-1 do $
  begin
   widgets[i] = call_function('widget_'+wid[i].type, wid_base)
  end

 widget_control, base, /realize
 wnum = !window
 widget_control, base, tlb_set_title = 'idl ' + strtrim(wnum, 2)


 data = { $
	 base:		base, $
	 draw:		draw, $
	 wid:		wid, $
	 fn:		fn, $
	 wnum:		wnum $
        }
 widget_control, base, set_uvalue=data


 xmanager, 'xwin', base, /no_block
end
;=============================================================================
