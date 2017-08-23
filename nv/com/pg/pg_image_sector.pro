;=============================================================================
;+
; NAME:
;	pg_image_sector
;
; PURPOSE:
;	Allows the user to select a rectangular image region, with an
;	arbitrary tilt, by clicking and dragging.  A rectangle is selected
;	using the left mouse button and a line of zero width is selected
;	using the right moise button.
;
; CATEGORY:
;       NV/PG
;
; CALLING SEQUENCE:
;     outline_ptd = pg_image_sector()
;
;
; ARGUMENTS:
;  INPUT:
;      NONE
;
;  OUTPUT:
;	NONE
;
;
;
; KEYWORDS:
;  INPUT: 
;      win_num:     Window number of IDL graphics window in which to select
;                   box, default is current window.
;
;      restore:     Do not leave the box in the image.
;
;           p0:     First corner of box.  If set, then the routine immediately 
;                   begins to drag from that point until a button is released.
;
;           p1:     Endpoint.  If given, p0 must also be given and is taken
;                   as the starting point for a line along which to scan.
;                   In this case, the user does not select the box manually.
;                   Scan width is one pixel unless 'width' is specified,
;                   and is centered on the line from p0 to p1.
;
;        width:     Width of box instead of letting the user select.
;
;        color:     Color to use for rectangle, default is !color.
;
; xor_graphics:     If set, the sector outline is drawn and erased using xor
;                   graphics instead of a pixmap.
;
;       sample:	    Pixel grid sampling to use instead of 1.
;
;      corners:     If set, then p0 and p1 are taken as the corners of
;                   the box, and the user is not prompted to select one.
;
;       silent:     If set, messages are suppressed.
;
;
;  OUTPUT:
;         NONE
;
; KNOWN BUGS:
;	The sector flips when it hits zero azimuth rather than retaining a 
;	consistent sense.
;
;
; RETURN: 
;      POINT containing points on the sector outline.  The point
;      spacing is determined by the sample keyword. 
;
; ORIGINAL AUTHOR : J. Spitale ; 6/2005
;
;-
;=============================================================================
function pg_image_sector, sample=sample, $
                         win_num=win_num, width=width, $
                         restore=restore, $
                         p0=_p0, p1=p1, xor_graphics=xor_graphics, $
                         color=color, silent=silent, corners=corners

 device, cursor_standard=30

 if(keyword_set(p0)) then p0 = double(p0)
 if(keyword_set(p1)) then p1 = double(p1)

 if(NOT keyword_set(win_num)) then win_num=!window
 if(NOT keyword_set(color)) then color=!color
 xor_graphics = keyword_set(xor_graphics)


 ;-----------------------------------
 ; initial point
 ;-----------------------------------
 if(NOT keyword_set(silent)) then $
                      nv_message, /con, 'Left:box scan, Right:line scan'

 if(NOT keyword_set(_p0)) then $
  begin
   cursor, px, py, /down
   button = !err
   if(button EQ 4) then width = 1
   _p0 = [px, py]
  end

 if(keyword_set(p1)) then points = transpose([transpose(_p0),transpose(p1)]) $
 else $
  begin
   if(NOT keyword_set(silent)) then $
     nv_message, 'Drag and release to define length of image sector', /continue


   ;----------------------------------------------------------
   ; select length of sector
   ;----------------------------------------------------------
   pp0 = (convert_coord(double(_p0), /data, /to_device))[0:1,*]
   pp = tvline(p0=pp0, color=color, restore=restore)
   points = (convert_coord(double(pp), /to_data, /device))[0:1,*]
   p0 = points[*,1]

   ;----------------------------------------------------------
   ; select width of sector unless specified
   ;----------------------------------------------------------
   if(NOT keyword_set(width)) then $
    begin
     if(NOT keyword_set(silent)) then $
       nv_message, 'Drag and click to define width of image sector', /continue

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


     px = p0[0] & py = p0[1]
     point = [px,py]

     xarr = [px,px,px,px,px]
     yarr = [py,py,py,py,py]
     old_qx = px
     old_qy = py

     ;--------------------------
     ; select sector
     ;--------------------------
     done = 0
     repeat begin
      plots, xarr, yarr, color=color, psym=-3
      cursor, qx, qy, /change
      button=!err

      if(button NE 0) then done = 1 $
      else $
       begin
        if(qx EQ -1) then qx = old_qx
        if(qy EQ -1) then qy = old_qy

        oldxarr = xarr
        oldyarr = yarr

        point = [qx,qy]

        ;--------------------------------------------
        ; make sector outline
        ;--------------------------------------------
        outline_pts = get_image_profile_outline(points, point, nw=2, nl=2)
        outline_pts = reform(outline_pts)

        xarr = outline_pts[0,*]
        yarr = outline_pts[1,*]

        ;--------------------------------------------
        ; erase
        ;--------------------------------------------
        if(xor_graphics) then $
          plots, oldxarr, oldyarr, color=color, psym=-3 $
        else device, copy=[0,0, !d.x_size,!d.y_size, 0,0, pixmap]

        old_qx = qx
        old_qy = qy

       end
     endrep until(done)

     if(NOT keyword__set(restore)) then plots, xarr, yarr, color=color, psym=-3

     if(xor_graphics) then device, set_graphics=3 $
     else wdelete, pixmap
    end

  end



 ;----------------------------------------------------------
 ; set width if specified
 ;----------------------------------------------------------
 if(keyword_set(width)) then if(width NE 1) then $
  begin
   width = double(width)
   w2 = width/2d

   v = p_unit(points[*,1] - points[*,0])
   n = [-v[1], v[0]]

   point = points[*,1] - n*w2
   points = points + n#make_array(2,val=1d)*w2
  end



 ;--------------------------------------------
 ; resample
 ;--------------------------------------------
 if(keyword_set(corners)) then $
  begin
   nl = 2
   nw = 1
   sample = 0
   outline_pts = points
  end $
 else outline_pts = get_image_profile_outline(points, point, $
                                               sample=sample, nl=nl, nw=nw)

 ;-------------------------------------------
 ; Return outline points
 ;-------------------------------------------
 outline_ptd = pnt_create_descriptors(points = outline_pts, desc = 'PG_IMAGE_SECTOR')
 cor_set_udata, outline_ptd, 'nl', [nl]
 cor_set_udata, outline_ptd, 'nw', [nw]
 cor_set_udata, outline_ptd, 'sample', [sample]

 return, outline_ptd
end
;=====================================================================



pro test

grift, dd=dd, cd=cd
ptd = pg_image_sector(p0=[100,100], p1=[200,200], /nov, width=10)
pg_draw, ptd, col=ctred()
dd_profile = pg_profile_image(dd, ptd, profile=profile)
plot, profile
grim, dd_profile



end
