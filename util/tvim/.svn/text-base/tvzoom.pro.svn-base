;=============================================================================
;+
; NAME:
;       tvzoom
;
;
; PURPOSE:
;       Zoom a cursor defined box to full viewport.
;
;
; CATEGORY:
;       UTIL/TVIM
;
;
; CALLING SEQUENCE:
;       tvzoom, image, wnum, new=new, erase=erase
;
;
; ARGUMENTS:
;  INPUT:
;	image:        Image to display
;
;	wnum:        window number of display
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;  INPUT:
;	new:	If set, creates a new window
;
;	erase:	If set, erases display first
;
;	noplot:	If set, the image is not redisplayed.
;
;	p0:	First corner of box.  If set, then the routine
;		immediately begins to drag from that point until a
;		button is released.
;
;	cursor:	Device code of cursor to use.  Default is a custom cursor.
;
;	hourglass_id:	If set, this is used as the widget id of a draw
;			window in which to set the hourglass cursor after
;			the zoom region has been selected until the procedure 
;			is complete.
;
;	output_wnum:	Window number for output display.	
;
;	minbox:	Minimum size of zoom box.  If smaller than this size in either
;		direction, the zoom will not be changed.
;
;	aspect:	Aspect ratio (y/x) to maintain when drawing the dragged zoom
;		box.
;
;	color:	Color of zoom box.
;
;	
;
;  OUTPUT:
;       NONE
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
pro tvzoom, image, wnum, new=new, erase=erase, p0=p0, cursor=cursor, $
                   hourglass_id=hourglass_id, noplot=noplot, color=color, $
                   output_wnum=output_wnum, minbox=minbox, aspect=aspect, $
                   xy=xy, corners=corners

 if(n_elements(wnum) NE 0) then tvim, wnum
 if(NOT keyword_set(image)) then return

 if(NOT keyword_set(corners)) then $
  begin
   ;-------------------------------
   ; get user-defined box on image
   ;-------------------------------
   tvcursor, /set, cursor=cursor
   box = tvrec(/restore, p0=p0, aspect=aspect, color=color)
   tvcursor, /restore
   if(keyword_set(hourglass_id)) then widget_control, hourglass_id, /hourglass

   cx = box[0,*]
   cy = box[1,*]

   if(keyword_set(minbox)) then $
     if((abs(box[0,0]-box[0,1]) LT minbox) OR $
        (abs(box[1,0]-box[1,1]) LT minbox)) then return

   ;---------------------------------
   ; get get data coords of corners
   ;---------------------------------
   corners = convert_coord(double(cx), double(cy), /device, /to_data)
  end

 ;---------------------------------
 ; derive tvim parameters
 ;---------------------------------
 if(keyword_set(output_wnum)) then tvim, output_wnum

 offset = [min(corners[0,*]), min(corners[1,*])]

 if(keyword_set(xy)) then $
      zoom = [double(!d.x_size)/abs(corners[0,0]-corners[0,1]), $
                               double(!d.y_size)/abs(corners[1,0]-corners[1,1])] $
 else $
    zoom = double(!d.x_size)/abs(corners[0,0]-corners[0,1]) < $
                               double(!d.y_size)/abs(corners[1,0]-corners[1,1])

 ;---------------------------------
 ; display zoomed image
 ;---------------------------------
 tvim, image, offset=offset, zoom=zoom, /inherit, new=new, erase=erase, $
                             xsize=!d.x_size, ysize=!d.y_size, noplot=noplot

end
;=============================================================================
