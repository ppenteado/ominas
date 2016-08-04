;=============================================================================
;+
; NAME:
;	pg_select_region
;
;
; PURPOSE:
;	Allows the user to select regions in an image using the mouse.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	region = pg_select_region(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor containing an image.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	noverbose: 	If set, turns off the notification that cursor
;			movement is required.
;
;	color:		Color to use for graphics overlays.
;
;
;	p0:		First point of line.  If set, then the routine
;			immediately begins to drag from that point until a
;			button is released.
;
;	select_button:	Index of button to use as the select button instead
;			of the left button (1).
;
;	end_button:	Index of button to use as the end button instead
;			of the right button (4).
;
;	cancel_button:	Index of mouse button to be used as a cancel
;			button instead of left+middle, (3).
;
;	points:		If set, the selected points are returned instead
;			of enclosed indices.
;
;	autoclose:	If set, the region is automaticaly closed when the 
;			end button is pressed.
;
;	box:		If set, a rectanguar region is selected.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array of subscripts of all image points which lie within the selected
;	region.  -1 is returned if the cancel button is pressed.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_trim
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
function pg_select_region, dd, color=color, $
      select_button=select_button, cancel_button=cancel_button, $
      end_button=end_button, noverbose=noverbose, p0=p0, autoclose=autoclose, $
      points=_points, noclose=noclose, data=data, box=box, image_pts=points

 xsize = !d.x_size
 ysize = !d.y_size
 device = 1
 if(keyword_set(data)) then device = 0
 
 close = 1
 if(keyword_set(noclose)) then close = 0

 if(keyword_set(dd)) then $
  begin
   image=dat_data(dd)
   s=size(image)
   xsize=s[1]
   ysize=s[2]
   device = 0
  end

 ;------------------------------------------
 ; let user define region in device coords
 ;------------------------------------------

 ;- - - - - - - - - - - - - - - - -
 ; curve
 ;- - - - - - - - - - - - - - - - -
 if(NOT keyword_set(box)) then $
  begin
   if(NOT keyword_set(noverbose)) then $
    begin
      nv_message, 'Use cursor and mouse buttons to select points -', $
                   name='pg_select_region', /continue
      nv_message, 'LEFT: Select point, MIDDLE: Erase point, RIGHT: End', $
                   name='pg_select_region', /continue
     end
   points = tvpath(close=close, /copy, color=color, autoclose=autoclose, $
                select_button=select_button, end_button=end_button, $
                cancel_button=cancel_button, p0=p0, cancelled=cancelled)
   if(cancelled) then return, [-1]
  end $
 ;- - - - - - - - - - - - - - - - -
 ; box
 ;- - - - - - - - - - - - - - - - -
 else $
  begin
   if(NOT keyword_set(noverbose)) then $
    begin
      nv_message, 'Use cursor and mouse buttons to select points -', $
                   name='pg_select_region', /continue
      nv_message, 'LEFT: Select point, MIDDLE: Erase point, RIGHT: End', $
                   name='pg_select_region', /continue
     end
   points = tvrec(color=color, p0=p0, /all_corners)
  end 


 ;------------------------------------------
 ; transform to data coords
 ;------------------------------------------
 if(NOT device) then points=(convert_coord(points, /device, /to_data))[0:1,*]
 if(keyword_set(_points)) then return, points
 
 xverts=transpose(points[0,*])
 yverts=transpose(points[1,*])
 indices=polyfillv(xverts, yverts, xsize, ysize)

 return, indices
end
;=============================================================================
