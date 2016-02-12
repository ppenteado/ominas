;=============================================================================
;+
; NAME:
;	tvpath
;
;
; PURPOSE:
;	Returns device coordinates of vertices on a curve selected by the user.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	vertices = tvpath()
;
;
; ARGUMENTS:
;  INPUT:
;	win_num:	Window number of IDL graphics window in which to select
;			the path.  Default is current window.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	thick:		Thickness of the curve.
;
;	restore:	If set, the line is removed from the image at the end.
;
;	p0:		First point of line.  If set, then the routine
;			immediately begins to drag from that point until a
;			button is released.
;
;	grid_function:	Function which will quantize a point onto
; 			a grid.  It should take an orderered
;			pair as its only argument and return an
;			ordered pair.  Default is the identity function.
;
;	linestyle:	Linestyle to use for curve, default is 0.
;
;	select_button:	Index of button to use as the select button instead
;			of the left button (1).
;
;	erase_button:	Index of button to use as the erase button instead
;			of the middle button (2).
;
;	end_button:	Index of button to use as the end button instead
;			of the right button (4).
;
;	cancel_button:	Index of mouse button to be used as a cancel
;			button instead of left+middle, (3).
;
;	close:		If set, the curve will be closed when the end button
;			is pressed.
;
;	points:		If set, do not connect points.
;
;	psym:		Plotting symbol to use for each point.
;
;	copy		If set, copy mode is used instead of xor mode
;			for drawing.  An offscreen pixmap is used for erasing.
;
;	one:		If set, tvpath returns after any button is pressed.
;			If it is not the select button, then cancelled is set.
;
;	number:		If set, points are numbered as they are selected.
;
;
;  OUTPUT:
;	cancelled:	1 if the cancel button was pressed, 0 otherwise.
;			If /one, then 1 if any button other than select was
;			pressed.
;
;
; RETURN:
;	2xn array containing the selected vertices in device coordinates.
;
;
; PROCEDURE:
;	Points on the curve are selected by clicking the 'select button',
;	which is the left button by default.  Points are removed with
;	the 'erase button', the middle button by default.  The 'end button',
;	by default the right button, completes the curve.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	tvdrag, tvline, tvrec, tvcursor
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/1995
;	
;-
;=============================================================================


;=============================================================================
; tvpath_identity
;
;=============================================================================
function tvpath_identity, p
 return, p
end
;=============================================================================


 

;=============================================================================
; tvpath
;
;=============================================================================
function tvpath, win_num, $
                 thick=thick, $
                 restore=restore, close=close, autoclose=autoclose, $
                 p0=p0, grid_function=grid_function, linestyle=linestyle, $
                 cancel_button=cancel_button, cancelled=cancelled, $
                 select_button=select_button, erase_button=erase_button, $
                 end_button=end_button, psym=psym, color=color, $
                 copy=copy, one=one, number=number, points=points, np=np

 if(NOT keyword_set(psym)) then psym=-3
 if(NOT keyword_set(color)) then color=!p.color
 if(NOT keyword_set(cancel_button)) then cancel_button=3
 if(NOT keyword_set(select_button)) then select_button=1
 if(NOT keyword_set(erase_button)) then erase_button=2
 if(NOT keyword_set(end_button)) then end_button=4
 if(NOT keyword_set(win_num)) then win_num=!window
 if(NOT keyword_set(linestyle)) then linestyle=0
 if(keyword_set(points)) then linestyle=-1
 if(NOT keyword_set(grid_function)) then grid_function='tvpath_identity'
 copy = keyword_set(copy)
 one = keyword_set(one)
 number = keyword_set(number)

 if(NOT keyword_set(thick)) then thick=0

 if(NOT keyword_set(np)) then np = 1d100
 if(keyword_set(one)) then np = 1

 acdist = 10

 if(copy) then $
  begin
   wnum = !window
   xsize = !d.x_size
   ysize = !d.y_size
   window, /pixmap, xsize=xsize, ysize=ysize
   pnum = !window
   device, copy=[0,0,xsize,ysize,0,0,wnum]
   wset, wnum
  end $
 else $
  begin
   wset, win_num
   device, set_graphics=6                 ; xor mode
  end

 cancelled=0


;-------------get first point if not given-----------------

 if(NOT keyword_set(p0)) then $
  begin
   repeat begin
    cursor, px, py, /device, /down
    button=!err
    if(button EQ cancel_button) then cancelled = 1
    if((np EQ 1) AND (button NE select_button)) then cancelled = 1
   endrep until(button EQ select_button OR cancelled)

   if(cancelled) then return, 0
   p0 = [px,py]
  end $
 else begin
       px=p0[0]
       py=p0[1]
      end

 p=call_function(grid_function, [px, py])
 px=p[0]
 py=p[1]

 plots, px, py, /device, thick=thick, $
                      linestyle=linestyle, psym=psym, color=color
 if(number) then xyouts, /device, px+3, py+3, '0'

 xarr=[px,px]
 yarr=[py,py]
 old_px=px
 old_py=py
 old_qx=px
 old_qy=py

 vertices=[px,py]

 if(np EQ 1) then return, vertices


