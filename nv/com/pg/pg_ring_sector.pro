;=============================================================================
;+
; NAME:
;	pg_ring_sector 
;
; PURPOSE:
;	Allows the user to select a ring sector by clicking and dragging.
;	With the left button, the sector is defined along lines of constant 
;	radius and longitude.  With the right button, the sides of the sector
;	are perpendicular to the projected radial direction.
; 
; CATEGORY:
;       NV/PG
;
; CALLING SEQUENCE:
;     rad=pg_ring_sector(cd=cd, dkx=dkx, gbx=gbx)
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
;          gbx:     Globe descriptor giving the primary for the ring.
;
;           gd:     Generic descriptor containnig the above descriptors.
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
;        slope:     This keyword allows the longitude to vary from the
;                   nominal direction as a function of radius as: 
;                   lon = slope*(rad - rad0).
;
;       sample:     Sets the grid sampling in pixels.  Default is one.
;
; xor_graphics:     If set, the sector outline is drawn and erased using xor
;                   graphics instead of a pixmap.
;
;        nodsk:     If set, image points will not be included in the output 
;                   POINT.
;
;    noverbose:     If set, messages are suppressed.
;
;      rad,lon:     If set, these values are used as bounds for the ring 
;                   the ring sector instead of pronpting the user. 
;
;
;  OUTPUT:
;       button:     Code of the detected button.
;
;
; RETURN: 
;      POINT containing points on the sector outline.  The point
;      spacing is determined by the sample keyword.  The POINT object
;      also contains the disk coordinate for each point and the user fields
;      'nrad' and 'nlon' giving the number of points in radius and longitude.
;
;
; MODIFICATION HISTORY : 
;	J. Spitale ; 5/2005 -- Original pg_ring_sector renamed 
;	                       pg_ring_sector_rad; this program created.
;
;-
;=============================================================================



;=============================================================================
; pg_ring_sector
;
;=============================================================================
function pg_ring_sector, cd=cd, dkx=dkx, gbx=_gbx, gd=gd, $
                         rad=rad, lon=lon, sample=sample, $
                         win_num=win_num, $
                         restore=restore, slope=slope, $
                         p0=p0, button=button, xor_graphics=xor_graphics, $
                         color=color, noverbose=noverbose, nodsk=nodsk

 ;--------------------------------------------------------
 ; if rad/lon bounds given, just build outline and return
 ;--------------------------------------------------------
 if(keyword_set(rad)) then $
   return, pg_ring_sector_radlon(cd=cd, dkx=dkx, gbx=_gbx, gd=gd, rad, lon)


 ;----------------------------------------------------------------
 ; Otherwise, wait for a click and call the appropriate routine
 ;----------------------------------------------------------------
 if(NOT keyword_set(noverbose)) then $
              nv_message, /con, name='pg_ring_sector', $
                 'Left:radial, Middle:oblique, Right:perpendicular'

 if(keyword_set(p0)) then $
  begin
   px = p0[0] & py = p0[1]
  end $
 else $
  begin
   device, cursor_standard=30
   cursor, px, py, /down
   button = !err
  end


 case button of
	;----------------------------------------
	; left: radial sector
	;----------------------------------------
	1: return, pg_ring_sector_rad(cd=cd, dkx=dkx, gbx=_gbx, gd=gd, $
                         lon=lon, sample=sample, $
                         win_num=win_num, $
                         restore=restore, slope=slope, $
                         p0=[px,py], xor_graphics=xor_graphics, $
                         color=color, noverbose=noverbose, nodsk=nodsk)

	;----------------------------------------
	; middle:
	;----------------------------------------
	2: return, pg_ring_sector_oblique(cd=cd, dkx=dkx, gbx=_gbx, gd=gd, $
                         lon=lon, sample=sample, $
                         win_num=win_num, $
                         restore=restore, slope=slope, $
                         p0=[px,py], xor_graphics=xor_graphics, $
                         color=color, noverbose=noverbose, nodsk=nodsk)

	;----------------------------------------
	; right: perpendicular sector
	;----------------------------------------
	4: return, pg_ring_sector_perp(cd=cd, dkx=dkx, gbx=_gbx, gd=gd, $
                         lon=lon, sample=sample, $
                         win_num=win_num, $
                         restore=restore, slope=slope, $
                         p0=[px,py], xor_graphics=xor_graphics, $
                         color=color, noverbose=noverbose, nodsk=nodsk)
	else:
 endcase
end
;=====================================================================
