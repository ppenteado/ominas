;=============================================================================
; grim_mode_readout_print
;
;=============================================================================
pro grim_mode_readout_print, grim_data, s
 grim_print, grim_data, prefix='[READOUT] ', s
end
;=============================================================================



;=============================================================================
; grim_mode_readout_bitmap
;
;=============================================================================
function grim_mode_readout_bitmap

 return, [                               $
                [255B, 255B],                   $
                [255B, 253B],                   $
                [255B, 253B],                   $
                [255B, 253B],                   $
                [255B, 253B],                   $
                [255B, 255B],                   $
                [015B, 135B],                   $
                [255B, 255B],                   $
                [255B, 253B],                   $
                [201B, 253B],                   $
                [255B, 253B],                   $
                [193B, 253B],                   $
                [255B, 255B],                   $
                [165B, 255B],                   $
                [255B, 255B],                   $
                [255B, 255B]                    $
                ]

end
;=============================================================================



;=============================================================================
; grim_mode_readout_cursor_default
;
;=============================================================================
pro grim_mode_readout_cursor_default, grim_data, swap=swap



 mask = byte_to_bit([ [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,0,1] ,[0,0,0,0,0,0,0,0]], $
                      [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                      [[1,1,1,1,1,1,0,0] ,[0,1,1,1,1,1,1,0]], $
                      [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                      [[0,0,0,0,0,0,0,1] ,[0,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0]] ] $
                    )

 bitmap = byte_to_bit([ [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,0,1] ,[0,0,0,0,0,0,0,0]], $
                        [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                        [[0,0,0,0,0,1,0,0] ,[0,1,0,0,0,0,0,0]], $
                        [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                        [[0,0,0,0,0,0,0,1] ,[0,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0]] ] $
                    )

 device, cursor_mask=swap_endian(mask), cursor_image=swap_endian(bitmap), $
                                                            cursor_xy = [7,8]
;                                                            cursor_xy = [2,13]


 grim_mode_readout_print, grim_data, '{Point} L:Pixel R:Measure'
end
;=============================================================================



;=============================================================================
; grim_mode_readout_cursor_region
;
;=============================================================================
pro grim_mode_readout_cursor_region, grim_data, swap=swap



 mask = byte_to_bit([ [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,1,1,1,1,1,1,1] ,[1,1,1,1,1,1,0,0]], $
                      [[0,1,1,1,1,1,1,1] ,[1,1,1,1,1,1,0,0]], $
                      [[0,1,1,1,1,1,1,1] ,[1,1,1,1,1,1,0,0]], $
                      [[0,1,1,1,0,0,0,1] ,[0,0,0,1,1,1,0,0]], $
                      [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                      [[1,1,1,1,1,1,0,0] ,[0,1,1,1,1,1,1,0]], $
                      [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                      [[0,1,1,1,0,0,0,1] ,[0,0,0,1,1,1,0,0]], $
                      [[0,1,1,1,1,0,1,1] ,[1,0,1,1,1,1,0,0]], $
                      [[0,1,1,1,1,1,1,1] ,[1,1,1,1,1,1,0,0]], $
                      [[0,1,1,1,1,1,1,1] ,[1,1,1,1,1,1,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0]] ] $
                    )

 bitmap = byte_to_bit([ [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,1,1,1,1,1,0] ,[1,1,1,1,1,0,0,0]], $
                        [[0,0,1,0,0,0,1,0] ,[1,0,0,0,1,0,0,0]], $
                        [[0,0,1,0,0,0,0,1] ,[0,0,0,0,1,0,0,0]], $
                        [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                        [[0,0,0,0,0,1,0,0] ,[0,1,0,0,0,0,0,0]], $
                        [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                        [[0,0,1,0,0,0,0,1] ,[0,0,0,0,1,0,0,0]], $
                        [[0,0,1,0,0,0,1,0] ,[1,0,0,0,1,0,0,0]], $
                        [[0,0,1,1,1,1,1,0] ,[1,1,1,1,1,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0]] ] $
                    )

 device, cursor_mask=swap_endian(mask), cursor_image=swap_endian(bitmap), $
                                                            cursor_xy = [7,8]
;                                                            cursor_xy = [2,13]


 grim_mode_readout_print, grim_data, '{Region} L:Rectangle R:Irregular'
end
;=============================================================================



;=============================================================================
; grim_mode_readout_cursor_fixed
;
;=============================================================================
pro grim_mode_readout_cursor_fixed, grim_data, swap=swap



 mask = byte_to_bit([ [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,1,1,1,1,1,1] ,[1,1,1,1,1,0,0,0]], $
                      [[0,0,1,1,1,1,1,1] ,[1,1,1,1,1,0,0,0]], $
                      [[0,0,1,1,1,1,1,1] ,[1,1,1,1,1,0,0,0]], $
                      [[0,0,1,1,1,0,0,1] ,[0,0,1,1,1,0,0,0]], $
                      [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                      [[1,1,1,1,1,1,0,0] ,[0,1,1,1,1,1,1,0]], $
                      [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                      [[0,0,1,1,1,0,0,1] ,[0,0,1,1,1,0,0,0]], $
                      [[0,0,1,1,1,0,1,1] ,[1,0,1,1,1,0,0,0]], $
                      [[0,0,1,1,1,1,1,1] ,[1,1,1,1,1,0,0,0]], $
                      [[0,0,1,1,1,1,1,1] ,[1,1,1,1,1,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0]] ] $
                    )

 bitmap = byte_to_bit([ [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,1,1,1,1,0] ,[1,1,1,1,0,0,0,0]], $
                        [[0,0,0,1,0,0,1,0] ,[1,0,0,1,0,0,0,0]], $
                        [[0,0,0,1,0,0,0,1] ,[0,0,0,1,0,0,0,0]], $
                        [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                        [[0,0,0,0,0,1,0,0] ,[0,1,0,0,0,0,0,0]], $
                        [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                        [[0,0,0,1,0,0,0,1] ,[0,0,0,1,0,0,0,0]], $
                        [[0,0,0,1,0,0,1,0] ,[1,0,0,1,0,0,0,0]], $
                        [[0,0,0,1,1,1,1,0] ,[1,1,1,1,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0]] ] $
                    )

 device, cursor_mask=swap_endian(mask), cursor_image=swap_endian(bitmap), $
                                                            cursor_xy = [7,8]
;                                                            cursor_xy = [2,13]


 grim_mode_readout_print, grim_data, '{Fixed Region} L:Box R:Circle'
end
;=============================================================================



;=============================================================================
; grim_mode_readout_cursor_radius
;
;=============================================================================
pro grim_mode_readout_cursor_radius, grim_data, swap=swap



 mask = byte_to_bit([ [[0,0,0,0,0,1,1,1] ,[1,1,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,1,1,1] ,[1,1,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[1,1,0,0,0,0,0,1] ,[0,0,0,0,0,1,1,0]], $
                      [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                      [[1,1,1,1,1,1,0,0] ,[0,1,1,1,1,1,1,0]], $
                      [[1,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,1,0]], $
                      [[1,1,0,0,0,0,0,1] ,[0,0,0,0,0,1,1,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,1,1] ,[1,0,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,1,1,1] ,[1,1,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,1,1,1] ,[1,1,0,0,0,0,0,0]], $
                      [[0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0]] ] $
                    )

 bitmap = byte_to_bit([ [[0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,1,1,0] ,[1,1,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,1,0,0,0,0,0,1] ,[0,0,0,0,0,1,0,0]], $
                        [[0,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,0,0]], $
                        [[0,0,0,0,0,1,0,0] ,[0,1,0,0,0,0,0,0]], $
                        [[0,1,1,1,1,0,0,0] ,[0,0,1,1,1,1,0,0]], $
                        [[0,1,0,0,0,0,0,1] ,[0,0,0,0,0,1,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,1,0] ,[1,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,1,1,0] ,[1,1,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0]], $
                        [[0,0,0,0,0,0,0,0] ,[0,0,0,0,0,0,0,0]] ] $
                    )

 device, cursor_mask=swap_endian(mask), cursor_image=swap_endian(bitmap), $
                                                            cursor_xy = [7,8]
;                                                            cursor_xy = [2,13]


 grim_print, grim_data,  '[READOUT] {Adjust} Wheel:Radius'
end
;=============================================================================



;=============================================================================
; grim_mode_readout_cursor
;
;=============================================================================
pro grim_mode_readout_cursor, grim_data, data, swap=swap, mode=mode
 if(NOT keyword_set(mode)) then mode = data.mode

 if(mode EQ 'default') then grim_mode_readout_cursor_default, grim_data, swap=swap $
 else if(mode EQ 'region') then grim_mode_readout_cursor_region, grim_data, swap=swap $
 else if(mode EQ 'fixed') then grim_mode_readout_cursor_fixed, grim_data, swap=swap $
 else if(mode EQ 'radius') then grim_mode_readout_cursor_radius, grim_data, swap=swap $
 else grim_mode_readout_cursor, grim_data, data, swap=swap, mode=data.mode

 if(keyword_set(mode)) then data.mode = mode
end
;=============================================================================



;=============================================================================
; grim_pixel_readout_event
;
;=============================================================================
pro grim_pixel_readout_event, event

 ;-----------------------------------------------
 ; get form base and data
 ;-----------------------------------------------
 base = event.top
 widget_control, base, get_uvalue=data
 struct = tag_names(event, /struct)

 ;-----------------------------------------------
 ; adjust base size
 ;-----------------------------------------------
 if(struct EQ 'WIDGET_BASE') then $
  begin
   dx = event.x - data.base_xsize
   dy = event.y - data.base_ysize

   widget_control, data.text, scr_xsize=data.text_xsize+dx, scr_ysize=data.text_ysize+dy

   geom = widget_info(data.base, /geom)
   data.base_xsize = geom.xsize
   data.base_ysize = geom.ysize

   geom = widget_info(data.text, /geom)
   data.text_xsize = geom.scr_xsize
   data.text_ysize = geom.scr_ysize

   widget_control, base, set_uvalue=data
   return
  end



end
;=============================================================================



;=============================================================================
; grpr_hide_button_event
;
;=============================================================================
pro grpr_hide_button_event, event

 widget_control, event.top, map=0

end
;=============================================================================



;=============================================================================
; grim_pixel_readout
;
;=============================================================================
function grim_pixel_readout, base, text=text, grn=grn


 ;-----------------------------------------------------
 ; if base given, just realize it and bring to front
 ;-----------------------------------------------------
 if(keyword_set(base)) then $
  if(widget_info(base, /valid_id)) then $
   begin
    widget_control, /map, /show, base
    widget_control, base, get_uvalue=data
    text = data.text
    return, base
   end


 ;-----------------------------------------------------
 ; otherwise, set up new widgets
 ;-----------------------------------------------------
 title = 'GRIM ' + strtrim(grn,2) + '; pixel data'
 base = widget_base(/col, title=title, /tlb_size_events)
 text = widget_text(base, xsize=80, ysize=15, /scroll)
 hide_button = widget_button(base, value='hide', $
                                  event_pro='grpr_hide_button_event')

 widget_control, base, set_uvalue=text

 ;-----------------------------------------------
 ; save data
 ;-----------------------------------------------
 data = { $
		base			:	base, $
		text			:	text, $
		hide_button		:	hide_button, $
		base_xsize		:	0l, $
		base_ysize		:	0l, $
		text_xsize		:	0l, $
		text_ysize		:	0l, $
		data_p			:	nv_ptr_new() $
	     }

 data.data_p = nv_ptr_new(data)

 ;-----------------------------------------------------
 ; realize and register
 ;-----------------------------------------------------
 widget_control, base, /realize
 xmanager, 'grim_pixel_readout', base, /no_block

 geom = widget_info(base, /geom)
 data.base_xsize = geom.xsize
 data.base_ysize = geom.ysize

 geom = widget_info(text, /geom)
 data.text_xsize = geom.scr_xsize
 data.text_ysize = geom.scr_ysize

 widget_control, base, set_uvalue=data


 return, base
end
;=============================================================================



;=============================================================================
; grim_mode_readout_mouse_event
;
;=============================================================================
pro grim_mode_readout_mouse_event, event, data

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 widget_control, event.id, get_value=input_wnum
 output_wnum = grim_data.wnum

 struct = tag_names(event, /struct)
 if(struct NE 'WIDGET_DRAW') then return
 if(event.press EQ 2) then return


 ;----------------------------------
 ; modifiers
 ;----------------------------------
 test = event.key + event.modifiers
 if(event.press EQ 0) then test = event.modifiers - event.key
 if(test EQ 0) then grim_mode_readout_cursor, grim_data, data, swap=swap, mode='default'
 if(test EQ 1) then grim_mode_readout_cursor, grim_data, data, swap=swap, mode='region'
 if(test EQ 2) then grim_mode_readout_cursor, grim_data, data, swap=swap, mode='fixed'
 if(test EQ 3) then grim_mode_readout_cursor, grim_data, data, swap=swap, mode='radius'


 ;----------------------------------
 ; motion /  left mouse
 ;----------------------------------
 if((data.pressed EQ 1) AND (struct NE 'WIDGET_TRACKING')) then $
  begin
   widget_control, grim_data.draw, draw_motion_events=1
   grim_wset, grim_data, input_wnum
   grim_data.readout_top = $
   grim_pixel_readout(grim_data.readout_top, text=text, grn=grim_data.grn)
   grim_data.readout_text = text
   grim_set_data, grim_data, event.top

   p = convert_coord(double(event.x), double(event.y), /device, /to_data)
   planes = grim_get_plane(grim_data);, /visible)
   pg_cursor, planes.dd, xy=p[0:1], /silent, fn=data.fn, $
     gd={cd:grim_xd(plane, /cd), gbx:*plane.pd_p, dkx:*plane.rd_p, $
    	   ltd:*plane.ltd_p, sd:*plane.sd_p, std:*plane.std_p}, /radec, /photom, string=string 
   sep = str_pad('', 80, c='-')
   widget_control, grim_data.readout_text, get_value=ss    
   widget_control, grim_data.readout_text, set_value=[string , sep, ss]   
   grim_wset, grim_data, output_wnum
  end


 ;----------------------------------
 ; change size of fixed region
 ;----------------------------------
 if(event.modifiers EQ 3) then $
  begin
   if(keyword_set(*data.circle_pts_p)) then $
    begin
     device, set_graphics=6
     plots, *data.circle_pts_p
     plots, *data.box_pts_p
     device, set_graphics=3
     *data.circle_pts_p = 0
     *data.box_pts_p = 0
    end

   if(event.type EQ 7) then $
    begin
     p = (convert_coord(double(event.x), double(event.y), /device, /to_data))[0:1]
     data.radius = data.radius + event.clicks*data.radstep > 2
     circle_pts = image_circle(p, data.radius, /close)
     box_pts = image_box(p, data.radius, /close)

     device, set_graphics=6
     plots, circle_pts
     plots, box_pts
     device, set_graphics=3
     *data.circle_pts_p = circle_pts
     *data.box_pts_p = box_pts
    end
  end


 ;----------------------------------
 ; button press
 ;----------------------------------
 if(event.type EQ 0) then $
  begin
   data.pressed = event.press

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; Region stats
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(event.modifiers GT 0) then $
    begin
     grim_wset, grim_data, input_wnum
     grim_data.readout_top = $
       grim_pixel_readout(grim_data.readout_top, text=text, grn=grim_data.grn)
     grim_data.readout_text = text
     grim_set_data, grim_data, event.top

     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; Define region w mouse
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     if(event.modifiers EQ 1) then $
      begin
       if(event.press EQ 1) then $
        begin
         roi = pg_select_region(plane.dd, /box, $
                 p0=[event.x,event.y], $
                 /silent, color=ctblue(), image_pts=outline_pts)
        end $
       else if(event.press EQ 4) then $
        begin
         roi = pg_select_region(plane.dd, $
                 p0=[event.x,event.y], $
                 /autoclose, /silent, color=ctblue(), $
                 cancel_button=2, end_button=-1, select_button=4, $
                 image_pts=outline_pts)
        end 
       if(roi[0] EQ -1) then return
      end $
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; Fixed square or circular region 
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     else if(event.modifiers EQ 2) then $
      begin
       p = (convert_coord(double(event.x), double(event.y), /device, /to_data))[0:1]
       if(event.press EQ 1) then $
                    outline_pts = image_box(p, data.radius, /close) $
       else if(event.press EQ 4) then $
                    outline_pts = image_circle(p, data.radius, /close)

       roi = poly_fillv(outline_pts, dat_dim(plane.dd))
      end $
     else return


     roip = w_to_xy(dat_dim(plane.dd), roi)

     planes = grim_get_plane(grim_data);, /visible)
     pg_cursor, planes.dd, outline_pts, /silent, fn=data.fn, point=pp, $
       gd={cd:grim_xd(plane, /cd), gbx:*plane.pd_p, dkx:*plane.rd_p, $
      	   ltd:*plane.ltd_p, sd:*plane.sd_p, std:*plane.std_p}, /radec, /photom, string=string 

     sep = str_pad('', 80, c='-')
     widget_control, grim_data.readout_text, get_value=ss    
     widget_control, grim_data.readout_text, set_value=[string , sep, ss]   
     grim_wset, grim_data, output_wnum


     grim_place_readout_mark, grim_data, pp
     grim_place_stats_region, grim_data, outline_pts
;     grim_draw, grim_data, /measure
     grim_refresh, grim_data, /use_pixmap, /noglass
     data.pressed = 0
    end $
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; Measure
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   else if(event.press EQ 4) then $
    begin
     widget_control, grim_data.draw, draw_motion_events=1
     grim_wset, grim_data, input_wnum
     grim_data.readout_top = $
       grim_pixel_readout(grim_data.readout_top, text=text, grn=grim_data.grn)
     grim_data.readout_text = text
     grim_set_data, grim_data, event.top

     p = convert_coord(double(event.x), double(event.y), /device, /to_data)
     planes = grim_get_plane(grim_data);, /visible)
     pg_measure, planes.dd, xy=p[0:1], p=pp, /silent, fn=data.fn, $
       gd={cd:grim_xd(plane, /cd), gbx:*plane.pd_p, dkx:*plane.rd_p, $
    	   ltd:*plane.ltd_p, sd:*plane.sd_p, std:*plane.std_p}, /radec, string=string 
     sep = str_pad('', 80, c='-')
     widget_control, grim_data.readout_text, get_value=ss    
     widget_control, grim_data.readout_text, set_value=[string , sep, ss]   
     grim_wset, grim_data, output_wnum

     grim_place_measure_mark, grim_data, pp
;     grim_draw, grim_data, /measure
     grim_refresh, grim_data, /use_pixmap, /noglass
     data.pressed = 0
    end
  end


 ;----------------------------------
 ; button release
 ;----------------------------------
 if(event.type EQ 1) then $
  begin
   grim_set_tracking, grim_data
   data.pressed = 0
   if(event.release EQ 1) then $
    begin
     grim_wset, grim_data, input_wnum
     p = convert_coord(double(event.x), double(event.y), /device, /to_data)
     grim_wset, grim_data, output_wnum
     grim_place_readout_mark, grim_data, p[0:1]
;     grim_draw, grim_data, /readout
     grim_refresh, grim_data, /use_pixmap, /noglass
    end
  end




end
;=============================================================================


;=============================================================================
; grim_mode_readout_mode
;
;=============================================================================
pro grim_mode_readout_mode, grim_data, data_p

 grim_mode_readout_cursor, grim_data, *data_p, swap=swap
; grim_print, grim_data, $
;        '[READOUT] L:Pixel R:Measure '+ $
;        '<Shift>L:Rectangle R:Irregular ' + $
;        '<Ctrl>Fixed L:Box R:Circle <Shift+Ctrl>Wheel:Radius'

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_mode_readout_button_event
;
;
; PURPOSE:
;	Selects the readout cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	A text window appears and displays data about the pixel selected 
;	using the left mouse button.  The amount and type of information
;	displayed depends on which descriptors are loaded.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2002
;	
;-
;=============================================================================
pro grim_mode_readout_button_help_event, event
 text = ''
 nv_help, 'grim_mode_readout_button_help_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_mode_readout_button_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Display pixel data'
   return
  end


 ;---------------------------------------------------------
 ; otherwise, change mode
 ;---------------------------------------------------------
 widget_control, event.id, get_uvalue=data
 grim_set_mode, grim_data, 'grim_mode_readout', /new, data_p=data.data_p

 grim_data.readout_top = $
   grim_pixel_readout(grim_data.readout_top, text=text, grn=grim_data.grn)
 grim_data.readout_text = text

 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
; grim_mode_readout_init
;
;=============================================================================
pro grim_mode_readout_init, grim_data, data_p



end
;=============================================================================



;=============================================================================
; grim_mode_readout
;
;=============================================================================
function grim_mode_readout, arg
 
 data = {grim_mode_readout_struct, $
         pressed:0, $
         mode:'default', $
         fn:arg, $
         radius:5, $
         circle_pts_p:ptr_new(0), $
         box_pts_p:ptr_new(0), $
         radstep:1}

 return, $
     {grim_user_mode_struct, $
		 name:		'grim_mode_readout', $
		 event_pro:	'*grim_mode_readout_button_event', $
                 bitmap:	 grim_mode_readout_bitmap(), $
                 menu:		'Readout', $
                 data_p:	 nv_ptr_new(data) }

end
;=============================================================================
