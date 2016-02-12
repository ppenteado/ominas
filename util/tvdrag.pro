;=============================================================================
;+
; NAME:
;	tvdrag
;
;
; PURPOSE:
;	Allows user to drag a given image across a background image.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	p = tvdrag(bg_image, drag_image, p0)
;
;
; ARGUMENTS:
;  INPUT:
;	bg_image:	Background image.
;
;	drag_image:	Image to be dragged across bg_image.
;
;	p0:		Initial point in bg_image for origin of drag_image.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	win_num:	Window number of IDL graphics window in which to select
;			box.  Default is current window.
;
;	restore:	If set, the original image is restored at the end.
;
;	grid_function:	Function which will quantize a point onto
;			a grid.  It should take an orderered
;			pair as its only argument and return an
;			ordered pair.  Default is the identity function.
;
;	cursor_init:	2-element vector giving Initial position for cursor.
;			If not set, the routine will wait for a button 
;			to be pressed before continuing.
;
;	no_scale:	If set, tvdrag will not scale the levels of the
;			drag image to the bg image.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	2 element vector giving the point where the mouse button was released.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	tvline, tvpath, tvrec, tvcursor
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/1995
;	Modified:	Spitale, 8/2008
;	 Added window number inputs, xor_graphics option
;	
;-
;=============================================================================


;=============================================================================
; tvdrag_identity
;
;=============================================================================
function tvdrag_identity, p
 return, p
end
;=============================================================================



;=============================================================================
; tvdrag
;
;=============================================================================
function tvdrag, bg_image, drag_image, p0, win_num=win_num, restore=restore, $
   grid_function=grid_function, cursor_init=cursor_init, no_scale=no_scale, $
   xor_graphics=xor_graphics, add=add

 if(NOT keyword_set(grid_function)) then grid_function='tvdrag_identity'
 if(NOT keyword_set(win_num)) then win_num=!window

 if(NOT keyword_set(no_scale)) then $
   drag_image=imscl(drag_image, min(bg_image), max(bg_image))

 if(keyword_set(xor_graphics)) then device, set_graphics=6


;-------------------set up bg_image pixmap-----------------------

 s=size(bg_image)
 if(s[0] EQ 0) then $
  begin
   pixmap_win_num = bg_image
   wnum = !d.window
   wset, pixmap_win_num  
   pm_size = [!d.x_size, !d.y_size]
   wset, wnum
  end $
 else $
  begin
   pm_size=s(1:2)
   window, /pixmap, /free, xsize=s(1), ysize=s(2)
   pixmap_win_num=!d.window
   tvscl, bg_image, 0
  end


;----------------set up drag_image pixmap---------------------

 s=size(drag_image)
 if(s[0] EQ 0) then $
  begin
   drag_win_num = drag_image
   wnum = !d.window
   wset, pixmap_win_num  
   s = [2, !d.x_size, !d.y_size]
   wset, wnum
  end $
 else $
  begin
   window, /pixmap, /free, xsize=s(1), ysize=s(2)
   drag_win_num=!d.window
   tvscl, drag_image, 0
  end


;---------------get initial cursor position------------------

 wset, win_num

 if(NOT keyword_set(cursor_init)) then $
  repeat begin
   cursor, curs_x, curs_y, /change, /device
   button=!ERR
  endrep until(button NE 0) $
 else $
  begin
   curs_x=cursor_init(0)
   curs_y=cursor_init(1)
  end

 curs=call_function(grid_function, [curs_x, curs_y])
 curs_x=curs(0)
 curs_y=curs(1)


;------------use mouse cursor to position drag_image---------------

 xoff=p0(0)-curs_x					;Offset from cursor
 yoff=p0(1)-curs_y					;to drag_image origin.

 old_draw_x=p0(0)
 old_draw_y=p0(1)

 released = 0
 first = 1

 repeat begin     
  cursor, curs_x, curs_y, /change, /device

  button=!ERR
  p = call_function(grid_function, [curs_x, curs_y])	;quantize to grid
print, p
;  draw_x=(p(0)+xoff)<(pm_size(0)-s(1))>0
;  draw_y=(p(1)+yoff)<(pm_size(1)-s(2))>0
  draw_x=(p(0)+xoff)
  draw_y=(p(1)+yoff)

  if((draw_x EQ old_draw_x) AND (draw_y EQ old_draw_y)) then released = 1

  if(NOT keyword_set(xor_graphics)) then $ 
   device, copy=[old_draw_x, old_draw_y, $		;erase drag_image
    s(1)<(pm_size(0)-old_draw_x), $
    s(2)<(pm_size(1)-old_draw_y), $
    old_draw_x, old_draw_y, pixmap_win_num] $
  else if(NOT first) then $
   device, copy=[0, 0, $				;xor overdraw drag_image
    s(1)<(pm_size(0)-old_draw_x), $
    s(2)<(pm_size(1)-old_draw_y),  $
    old_draw_x, old_draw_y, drag_win_num]

  device, copy=[0, 0, $					;draw drag_image
    s(1)<(pm_size(0)-draw_x), $
    s(2)<(pm_size(1)-draw_y),  $
    draw_x, draw_y, drag_win_num]

  old_draw_x=draw_x
  old_draw_y=draw_y

  first = 0
 endrep until((button EQ 0) OR (released))


;------------------------------clean up-------------------------------------

 if(keyword_set(xor_graphics)) then device, set_graphics=3

 if(keyword_set(restore)) then $
  device, copy=[old_draw_x, old_draw_y, $		;erase drag_image
    s(1)<(pm_size(0)-old_draw_x), $			;if /restore
    s(2)<(pm_size(1)-old_draw_y), $
    old_draw_x, old_draw_y, pixmap_win_num]


 return, p
end
;=============================================================================