;-----------------main cursor loop------------------------

 acprimed = 0
 nv = 0

 count = 1

 repeat begin
  repeat begin
;   if(copy) then $
;    begin
;     wset, pnum
;     device, copy=[0,0,xsize,ysize,0,0,wnum]
;     wset, wnum
;    end

   if(psym LT 0) then $
         plots, xarr, yarr, /device, thick=thick, linestyle=linestyle,$
                psym=psym, color=color

;repeat $
; begin
   if(NOT keyword_set(points)) then cursor, qx, qy, /device, /change $
   else cursor, qx, qy, /device, /down
;   cursor, qx, qy, /device, /change
   button=!err
;endrep until((p_mag([qx,qy] - [old_qx,old_qy]) GT 1) OR (button EQ 0))

   if(button EQ cancel_button) then cancelled = 1

   if(qx EQ -1) then qx = old_qx
   if(qy EQ -1) then qy = old_qy

   q=call_function(grid_function, [qx, qy])
   qx=q[0]
   qy=q[1]

   oldxarr=xarr
   oldyarr=yarr
   xarr=[px, qx]
   yarr=[py, qy]
   if(psym LT 0) then $
    begin
     if(copy AND (old_px NE old_qx) AND (old_py NE old_qy)) then $
      begin
       device, copy=[min([old_px,old_qx]-1), min([old_py,old_qy]-1), $
                     abs(old_px-old_qx)+2, abs(old_py-old_qy)+2, $
                     min([old_px,old_qx]-1), min([old_py,old_qy]-1), pnum]

       device, copy=[p0[0]-5,p0[1]-5,11,11,p0[0]-5,p0[1]-5,pnum]

       plots, vertices[0,*], vertices[1,*], /device, thick=thick, $
              linestyle=linestyle, psym=psym, color=color

       if(keyword_set(autoclose)) then if(n_elements(vertices) GT 4) then $ 
                                 if(p_mag(q-p0) GT acdist) then acprimed = 1

       if(acprimed) then $
         if(p_mag(q-p0) LT acdist) then $
             plots, /device, p0, psym=6, col=ctwhite()-color

      end $ 
     else $
       plots, oldxarr, oldyarr, /device, thick=thick, linestyle=linestyle,$
               psym=psym, color=color
    end

   old_px=px
   old_py=py
   old_qx=qx
   old_qy=qy

  endrep until (button NE 0)
  nv = n_elements(vertices) / 2

  if(acprimed) then if(p_mag(q-p0) LT acdist) then $
   begin
    button = end_button
    close = 1
   end

  plots, vertices[0,*], vertices[1,*], /device, thick=thick, $	; erase
           linestyle=linestyle, psym=psym, color=color
;  if(keyword_set(labels)) then $
;           xyouts, /device, vertices[0,*]+3, vertices[1,*]+3, labels


  ;-----------------check buttons----------------

  case button of

  ;--------------------------select------------------------

   select_button : $
    begin
     px=qx
     py=qy

     vertices=transpose([transpose(vertices), transpose([qx,qy])])
     plots, vertices[0,*], vertices[1,*], /device, thick=thick, $
              linestyle=linestyle, psym=psym, color=color

     labels = strtrim(lindgen(n_elements(vertices)/2), 2)
     if(number) then xyouts, /device, vertices[0,*]+3, vertices[1,*]+3, labels
    end


  ;--------------------------end------------------------

   end_button : $
    begin
     vertices=transpose([transpose(vertices), transpose([qx,qy])])
     if(keyword__set(close)) then $
      vertices=transpose([transpose(vertices), transpose(vertices[*,0])])
    end


  ;--------------------------erase------------------------

   erase_button : $
    begin
     n=n_elements(vertices[0,*])
     if(n GT 1) then $
      begin
       px=vertices[0,n-1]
       py=vertices[1,n-1]

       if(copy AND (psym GT 0)) then $
                    device, copy=[px-5,py-5,11,11,px-5,py-5,pnum]

       px=vertices[0,n-2]
       py=vertices[1,n-2]

       vertices=vertices[*,0:n-2]

       plots, vertices[0,*], vertices[1,*], /device, thick=thick, $
                             linestyle=linestyle, psym=psym, color=color
      end
    end


   else :
  endcase

  count = count + 1
 endrep until(button EQ end_button OR cancelled OR (count GE np))

;----------------------end of main cursor loop--------------------------


 if(NOT keyword__set(restore) AND NOT cancelled) then $
      plots, vertices[0,*], vertices[1,*], /device, thick=thick, $
           linestyle=linestyle, psym=psym, color=color

 if(copy) then $
  begin
   wset, pnum
   wdelete
  end $
 else device, set_graphics=3

 wset, win_num

 return, vertices
end
;=====================================================================
