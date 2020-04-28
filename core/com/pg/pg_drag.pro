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
;	dxy = pg_drag(object_ptd, dtheta=dtheta, axis_ptd=axis_ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	object_ptd:	Array (n_objects) of POINT containing the
;			image points to be dragged.
;
;  OUTPUT: 
;	object_ptd:	If /move, the input points will be modified by the
;			offsets resulting from the drag.
;
;
; KEYWORDS:
;  INPUT:
;	axis_ptd:	POINT containing a single image point
;			to be used as the axis of rotation.
;
;	sample:		Sampling interval for drag graphics.  The input
;			points are subsampled at this interval so that the
;			dragging can be done smoothly.  Default is 10.
;
;	move:		If set, object_ptd will be modified on return using
;			pg_move.
;
;	symbol:		If set, the symbol number will be passed to cursor_move
;			so something other than a period can be used to mark
;			points.
;
;	silent:		If set, turns off the notification that cursor
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
function pg_drag, object_ptd, draw=draw, xor_graphics=xor_graphics, $
                  dtheta=dtheta, axis_ptd=axis_ptd, sample=_sample, move=move, $
		  symbol=symbol, silent=silent, color=color, fn=fn, data=data

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
 n_objects = n_elements(object_ptd)
 star_ptd = object_ptd
 curve_ptd = object_ptd
 ncurves = (nstars = 0)

 for i=0, n_objects-1 do if(pnt_valid(object_ptd[i])) then $
  begin
   np = pnt_nv(object_ptd[i])*pnt_nt(object_ptd[i])
   if(np GT 1) then $
    begin
     curve_ptd[ncurves] = object_ptd[i]
     ncurves = ncurves + 1
    end $
   else $
    begin
     star_ptd[nstars] = object_ptd[i]
     nstars = nstars + 1
    end
  end

 if(ncurves GT 0) then curve_ptd = curve_ptd[0:ncurves-1]
 if(nstars GT 0) then star_ptd = star_ptd[0:nstars-1]

 ;------------------------------------------
 ; concatenate points into one array
 ;------------------------------------------
 object_pts = pnt_points(object_ptd, /vis)
 if(NOT keyword_set(object_pts)) then nv_message, 'No visible object points.'
; xpoints=tr(object_pts[0,*])
; ypoints=tr(object_pts[1,*])

 xpoints = 0d
 ypoints = 0d
 sub_xpoints = 0d
 sub_ypoints = 0d

 if(nstars GT 0) then $
  begin
   star_pts = pnt_points(/cat, /vis, star_ptd)
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
   curve_pts = pnt_points(/cat, /vis, curve_ptd)
   if(keyword_set(curve_pts)) then $
    begin
     curve_xpoints = tr(curve_pts[0,*])
     curve_ypoints = tr(curve_pts[1,*])
     sub_curve_pts = pnt_points(/cat, /vis, curve_ptd, sample=sample)
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
 ; drag points with cursor
 ;------------------------------------------
 if(NOT keyword_set(axis_ptd)) then axis = [0l,0l] $
 else axis = pnt_points(axis_ptd)
 ax = axis[0] & ay = axis[1]

 tvcursor, /set
 if(NOT keyword_set(silent)) then $
   begin
    nv_message, 'Drag pointing using cursor and mouse buttons-', /continue
    nv_message, 'LEFT: Translate, MIDDLE: Rotate, RIGHT: Accept', /continue
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
                       pg_move, object_ptd, object_dxy, dtheta, axis_ptd=axis_ptd


 return, object_dxy
end
;=============================================================================
