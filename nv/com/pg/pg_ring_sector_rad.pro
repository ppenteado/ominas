;=============================================================================
;+
; NAME:
;	pg_ring_sector_rad 
;
; PURPOSE:
;	Allows the user to select a ring sector by clicking and dragging.
;	The sector is defined along lines of constant radius and longitude.
; 
; CATEGORY:
;       NV/PG
;
; CALLING SEQUENCE:
;     outline_ptd=pg_ring_sector_rad(cd=cd, dkx=dkx)
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
;           cd:     Camera descriptor.
;
;	   dkx:     Disk descriptor describing the ring.
;
;           gd:     Generic descriptor containing the above descriptors.
;
;      win_num:     Window number of IDL graphics window in which to select
;                   box, default is current window.
;
;      restore:     Do not leave the box in the image.
;
;           p0:     First corner of box.  If set, then the routine immediately 
;                   begins to drag from that point until a button is released.
;
;        color:     Color to use for rectangle, default is !color.
;
;       sample:     Sets the grid sampling in pixels.  Default is one.
;
;        slope:     This keyword allows the longitude to vary as a function 
;                   of radius as: lon = slope*(rad - rad0).
;
; xor_graphics:     If set, the sector outline is drawn and erased using xor
;                   graphics instead of a pixmap.
;
;    noverbose:     If set, messages are suppressed.
;
;        nodsk:     If set, image points will not be included in the output 
;                   POINT.
;
;
;  OUTPUT:
;         NONE
;
;
; RETURN: 
;      POINT containing points on the sector outline.  The point
;      spacing is determined by the sample keyword.  The POINT object
;      also contains the disk coordinate for each point and the user fields
;      'nrad' and 'nlon' giving the number of points in radius and longitude.
;
;
; ORIGINAL AUTHOR : pg_ring_sector -- J. Spitale ; 8/94
; Modified: Haemmerle, 6/98
; renamed -- Spitale; 5/2005
;
;-
;=============================================================================



;=============================================================================
; pg_ring_sector_rad
;
;=============================================================================
function pg_ring_sector_rad, cd=cd, dkx=dkx, gd=gd, $
                         lon=lon, sample=sample, $
                         win_num=win_num, $
                         restore=restore, slope=slope, $
                         p0=p0, xor_graphics=xor_graphics, $
                         color=color, noverbose=noverbose, nodsk=nodsk

 if(NOT keyword_set(win_num)) then win_num=!window
 if(NOT keyword_set(color)) then color=!p.color
 xor_graphics = keyword_set(xor_graphics)

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(keyword_set(gd)) then $
  begin
   if(NOT keyword_set(cd)) then cd=gd.cd
   if(NOT keyword_set(dkx)) then dkx=gd.dkx
  end

 ;-----------------------------------
 ; validate descriptors
 ;-----------------------------------
 if(n_elements(dkx) GT 1) then $
                nv_message, 'No more than one ring descriptor may be specified.'
 if(n_elements(cds) GT 1) then $
                nv_message, 'No more than one camera descriptor may be specified.'
 rd = dkx[0]

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



 if(NOT keyword_set(noverbose)) then $
   nv_message, 'Drag and release to define ring sector', /continue


 ;-----------------------------------
 ; initial point
 ;-----------------------------------
 if(NOT keyword_set(p0)) then cursor, px, py, /down $
 else $
  begin
   px = p0[0] & py = p0[1]
  end

 point = (point0 = [px,py])
 dsk_pt0 = image_to_disk(cd, rd, point, body=body_pt0)

 prad = dsk_pt0[0]
 plon = dsk_pt0[1]

 xarr = [px,px,px,px,px]
 yarr = [py,py,py,py,py]
 old_qx = px
 old_qy = py

 ;--------------------------
 ; select sector
 ;--------------------------
 nrad = 5 & nlon = 10

 done = 0
 repeat begin
  plots, xarr, yarr, color=color, psym=-3
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

    ;--------------------------------------------
    ; make arrays of radius and longitude values
    ; sample at approx every 5 pixels
    ;--------------------------------------------
    dir = 0
    outline_pts = get_ring_profile_outline(cd, rd, $
                     tr([tr(point0), tr(point)]), nrad=nrad, nlon=nlon, $
                                              slope=slope, xlon=xlon, dir=dir)
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

 if(NOT keyword_set(restore)) then plots, xarr, yarr, color=color, psym=-3

 if(xor_graphics) then device, set_graphics=3 $
 else wdelete, pixmap



 ;--------------------------------------------
 ; resample
 ;--------------------------------------------
 dsk_outline_pts = image_to_disk(cd, rd, outline_pts)
 rads = dsk_outline_pts[nlon+lindgen(nrad),0]
 lons = dsk_outline_pts[lindgen(nlon), 1]

 nlonrad = get_ring_profile_n(outline_pts, cd, rd, lons, rads, oversamp=sample)
 nrad = long(nlonrad[1]) & nlon = long(nlonrad[0])

 outline_pts = get_ring_profile_outline(cd, rd, $
                    tr([tr(point0), tr(point)]), nrad=nrad, nlon=nlon, $
                                                          slope=slope, dir=dir)

 ;-------------------------------------------
 ; Return outline points
 ;-------------------------------------------
 dsk_outline_pts = 0
 if(NOT keyword_set(nodsk)) then $
                      dsk_outline_pts = image_to_disk(cd, rd, outline_pts)

 dsk_outline_pts[*,1] = rectify_angles(dsk_outline_pts[*,1])

 outline_ptd = pnt_create_descriptors(points = outline_pts, $
                      desc = 'pg_ring_sector_rad', $
                      data = transpose(dsk_outline_pts))
 cor_set_udata, outline_ptd, 'nrad', [nrad]
 cor_set_udata, outline_ptd, 'nlon', [nlon]

 return, outline_ptd
end
;=====================================================================
