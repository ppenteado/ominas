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
; grim_mode_readout_cursor
;
;=============================================================================
pro grim_mode_readout_cursor, swap=swap



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


end
;=============================================================================



;=============================================================================
; grim_mag_erase
;
;=============================================================================
pro grim_mag_erase, grim_data, wnum
@grim_constants.common

 size_device = MAG_SIZE_DEVICE
 half_size_device = size_device/2

; x0 = grim_data.mag_last[0] - half_size_device > 0
; y0 = grim_data.mag_last[1] - half_size_device > 0

 wset, wnum
; device, copy=[0,0, size_device,size_device, x0,y0, $
 device, copy=[0,0, size_device,size_device, $
                  grim_data.mag_last_x0,grim_data.mag_last_y0, $
                                                grim_data.mag_redraw_pixmap]

 grim_mode_readout_cursor, swap=grim_get_cursor_swap(grim_data)
end
;=============================================================================



;=============================================================================
; grim_mag_frame
;
;=============================================================================
pro grim_mag_frame
@grim_constants.common

 size_device = MAG_SIZE_DEVICE

 plots, /device, [0,size_device-1,size_device-1,0,0], $
                 [0,0,size_device-1,size_device-1,0], color=ctgreen()


end
;=============================================================================



;=============================================================================
; grim_magnify
;
;=============================================================================
pro grim_magnify, grim_data, plane, p_device, data=data
@grim_constants.common

 size_data = MAG_SIZE_DATA
 half_size_data = fix(size_data/2)


 wnum = !d.window
 xmax = !d.x_size
 ymax = !d.y_size

 wset, grim_data.mag_pixmap
 size_device = MAG_SIZE_DEVICE
 half_size_device = fix(size_device/2)

 ;--------------------------------
 ; magnify current region
 ;--------------------------------
 x0 = p_device[0] - half_size_data
 y0 = p_device[1] - half_size_data

 x0 = x0 > 0 < (xmax - size_data)
 y0 = y0 > 0 < (ymax - size_data)

 pp = [x0 + half_size_data, y0 + half_size_data]

 ;- - - - - - - - - - - - - - - - - - - - -
 ; different behavior depending on mode
 ;- - - - - - - - - - - - - - - - - - - - -
 wset, wnum
 if(keyword_set(data)) then $
  begin
   dim = dat_dim(plane.dd)

   p_data = round(convert_coord(double(p_device[0]), double(p_device[1]), /device, /to_data))
   x0 = p_data[0] - half_size_data
   y0 = p_data[1] - half_size_data

   x0 = x0 > 0 < (dim[0]-1 - size_data - 1)
   y0 = y0 > 0 < (dim[1]-1 - size_data - 1)

   x1 = x0 + size_data - 1
   y1 = y0 + size_data - 1

   region = grim_scale_image(grim_data, $
        xrange=[x0,x1], yrange=[y0,y1], top=top, no_scale=no_scale, plane=plane)

   if(grim_data.mag_last_x0 GE 0) then grim_mag_erase, grim_data, wnum

   mag_region = congrid(region, size_device, size_device)

   grim_wset, grim_data, wnum, get_info=tvd
   wset, grim_data.mag_pixmap

   erase 
   tvscl, mag_region, order=tvd.order, top=top
  end $
 else $
  begin
   if(grim_data.mag_last_x0 GE 0) then grim_mag_erase, grim_data, wnum
   region1 = congrid(tvrd(x0, y0, size_data, size_data, channel=1), size_device, size_device)
   region2 = congrid(tvrd(x0, y0, size_data, size_data, channel=2), size_device, size_device)
   region3 = congrid(tvrd(x0, y0, size_data, size_data, channel=3), size_device, size_device)

   grim_wset, grim_data, wnum, get_info=tvd
   wset, grim_data.mag_pixmap

   erase 
   tv, region1, channel=1
   tv, region2, channel=2
   tv, region3, channel=3
  end

 grim_mag_frame


 ;- - - - - - - - - - - - - - -
 ; save current region
 ;- - - - - - - - - - - - - - -
 x0 = pp[0] - half_size_device
 y0 = pp[1] - half_size_device

 x0 = x0 > 0 < (xmax - size_device)
 y0 = y0 > 0 < (ymax - size_device)
 wset, grim_data.mag_redraw_pixmap
 device, copy=[x0,y0, size_device,size_device, 0,0, wnum]


 ;- - - - - - - - - - - - - - -
 ; overlay magnified region
 ;- - - - - - - - - - - - - - -
 wset, wnum
 device, copy=[0,0, size_device,size_device, x0,y0, grim_data.mag_pixmap]

 grim_data.mag_last_x0 = x0
 grim_data.mag_last_y0 = y0
 grim_set_data, grim_data, grim_data.base

 grim_no_cursor
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
function grim_pixel_readout, base, text=text, grnum=grnum


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
 title = 'grim ' + strtrim(grnum,2) + '; pixel data'
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


 ;----------------------------------
 ; motion
 ;----------------------------------
 if((data.pressed EQ 1) AND (struct NE 'WIDGET_TRACKING')) then $
  begin
   widget_control, grim_data.draw, draw_motion_events=1
   grim_wset, grim_data, input_wnum
   grim_data.readout_top = $
   grim_pixel_readout(grim_data.readout_top, text=text, grnum=grim_data.grnum)
   grim_data.readout_text = text
   grim_set_data, grim_data, event.top

   p = convert_coord(double(event.x), double(event.y), /device, /to_data)
   planes = grim_get_plane(grim_data);, /visible)
   pg_cursor, planes.dd, xy=p[0:1], /silent, fn=*grim_data.readout_fns_p, $
     gd={cd:*plane.cd_p, gbx:*plane.pd_p, dkx:*plane.rd_p, $
    	   sund:*plane.sund_p, sd:*plane.sd_p, std:*plane.std_p}, /radec, /photom, string=string 
   sep = str_pad('', 80, c='-')
   widget_control, grim_data.readout_text, get_value=ss    
   widget_control, grim_data.readout_text, set_value=[string , sep, ss]   
   grim_wset, grim_data, output_wnum
  end




 ;----------------------------------
 ; button press
 ;----------------------------------
 if(event.type EQ 0) then $
  begin
   data.pressed = event.press
   if(event.press EQ 4) then $
    begin
     widget_control, grim_data.draw, draw_motion_events=1
     grim_wset, grim_data, input_wnum
     grim_data.readout_top = $
       grim_pixel_readout(grim_data.readout_top, text=text, grnum=grim_data.grnum)
     grim_data.readout_text = text
     grim_set_data, grim_data, event.top

     p = convert_coord(double(event.x), double(event.y), /device, /to_data)
     planes = grim_get_plane(grim_data);, /visible)
     pg_measure, planes.dd, xy=p[0:1], p=pp, /silent, fn=*grim_data.readout_fns_p, $
       gd={cd:*plane.cd_p, gbx:*plane.pd_p, dkx:*plane.rd_p, $
    	   sund:*plane.sund_p, sd:*plane.sd_p, std:*plane.std_p}, /radec, string=string 
     sep = str_pad('', 80, c='-')
     widget_control, grim_data.readout_text, get_value=ss    
     widget_control, grim_data.readout_text, set_value=[string , sep, ss]   
     grim_wset, grim_data, output_wnum

     grim_place_measure_mark, grim_data, pp
;     grim_draw, grim_data, /measure
     grim_refresh, grim_data, /use_pixmap
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
     grim_draw, grim_data, /readout
    end
  end



end
;=============================================================================


;=============================================================================
; grim_mode_readout_mode
;
;=============================================================================
pro grim_mode_readout_mode, grim_data, data_p

 grim_mode_readout_cursor, swap=swap
 grim_print, grim_data, 'LEFT: Pixel readout; RIGHT: Measure'

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
;pro grim_readout_mode_help_event, event
; text = ''
; nv_help, 'grim_readout_mode_event', cap=text
; if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
;end
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
   grim_pixel_readout(grim_data.readout_top, text=text, grnum=grim_data.grnum)
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
 
 data = {grim_mode_readout_struct, pressed:0}

 return, $
     {grim_user_mode_struct, $
		 name:		'grim_mode_readout', $
		 event_pro:	'*grim_mode_readout_button_event', $
                 bitmap:	 grim_mode_readout_bitmap(), $
                 menu:		'Readout', $
                 data_p:	 nv_ptr_new(data) }

end
;=============================================================================
