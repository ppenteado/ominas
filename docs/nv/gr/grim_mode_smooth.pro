;=============================================================================
; grim_mode_smooth_bitmap
;
;=============================================================================
function grim_mode_smooth_bitmap

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
; grim_smooth
;
;=============================================================================
pro grim_smooth, grim_data, plane=plane, box

 max = 30

 data = double(dat_data(plane.dd))

 if(grim_data.type EQ 'plot') then $
  begin
   xx = data[0,*] & xx = xx[sort(xx)]

   yy = data[1,*]
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
   data[1,*] = yy
  end $
 else $
  begin
   dx = max(box[0,*]) - min(box[0,*])
   dy = max(box[1,*]) - min(box[1,*])
   nx = fix(dx)
   ny = fix(dy)
   if((nx LT 1) OR (ny LT 1)) then return

   kernel = dblarr(nx, ny)
   kernel[*] = 1d/(double(nx)*double(ny))

   n = max([nx,ny])
   result = 'Yes'
   if(n GE max) then $
       grim_message, /question, result=result, $
           ['The smoothing kernel is rather large.  Continue anyway?']
   if(result NE 'Yes') then return

   data = convol(data, kernel, /center)
  end

 dat_set_data, plane.dd, data
 
end
;=============================================================================



;=============================================================================
; grim_mode_smooth_mouse_event
;
;=============================================================================
pro grim_mode_smooth_mouse_event, event, data

 grim_data = grim_get_data(event.top)
 plane = grim_get_plane(grim_data)

 widget_control, event.id, get_value=input_wnum
 output_wnum = grim_data.wnum

 struct = tag_names(event, /struct)
 if(struct NE 'WIDGET_DRAW') then return
 if(event.press EQ 2) then return

 if(input_wnum NE grim_data.wnum) then return

 if(event.press EQ 1) then $
     _box = tvrec(p0=[event.x, event.y], color=ctyellow(), aspect=1) $
 else if(event.press EQ 4) then $
     _box = tvrec(p0=[event.x, event.y], color=ctyellow()) $
 else return

 xx = _box[0,*] & yy = _box[1,*]
 box = convert_coord(/device, /to_data, double(xx), double(yy))
 widget_control, /hourglass
 grim_smooth, grim_data, plane=plane, box

end
;=============================================================================



;=============================================================================
; grim_mode_smooth_mode
;
;=============================================================================
pro grim_mode_smooth_mode, grim_data, data_p

 device, cursor_standard = 64
 grim_print, grim_data, 'SMOOTH -- LEFT: Square kernel; RIGHT: Rectangular kernel'

end
;=============================================================================



;=============================================================================
;+
; NAME:
;	grim_mode_smooth_button_event
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
;	size for smothing the data set.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2006
;	
;-
;=============================================================================
;pro grim_smooth_mode_help_event, event
; text = ''
; nv_help, 'grim_remove_mode_event', cap=text
; if(keyword_set(text)) then grim_help, grim_get_data(event.top), text
;end
;----------------------------------------------------------------------------
pro grim_mode_smooth_button_event, event

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
; grim_mode_smooth_init
;
;=============================================================================
pro grim_mode_smooth_init, grim_data, data_p



end
;=============================================================================



;=============================================================================
; grim_mode_smooth
;
;=============================================================================
function grim_mode_smooth, arg
 
data = 0

 return, $
     {grim_user_mode_struct, $
		 name:		'grim_mode_smooth', $
		 event_pro:	'*grim_mode_smooth_button_event', $
                 bitmap:	 grim_mode_smooth_bitmap(), $
                 menu:		'Smooth', $
                 data_p:	 nv_ptr_new(data) }

end
;=============================================================================
