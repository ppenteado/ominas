;=============================================================================
;+
; NAME:
;	icv_strip_curve
;
;
; PURPOSE:
;	Using Lagrange interpolation, extracts an image strip of a specified 
;	width centered on the specified curve.
;
;
; CATEGORY:
;	NV/LIB/TOOLS/ICV
;
;
; CALLING SEQUENCE:
;	strip = icv_strip_curve(cd, image, curve_pts, width, nD, $
;                                                   cos_alpha, sin_alpha)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:		Camera descriptor.
;
;	image:		Image from which to extract the strip.
;
;	curve_pts:	Array (2, n_points) of image points making up the curve.
;
;	width:		Width of the strip in pixels.
;
;	nD:		Number of samples across the width of the strip.
;
;	cos_alpha:	Array (n_points) of direction cosines computed by
;			icv_compute_directions.
;
;	sin_alpha:	Array (n_points) of direction sines computed by
;			icv_compute_directions.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT:
;	zero:		Zero-offset position in the strip.  This position
;			corresponds to where the specified curve falls in the
;			strip.
;
;
; RETURN:
;	Image strip (n_points, nD).
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
function icv_strip_curve, cd, image, curve_pts, width, nD, cos_alpha, sin_alpha, $
             zero=zero, grid_x=grid_x, grid_y=grid_y

 s = size(image)
 MM = make_array(nD,val=1.0)

 ;------------------------------------------------------------------------
 ; distances at which to take points - dist pixels above and below curve
 ;------------------------------------------------------------------------
 D = dindgen(nD)/nD*width - width/2

 ;-----------------------
 ; scanning grid points
 ;-----------------------
 grid_x = transpose(curve_pts[0,*]##MM + D#cos_alpha)
 grid_y = transpose(curve_pts[1,*]##MM + D#sin_alpha)

 ;---------------------------------------------
 ; extract strip 
 ;---------------------------------------------
 strip = image_interp_cam(cd=cd, image, grid_x, grid_y)

 zero = float(nD)/2d

 return, strip
end
;===========================================================================
