;=============================================================================
;+
; NAME:
;	pg_drag_shadow_plane
;
;
; PURPOSE:
;	Allows the user to graphically rotate a plane passing through the 
;	center of a planet by dragging the shadow cast by the planet on the
;	plane using the mouse.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	dxy = pg_drag_shadow_plane(cd=cd, gbx=gbx, sund=sund)
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	cd:	 Camera descriptor.
;
;	gbx:	 Subclass of GLOBE.
;
;	sund:	 Star descriptor for the Sun.
;
;	gd:	Generic descriptor.  If given, the descriptor inputs 
;		are taken from this structure if not explicitly given.
;
;	dd:	Data descriptor containing a generic descriptor to use
;		if gd not given.
;
;	p0:	 Initial point to use instead  of prompting the user.
;
;	n0:	 Initial plane orientation.  Default is the planet y-axis.
;
;	gain:	 Radians / pixel offset from the initial point.
;
;	axis:	 Rotation axis; default is the planet pole.
;
;	silent:	 If set, turns off notifications.
;
;	xor_graphics:	If set, grahics are drawn using the XOR function.
;
;	color:		Drawing color.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Column vector giving the final plane orientation.
;
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2012
;	
;-
;=============================================================================



;=============================================================================
; pgdsp_compute
;
;=============================================================================
function pgdsp_compute, cd, pd, sund, n0, term_ptd, axis, theta, n=n
common pickplane_compute_points_block, dkd

 n = v_rotate_11(n0, axis, sin(theta), cos(theta))

 ;----------------------------------------------------------------
 ; set up disk descriptor describing shadow plane
 ;----------------------------------------------------------------
 xx = v_unit(v_cross(n, tr([1,0,0])))
 yy = v_unit(v_cross(n, xx))

 if(NOT keyword_set(dkd)) then dkd = dsk_create_descriptors(1)
 bod_set_orient, dkd, [xx, yy, n]
 bod_set_pos, dkd, bod_pos(pd)
 sma = dsk_sma(dkd) & sma[0,1] = 1d100 & dsk_set_sma, dkd, sma


 ;----------------------------------------------------------------
 ; project shadow
 ;----------------------------------------------------------------
 shadow_ptd = pg_shadow_disk(cd=cd, od=sund, dkx=dkd, term_ptd)

 return, shadow_ptd
end
;=============================================================================



;=============================================================================
; pg_drag_shadow_plane
;
;=============================================================================
function pg_drag_shadow_plane, cd=cd, gbx=gbx, sund=sund, dd=dd, gd=gd, xor_graphics=xor_graphics, $
                  p0=p0, n0=n0, silent=silent, color=color, gain=gain, $
                  axis=axis, shadow_ptd=shadow_ptd

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(NOT keyword_set(cd)) then cd = dat_gd(gd, dd=dd, /cd)
 if(NOT keyword_set(gbx)) then gbx = dat_gd(gd, dd=dd, /gbx)
 if(NOT keyword_set(sund)) then sund = dat_gd(gd, dd=dd, /sund)

 device, cursor_standard=30

 if(keyword_set(p0)) then p0 = double(p0)
 if(NOT keyword_set(gain)) then gain = 2d*!dpi/max(cam_size(cd)) 

 if(NOT keyword_set(win_num)) then win_num=!window
 if(NOT keyword_set(color)) then color=!p.color
 xor_graphics = keyword_set(xor_graphics)


 ;-----------------------------------
 ; initial point
 ;-----------------------------------
 if(NOT keyword_set(silent)) then $
         nv_message, /con, 'Left:rotate about pole, Right:rotate about equator'

 if(NOT keyword_set(p0)) then $
  begin
   cursor, px, py, /down
   button = !err
   p0 = [px, py]
  end


 ;-----------------------------------
 ; get body vectors
 ;-----------------------------------
 xx = (bod_orient(gbx))[0,*]
 yy = (bod_orient(gbx))[1,*]
 zz = (bod_orient(gbx))[2,*]

 if(NOT keyword_set(n0)) then n0 = yy
 if(NOT keyword_set(axis)) then axis = zz

 n = n0


 ;-----------------------------------
 ; compute terminator
 ;-----------------------------------
 term_ptd = pg_limb(cd=cd, gbx=gbx, od=sund, np=5000)


 ;-----------------------------------
 ; setup pixmap
 ;-----------------------------------
 wset, win_num
 if(xor_graphics) then device, set_graphics=6 $               ; xor mode
 else $
  begin
   window, /free, /pixmap, xsize=!d.x_size, ysize=!d.y_size
   pixmap = !d.window
   device, copy=[0,0, !d.x_size,!d.y_size, 0,0, win_num]
   wset, win_num
  end


 ;----------------------------------------------------------
 ; select shadow plane
 ;----------------------------------------------------------
 if(NOT keyword_set(silent)) then $
  begin
   nv_message, 'Drag to rotate shadow plane.', /continue
  end


 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; compute initial model
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 shadow_ptd = pgdsp_compute(cd, gbx, sund, n0, term_ptd, axis, 0)
 shadow_pts = pnt_points(/cat, /vis, shadow_ptd)
 xarr = shadow_pts[0,*]
 yarr = shadow_pts[1,*]


 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; drag model
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 done = 0
 repeat begin
  plots, xarr, yarr, color=color, psym=3
  cursor, qx, qy, /change
  button=!err

  if(button EQ 0) then done = 1 $
  else $
   begin
    if(qx EQ -1) then qx = old_qx
    if(qy EQ -1) then qy = old_qy

    oldxarr = xarr
    oldyarr = yarr

    point = [qx,qy]

    ;- - - - - - - - - - - - - - - -
    ; compute shadow points
    ;- - - - - - - - - - - - - - - -
    theta = (point[0] - p0[0]) * gain
    shadow_ptd = pgdsp_compute(cd, gbx, sund, n0, term_ptd, axis, theta, n=n)
    shadow_pts = pnt_points(/cat, /vis, shadow_ptd)
    xarr = shadow_pts[0,*]
    yarr = shadow_pts[1,*]

    ;- - - - - - - - - - - - - - - -
    ; erase
    ;- - - - - - - - - - - - - - - -
    if(xor_graphics) then $
      plots, oldxarr, oldyarr, color=color, psym=3 $
    else device, copy=[0,0, !d.x_size,!d.y_size, 0,0, pixmap]

    old_qx = qx
    old_qy = qy

   end
 endrep until(done)



 return, n
end
;=============================================================================
