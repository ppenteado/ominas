;=============================================================================
;+
; NAME:
;       pg_strip
;
;
; PURPOSE:
;	Plots the portion of an image between two chosen points.
;
;
; CATEGORY:
;       COM/PG
;
;
; CALLING SEQUENCE:
;       pg_strip, im
;
;
; ARGUMENTS:
;  INPUT:
;       im:		The two-dimensional array from which the 
;			plotted strip will be extracted.
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;  INPUT:
;       width:		An odd integer giving the width in pixels of the 
;			extracted strip (default=5).  This width is rebinned
;			to a single pixel for plotting.
;
;	nw:		When set, each plot is done in a new window.
;
;	nomarks:	Suppresses the marks that show the locations of 
;			the chosen points, which are difficult to 
;			entirely erase.
;
;	xs:		Specifies the x-dimension of the window, in pixels.
;			Default is 400.
;
;	ys:		Specifies the y-dimension of the window, in pixels.
;			Default is 300.
;
;  OUTPUT:
;       NONE
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Tiscareno, 7/00
;
;-
;=============================================================================
pro pg_strip,im,width=width,nw=nw,nomarks=nomarks,device=device,xs=xs,ys=ys

im1=im
!err=0
i=0
pp1=pnt_create_descriptors()
pp2=pnt_create_descriptors()

; Mark chosen points with a plus sign.
_psyms=1
_psizes=1

if not keyword__set(width) then width=5
if (width mod 2) eq 0 then width=width+1	;width must be odd
dy=(width-1)/2

while !err ne 4 do begin

  print, 'Select first point...'
  cursor, x1, y1, device=device, /up
  if i ne 0 and not keyword__set(nomarks) then begin
    if !err eq 4 then quit=1	; pg_draw alters !err
    pg_draw, pp1, psyms=_psyms, psizes=_psizes, color=0
    pg_draw, pp2, psyms=_psyms, psizes=_psizes, color=0
  endif
  if !err eq 4 or keyword__set(quit) then return
  print, '    x = '+strtrim(x1,2)+'   y = '+strtrim(y1,2)
  if not keyword__set(nomarks) then begin
    pnt_set_points, pp1,[x1,y1]
    pg_draw, pp1, psyms=_psyms, psizes=_psizes, color=ctwhite()
  endif

  print, 'Select second point...'
  cursor, x2, y2, device=device, /up
  if !err eq 4 then return
  print, '    x = '+strtrim(x2,2)+'   y = '+strtrim(y2,2)
  if not keyword__set(nomarks) then begin
    pnt_set_points, pp2, [x2,y2]
    pg_draw, pp2, psyms=_psyms, psizes=_psizes, color=ctwhite()
  endif

  print, ''

  angle = atan( y2-y1 , x2-x1 ) * 180/!pi
  length = sqrt( (x2-x1)^2 + (y2-y1)^2 )

  ; Add extra space if needed (Rot outputs an array with 
  ; the same dimensions as the input)
  sz=(size(im1))[1:2]			; Dimensions of im
  if x1+length gt sz[0] then begin
    im1=[im1,replicate(0,x1+length-sz[0]+50,sz[1])]
  endif

  ; Rotate image so that desired strip is horizontal
  im2=rot(im1, angle, 1, x1, y1, /interp, /pivot)

  ; Crop strip and rebin it to a 1xn vector
  strip=(im2[x1:x1+length,*])[*,y1-dy:y1+dy]
  sz1=(size(strip))[1:2]		; Dimensions of strip
  prof=rebin(strip,sz1[0],1)

  ; Create new window, if this is the first cycle.
  if i eq 0 then begin
    winnum=!d.window
    if not keyword__set(xs) then xs=400
    if not keyword__set(ys) then ys=300
    window,/free,xs=xs,ys=ys
    pwinnum=!d.window
  endif else if keyword__set(nw) then begin
    window,/free,xs=xs,ys=ys
    pwinnum=!d.window
  endif

  wset,pwinnum
  plot,prof,/xstyle,/ystyle,ytitle='Data Number',xtitle='Pixels'

  wset,winnum
  tvim_set,/current

  i=i+1

endwhile

end
