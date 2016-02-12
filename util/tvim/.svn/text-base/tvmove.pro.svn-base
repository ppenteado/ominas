;=============================================================================
;+
; NAME:
;       tvmove
;
;
; PURPOSE:
;       Move a displayed image by an offset determined by the cursor
;
;
; CATEGORY:
;       UTIL/TVIM
;
;
; CALLING SEQUENCE:
;       tvmove, image, wnum, new=new, erase=erase
;
;
; ARGUMENTS:
;  INPUT:
;         image:        Image to display
;
;          wnum:        window number of display
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
;
;	p0:	First point.  If set, then the routine
;		immediately begins to drag from that point until a
;		button is released.
;
;	cursor:	Device code of cursor to use.  Default is a custom cursor.
;
;	hourglass_id:	If set, this is used as the widget id of a draw
;			window in which to set the hourglass cursor after
;			the line has been selected until the procedure 
;			is complete.	
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
pro tvmove, image, wnum, new=new, erase=erase, p0=p0, cursor=cursor, $
                   hourglass_id=hourglass_id, noplot=noplot, $
                   output_wnum=output_wnum, color=color

 if(n_elements(wnum) NE 0) then tvim, wnum
 if(NOT keyword_set(image)) then return

 s = size(image)
 sx = s[1]
 sy = s[2]

 ;-------------------------------
 ; get user-line box on image
 ;-------------------------------
 tvcursor, /set, cursor=cursor
 ln = tvline(/restore, p0=p0, color=color)
 tvcursor, /restore
 if(keyword_set(hourglass_id)) then widget_control, hourglass_id, /hourglass

 ;---------------------------------
 ; get get data coords of corners
 ;---------------------------------
 line = convert_coord(double(ln[0,*]), double(ln[1,*]), /device, /to_data)
 dx = line[0,0]-line[0,1]
 dy = line[1,0]-line[1,1]

 ;---------------------------------
 ; derive tvim parameters
 ;---------------------------------
 doffset = [dx,dy]

 ;---------------------------------
 ; display moved image
 ;---------------------------------
 if(keyword_set(output_wnum)) then tvim, output_wnum
 tvim, image, doffset=doffset, /inherit, new=new, erase=erase, noplot=noplot, $
                                             xsize=!d.x_size, ysize=!d.y_size

end
;=============================================================================
