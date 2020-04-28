;=============================================================================
;+
; NAME:
;       tvunzoom
;
;
; PURPOSE:
;       Unzoom full viewport to a cursor-defined box.
;
;
; CATEGORY:
;       UTIL/TVIM
;
;
; CALLING SEQUENCE:
;       tvunzoom, image, wnum, new=new, erase=erase
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
;       Complete, but apparently not correct.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale; 6/2002
;
;-
;=============================================================================
pro tvunzoom, image, wnum, new=new, erase=erase, p0=p0, cursor=cursor, $
                   hourglass_id=hourglass_id, noplot=noplot, color=color, $
                   output_wnum=output_wnum, minbox=minbox, aspect=aspect, $
                   xy=xy

 if(n_elements(wnum) NE 0) then tvim, wnum
 if(NOT keyword_set(image)) then return

 ;-------------------------------
 ; get user-defined box on image
 ;-------------------------------
 tvcursor, /set, cursor=cursor
 box = tvrec(/restore, p0=p0, aspect=aspect, color=color)
 tvcursor, /restore
 if(keyword_set(hourglass_id)) then widget_control, hourglass_id, /hourglass

 box_data = convert_coord(double(box[0,*]), double(box[1,*]), /device, /to_data)
 if(keyword_set(output_wnum)) then tvim, output_wnum
 box = (convert_coord(double(box_data[0,*]), double(box_data[1,*]), /data, /to_device))[0:1,*]

 cx = double([min(box[0,*]), max(box[0,*])])
 cy = double([min(box[1,*]), max(box[1,*])])

 if(keyword_set(minbox)) then $
   if((abs(box[0,0]-box[0,1]) LT minbox) OR $
      (abs(box[1,0]-box[1,1]) LT minbox)) then return

 ;--------------------------------------
 ; get get data coords of corners
 ;--------------------------------------
 corners = convert_coord(double(cx), double(cy), /device, /to_data)
 cx_data = [min(corners[0,*]), max(corners[0,*])]
 cy_data = [min(corners[1,*]), max(corners[1,*])]

 imx = [0d,!d.x_size-1]
 imy = [0d,!d.y_size-1]

 image_corners = convert_coord(double(imx), double(imy), /device, /to_data)
 imx_data = double([min(image_corners[0,*]), max(image_corners[0,*])])
 imy_data = double([min(image_corners[1,*]), max(image_corners[1,*])])

 ;---------------------------------
 ; derive tvim parameters
 ;---------------------------------
 if(keyword_set(xy)) then $
   zoom = [double(abs(cx[0]-cx[1]))/abs(imx_data[0]-imx_data[1]) ,$
                double(abs(cy[0]-cy[1]))/abs(imy_data[0]-imy_data[1])] $
 else $
   zoom = double(abs(cx[0]-cx[1]))/abs(imx_data[0]-imx_data[1]) $
                < double(abs(cy[0]-cy[1]))/abs(imy_data[0]-imy_data[1])


 ratio = double([!d.x_size, !d.y_size]) / double([cx[1]-cx[0], cy[1]-cy[0]])
 offset = [imx_data[0], imy_data[0]] - $
                 [cx_data[0]-imx_data[0], cy_data[0]-imy_data[0]]*ratio
                
 ;---------------------------------
 ; display zoomed image
 ;---------------------------------
 tvim, image, offset=offset, zoom=zoom, /inherit, new=new, erase=erase, $
                              xsize=!d.x_size, ysize=!d.y_size, noplot=noplot

end
;=============================================================================
