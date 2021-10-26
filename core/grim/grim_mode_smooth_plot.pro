;=============================================================================
; grim_mode_smooth_plot_print
;
;=============================================================================
pro grim_mode_smooth_plot_print, grim_data, s
 grim_print, grim_data, prefix='[SMOOTH] ', s
end
;=============================================================================



;=============================================================================
; grim_mode_smooth_plot_bitmap
;
;=============================================================================
function grim_mode_smooth_plot_bitmap

 return, [                               $
                [255B, 255B],                   $
                [255B, 255B],                   $
                [003B, 192B],                   $
                [083B, 213B],                   $
                [171B, 202B],                   $
                [083B, 213B],                   $
                [171B, 202B],                   $
                [083B, 213B],                   $
                [171B, 202B],                   $
                [083B, 213B],                   $
                [171B, 202B],                   $
                [083B, 213B],                   $
                [171B, 202B],                   $
                [003B, 192B],                   $
                [255B, 255B],                   $
                [255B, 255B]                    $
                ]
 

end
;=============================================================================



;=============================================================================
; grim_smooth_plot
;
;=============================================================================
pro grim_smooth_plot, grim_data, plane=plane, box

 max = 30

 data = double(dat_data(plane.dd, abscissa=abscissa))
 size = size(data, /dim)

 xx = abscissa & xx = xx[sort(xx)]

 yy = data
 x0 = min(where(xx GE min(box[0,*])))
 x1 = max(where(xx LE max(box[0,*])))

 n = x1-x0
 if(n LT 1) then return

 result = 'Yes'
 if(n GE max) then $
     grim_message, /question, result=result, $
	 ['The smoothing kernel is rather large.  Continue anyway?']
 if(result NE 'Yes') then return

 yy = smooth(yy, n)
 data = yy

 dat_set_data, plane.dd, data
 
end
;=============================================================================



;=============================================================================
; grim_mode_smooth_plot_grid_reset
;
;=============================================================================
pro grim_mode_smooth_plot_grid_reset
common grim_mode_smooth_plot_grid_block, p0
 p0 = !null
end
;=============================================================================



;=============================================================================
; grim_mode_smooth_plot_grid
;
;=============================================================================
function grim_mode_smooth_plot_grid, p
common grim_mode_smooth_plot_grid_block, p0

 if(NOT keyword_set(p0)) then $
  begin 
   p0 = p
   return, p
  end

 return, [p[0], p0[1]]
end
;=============================================================================



;=============================================================================
; grim_mode_smooth_plot_mouse_event
;
;=============================================================================
pro grim_mode_smooth_plot_mouse_event, event, data

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 widget_control, event.id, get_value=input_wnum
 output_wnum = grim_data.wnum

 struct = tag_names(event, /struct)
 if(struct NE 'WIDGET_DRAW') then return
 if(NOT keyword_set(event.clicks)) then return
 if(event.press EQ 2) then return

 if(input_wnum NE grim_data.wnum) then return

 if(event.press NE 1) then return

 _box = tvline(p0=[event.x, event.y], color=ctyellow(), $
                                       grid='grim_mode_smooth_plot_grid')
 grim_mode_smooth_plot_grid_reset

 xx = _box[0,*] & yy = _box[1,*]
 box = convert_coord(/device, /to_data, double(xx), double(yy))
 widget_control, /hourglass
 grim_smooth_plot, grim_data, plane=plane, box

end
;=============================================================================



;=============================================================================
; grim_mode_smooth_plot_mode
;
;=============================================================================
pro grim_mode_smooth_plot_mode, grim_data, data_p

 device, cursor_standard = 64
 grim_mode_smooth_plot_print, grim_data, 'L:Drag Kernel'

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_mode_smooth_plot_button_event
;
;
; PURPOSE:
;	Selects the smooth cursor mode.
;
;
; CATEGORY:
;	NV/GR
;
;
; OPERATION:
;	The user selects a box, which is used to determine the kernel
;	size for smoothing the data set.  If a ROI exists, only the data within
;	the ROI are smoothed.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2006
;	
;-
;=============================================================================
pro grim_mode_smooth_plot_button_help_event, event
 text = ''
 nv_help, 'grim_mode_smooth_plot_button_help_event', cap=text
 if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
end
;----------------------------------------------------------------------------
pro grim_mode_smooth_plot_button_event, event

 grim_data = grim_get_data(event.top)

 ;---------------------------------------------------------
 ; if tracking event, just print usage info
 ;---------------------------------------------------------
 struct = tag_names(event, /struct)
 if(struct EQ 'WIDGET_TRACKING') then $
  begin
   if(event.enter) then grim_print, grim_data, 'Smooth data'
   return
  end

 ;---------------------------------------------------------
 ; otherwise, change mode
 ;---------------------------------------------------------
 widget_control, event.id, get_uvalue=data
 grim_set_mode, grim_data, 'grim_mode_smooth', /new, data_p=data.data_p
 grim_set_data, grim_data, event.top

end
;=============================================================================



;=============================================================================
; grim_mode_smooth_plot_init
;
;=============================================================================
pro grim_mode_smooth_plot_init, grim_data, data_p



end
;=============================================================================



;=============================================================================
; grim_mode_smooth_plot
;
;=============================================================================
function grim_mode_smooth_plot, arg
 
data = 0

 return, $
     {grim_user_mode_struct, $
		 name:		'grim_mode_smooth_plot', $
		 event_pro:	'%grim_mode_smooth_plot_button_event', $
                 bitmap:	 grim_mode_smooth_plot_bitmap(), $
                 menu:		'Smooth', $
                 data_p:	 nv_ptr_new(data) }

end
;=============================================================================
