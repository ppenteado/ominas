;=============================================================================
;+
; NAME:
;       image_interp_cubic
;
;
; PURPOSE:
;       Extracts a region from an image using cubic interpolation.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = image_interp_cubic(image, grid_x, grid_y)
;
;
; ARGUMENTS:
;  INPUT:
;        image:         An array of image point arrays.
;
;       grid_x:         The grid of x positions for interpolation
;
;       grid_y:         The grid of y positions for interpolation
;
;	     k:		"Half-width" of the convolution window.  The
;			window actually covers the central pixel, plus
;			k pixels in each direction.  Default is 3, which
;			gives a 7x7 window.
;
;	fwhm:		If set, a gaussian with this half width is used for 
;			the psf instead of caling the user-supplied function.
;
;  OUTPUT:
;       NONE
;
;
; KEYORDS:
;  INPUT:
;	psf_fn:		Name of a function to compute the psf:
;
;				psf_fn(psf_data, x,y)
;
;			where x and y are the location relative to the 
;			center, and must accept arrays of any dimension.
;
;	psf_data:	Data for psf function as shown above.
;
;	mask:		Byte image indcating which pixels (value GT 0) should
;			be excluded from the interpolation.
;
;  OUTPUT:
;       NONE
;
;
; RETURN:
;       Array of interpolated points at the (grid_x, grid_y) points.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function image_interp_cubic, image, grid_x, grid_y, k, fwhm, valid=valid, $
                                     psf_fn=psf_fn, psf_data=psf_data, mask=mask, zmask=zmask

; interp = interpolate(image, grid_x, grid_y, cubic=-0.5)
; return, interp


a = -0.5d
k = 8

 s = size(image)

 lgrid_x = long(grid_x)
 lgrid_y = long(grid_y)

 n = 0.
 interp = 0
 for i=-k+1, k do $
  for j=-k+1, k do $
   begin
    grid_xi = lgrid_x + i
    grid_yj = lgrid_y + j

    sub = grid_xi + s[1]*grid_yj

    x_xi = abs(grid_x - grid_xi)
    y_yj = abs(grid_y - grid_yj)

    if(keyword_set(psf_fn)) then $
                      psf = call_function(psf_fn, psf_data, x_xi, y_yj) $
    else psf = gauss2d(x_xi, y_yj, sig)
psf=1d

fx = a*(x_xi)^3 - 5d*a*(x_xi)^2 +8d*a*x_xi - 4d*a
w = where(x_xi LE 1d)
if(w[0] NE -1) then fx[w] = (a+2d)*(x_xi[w])^3 - (a+3d)*(x_xi[w])^2 + 1d 

w = where(y_yj LE 1d)
fy = a*(y_yj)^3 - 5d*a*(y_yj)^2 +8d*a*y_yj - 4d*a
if(w[0] NE -1) then fy[w] = (a+2d)*(y_yj[w])^3 - (a+3d)*(y_yj[w])^2 + 1d 


    interp = interp + psf*image[sub]*fx*fy
    n = n + 1
   end

 return, interp * (1d/n)
end
;===========================================================================


