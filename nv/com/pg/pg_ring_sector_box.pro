;=============================================================================
;+
; NAME:
;	pg_ring_sector_box
;
; PURPOSE:
;	Allows the user to select a box to use with pg_profile_ring.
; 
; CATEGORY:
;       NV/PG
;
; CALLING SEQUENCE:
;     outline_ptd = pg_ring_sector_box()
;     outline_ptd = pg_ring_sector_box(corners)
;
;
; ARGUMENTS:
;  INPUT:
;      corners:	    Array of image points giving the corners of the box.
;		    If not given, the user is prompted to select a box. 
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
;        color:     Color to use for rectangle, default is !color.
;
; xor_graphics:     If set, the sector outline is drawn and erased using xor
;                   graphics instead of a pixmap.
;
;    noverbose:     If set, messages are suppressed.
;
;       sample:     Grid sampling, default is 1.
;
;
;  OUTPUT:
;       button:     Code of the detected button.
;
;
; RETURN: 
;      POINT containing points on the sector outline.  The point
;      spacing is determined by the sample keyword.
;
;
; ORIGINAL AUTHOR : J. Spitale ; 6/2005
;
;-
;=============================================================================



;=============================================================================
; pg_ring_sector_box
;
;=============================================================================
function pg_ring_sector_box, p, $
                         sample=sample, $
                         win_num=win_num, $
                         restore=restore, button=button, $
                         p0=p0, xor_graphics=xor_graphics, $
                         color=color, noverbose=noverbose


 ;----------------------------------------------------------------
 ; Wait for a click and call the appropriate routine
 ;----------------------------------------------------------------
 if(NOT keyword_set(noverbose)) then $
              nv_message, /con, name='pg_ring_sector', $
                 'Left:ortho, Right:oblique'

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
	; left: ortho
	;----------------------------------------
	1: return, pg_ring_sector_box_ortho(p, $
                         sample=sample, $
                         win_num=win_num, $
                         restore=restore, $
                         p0=[px,py], xor_graphics=xor_graphics, $
                         color=color, noverbose=noverbose)

	;----------------------------------------
	; right: oblique
	;----------------------------------------
	4: return, pg_ring_sector_box_oblique(p, $
                         sample=sample, $
                         win_num=win_num, $
                         restore=restore, $
                         p0=[px,py], xor_graphics=xor_graphics, $
                         color=color, noverbose=noverbose)
	else:
 endcase

end
;=====================================================================



pro test
ingrid, dd=dd, cd=cd, pd=pd, rd=rd

outline_ptd = pg_ring_sector_box()
outline_ptd = pg_ring_sector_box(tr([tr([0,0]),tr([1023,1023])]))

pg_draw,outline_ptd, col=ctred(), psym=-3

profile = pg_profile_ring(dd, cd=cd, dkx=rd, $
                                   outline_ptd, dsk_pts=dsk_pts, $
                                   sigma=sigma)
rads = dsk_pts[*,0]
lons = dsk_pts[*,1]

plot, rads, profile
end
