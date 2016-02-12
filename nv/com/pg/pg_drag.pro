;=============================================================================
;+
; NAME:
;	pg_drag
;
;
; PURPOSE:
;	Allows the user to graphically translate and rotate an array of points
;	using the mouse.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	dxy = pg_drag(object_ps, dtheta=dtheta, axis_ps=axis_ps)
;
;
; ARGUMENTS:
;  INPUT:
;	object_ps:	Array (n_objects) of points_struct containing the
;			image points to be dragged.
;
;  OUTPUT: 
;	object_ps:	If /move, the input points will be modified by the
;			offsets resulting from the drag.
;
;
; KEYWORDS:
;  INPUT:
;	axis_ps:	points_struct containing a single image point
;			to be used as the axis of rotation.
;
;	sample:		Sampling interval for drag graphics.  The input
;			points are subsampled at this interval so that the
;			dragging can be done smoothly.  Default is 10.
;
;	move:		If set, object_ps will be modified on return using
;			pg_move.
;
;	symbol:		If set, the symbol number will be passed to cursor_move
;			so something other than a period can be used to mark
;			points.
;
;	noverbose:	If set, turns off the notification that cursor
;                       movement is required.
;
;	xor_graphics:	If set, grahics are drawn using the XOR function.
;
;	color:		Drawing color.  Default is ctyellow.
;
;  OUTPUT:
;	dtheta:		Dragged rotation in radians.
;
;
; RETURN:
;	2-element array giving the drag translation as [dx,dy].
;
;
; PROCEDURE:
;	cursor_move is used to perfform the drag.  See that routine for more
;	detail.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_move
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;      Modified by:     Dyer Lytle, Vance Haemmerle 11/1998
;	
;-
;=============================================================================
function pg_drag, object_ps, draw=draw, xor_graphics=xor_graphics, $
                  dtheta=dtheta, axis_ps=axis_ps, sample=_sample, move=move, $
		  symbol=symbol, noverbose=noverbose, color=color, fn=fn, data=data

 if(NOT keyword_set(_sample)) then sample=5 $
 else sample=_sample

 if(NOT keyword_Set(color)) then color=ctyellow()

 if(keyword_set(symbol)) then begin
   symtouse = symbol
 endif else begin
   symtouse = 3
 endelse

 ;------------------------------------------
 ; sort into points / curves
 ;------------------------------------------
 n_objects = n_elements(object_ps)
 star_ps = object_ps
 curve_ps = object_ps
 ncurves = (nstars = 0)

 for i=0, n_objects-1 do if(ps_valid(object_ps[i])) then $
  begin
   np = ps_nv(object_ps[i])*ps_nt(object_ps[i])
   if(np GT 1) then $
    begin
     curve_ps[ncurves] = object_ps[i]
     ncurves = ncurves + 1
    end $
   else $
    begin
     star_ps[nstars] = object_ps[i]
     nstars = nstars + 1
    end
  end

 if(ncurves GT 0) then curve_ps = curve_ps[0:ncurves-1]
 if(nstars GT 0) then star_ps = star_ps[0:nstars-1]

 ;------------------------------------------
 ; concatenate points into one array
 ;------------------------------------------
 object_pts = pg_points(object_ps)
 if(NOT keyword_set(object_pts)) then nv_message, name='pg_drag', $
                                                   'No visible object points.'
; xpoints=tr(object_pts[0,*])
; ypoints=tr(object_pts[1,*])

 xpoints = 0d
 ypoints = 0d
 sub_xpoints = 0d
 sub_ypoints = 0d

 if(nstars GT 0) then $
  begin
   star_pts = pg_points(star_ps)
   if(keyword_set(star_pts)) then $
    begin
     star_xpoints = tr(star_pts[0,*])
     star_ypoints = tr(star_pts[1,*])
     star_sub = lindgen(nstars)
     sub_xpoints = [sub_xpoints, star_xpoints]
     sub_ypoints = [sub_ypoints, star_ypoints]
     xpoints = [sub_xpoints, star_xpoints]
     ypoints = [sub_ypoints, star_ypoints]
    end
  end

 if(ncurves GT 0) then $
  begin
   curve_pts = pg_points(curve_ps)
   if(keyword_set(curve_pts)) then $
    begin
     curve_xpoints = tr(curve_pts[0,*])
     curve_ypoints = tr(curve_pts[1,*])
     sub_curve_pts = pg_points(curve_ps, sample=sample)
     curve_sub_xpoints = tr(sub_curve_pts[0,*])
     curve_sub_ypoints = tr(sub_curve_pts[1,*])
     sub_xpoints = [sub_xpoints, curve_sub_xpoints]
     sub_ypoints = [sub_ypoints, curve_sub_ypoints]
     xpoints = [xpoints, curve_xpoints]
     ypoints = [ypoints, curve_ypoints]
    end
  end

 xpoints = xpoints[1:*]
 ypoints = ypoints[1:*]
 sub_xpoints = sub_xpoints[1:*]
 sub_ypoints = sub_ypoints[1:*]

 

 ;------------------------------------------
 ; drag limb with cursor
 ;------------------------------------------
 if(NOT keyword_set(axis_ps)) then axis = [0l,0l] $
 else axis = ps_points(axis_ps)
 ax = axis[0] & ay = axis[1]

 tvcursor, /set
 if(NOT keyword_set(noverbose)) then $
   begin
    nv_message, 'Drag pointing using cursor and mouse buttons-', $
                 name='pg_drag', /continue
    nv_message, 'LEFT: Translate, MIDDLE: Rotate, RIGHT: Accept', $
                 name='pg_drag', /continue
   end
 cursor_move, ax, ay, xpoints, ypoints, sub_xpoints, sub_ypoints, $
             dx=dx, dy=dy, dtheta=dtheta, symbol=symtouse, star_sub=star_sub, $
             color=color, draw=draw, fn=fn, data=data, xor_graphics=xor_graphics
 tvcursor, /restore
 object_dxy=[dx,dy]


 ;------------------------------------------
 ; move the points
 ;------------------------------------------
 if(keyword_set(move)) then $
                       pg_move, object_ps, object_dxy, dtheta, axis_ps=axis_ps


 return, object_dxy
end
;=============================================================================
