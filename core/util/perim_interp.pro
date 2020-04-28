;=============================================================================
;+
; NAME:
;	perim_interp
;
;
; PURPOSE:
;	Interpolates within given ellipses in an image.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = perim_interp(image, center_pts, a, b, h)
;
;
; ARGUMENTS:
;  INPUT:
;	image:		Input image.
;
;	center_pts:	Array (2,n) giving ellipse centers.
;
;	a:		Scalar giving the semimajor axis of the ellipses.
;
;	b:		Scalar giving the semiminor axis of the ellipses.
;
;	h:		Scalar giving the rotation of the ellipse semimajor axes
;			from horizontal.  (radians)
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	show:		If set, the outlines of the ellipses are plotted on 
;			the current graphics window.
;
;  OUTPUT:
;	NONE
;
;
; RETURN:
;	Image array in which the pixels contained in the specified ellipses
;	havwe been interpolated from the pixels along the perimeters of the 
;	ellipses.
;
;
; PROCEDURE:
;	Each point in each ellipse is replaced by an average of the points on
;	the perimeter, weighted by the inverse square of the point's distance
;	from each perimeter point. 
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 5/2002
;	
;-
;=============================================================================
function perim_interp, image, center_pts, a, b, h, show=show


 n = n_elements(center_pts)/2
 s = size(image)
 xsize = s[1]
 ysize = s[2]

 a2 = a^2
 b2 = b^2


 ;------------------------------------------------------
 ; extract perimeter pixels for each blemish
 ;------------------------------------------------------
 nper = long(2d*!dpi*sqrt(0.5d*(a^2+b^2)))

 theta = dindgen(nper)/double(nper) * 2d*!dpi
 sin_theta = sin(theta)
 cos_theta = cos(theta)
 sin_h = sin(h)
 cos_h = cos(h)
 dr = a*b / sqrt(a2*(sin_theta*cos_h - cos_theta*sin_h)^2 + $
                 b2*(cos_theta*cos_h + sin_theta*sin_h)^2)

 _perx = dr*cos_theta
 _pery = dr*sin_theta


 ;------------------------------------------------------
 ; determine subscripts within each perimeter
 ;------------------------------------------------------

 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 ; extract a box centered at 0,0
 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 nn = 2*a + 1
 boxx = (dindgen(nn) - a)#make_array(nn,val=1d)
 boxy = transpose(boxx)

 w = where((boxx EQ 0) AND (boxy EQ 0))		; avoid undefined arctan 
 boxx[w] = b/10d
 boxy[w] = b/10d

 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 ; compute r, theta in box
 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 r = sqrt((boxx)^2 + (boxy)^2)
 theta = atan(boxy,boxx)
 sin_theta = sin(theta)
 cos_theta = cos(theta)

 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 ; select points within ellipse at 0,0
 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 w = where(r LT a*b / sqrt(a2*(sin_theta*cos_h - cos_theta*sin_h)^2 + $
                 b2*(cos_theta*cos_h + sin_theta*sin_h)^2))

 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 ; determine interpolation coefficients
 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 nell = n_elements(w)
 _ellx = double(w mod nn) - a
 _elly = double(fix(w/nn)) - a

 dx = _ellx#make_array(nper,val=1d) - _perx##make_array(nell,val=1d)
 dy = _elly#make_array(nper,val=1d) - _pery##make_array(nell,val=1d)

 itp =  1d/(dx^2 + dy^2)
 norm = total(itp,2)#make_array(nper,val=1d)
 itp = itp/norm

 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 ; translate coords to each center
 ;- - - - - - - - - - - - - - - - - - - - - - - - - -
 perx = _perx#make_array(n,val=1d) + (center_pts[0,*])##make_array(nper,val=1d)
 pery = _pery#make_array(n,val=1d) + (center_pts[1,*])##make_array(nper,val=1d)
 if(keyword__set(show)) then plots, perx, pery, psym=3

 ellx = _ellx#make_array(n,val=1d) + (center_pts[0,*])##make_array(nell,val=1d)
 elly = _elly#make_array(n,val=1d) + (center_pts[1,*])##make_array(nell,val=1d)

 ell_sub = xsize*long(elly) + long(ellx)
 per_sub = reform(transpose(xsize*long(pery) + long(perx)), 1, n,nper, /over)

 ;------------------------------------------------------
 ; interpolate
 ;------------------------------------------------------
 new_val = total((double(image[per_sub]))[linegen3x(nell,n,nper)] * $
                                            itp[linegen3y(nell,n,nper)], 3)



 new_image = image
 new_image[ell_sub] = new_val
;stop

 return, new_image
end
;=============================================================================
