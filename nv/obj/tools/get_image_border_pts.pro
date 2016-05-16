;=============================================================================
;+
; NAME:
;       get_image_border_pts
;
;
; PURPOSE:
;	Computes points around the edge of an image.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       border_pts_im = get_image_border_pts(cd)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Camera descripor.
;
;  OUTPUT:  NONE
;
;
; KEYOWRDS:
;  INPUT: 
;	corners:	Array(2,2) giving corners of image region to border
;
;	center:		Array (2) giving the center of the image to use
;			instead of the optic axis.
;
;	crop:		Number of pixels by which to shrink the image border in 
;			each direction.
;
;	sample:		Sampling rate; default is 1 pixel.
;
;	aperture:	If set, a circular aperture with a diameter equal to the
;			logest dimension of the image is used.  (not complete)
;
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array (2,np) of image points on the image border.  np is computed
;	such that points are spaced by one pixel.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function get_image_border_pts, cd, corners=corners, center=center, crop=crop, $
                sample=sample, aperture=aperture

 if(NOT keyword_set(crop)) then crop = 0
 if(NOT keyword_set(center)) then center = cam_oaxis(cd)
 if(NOT keyword_set(sample)) then sample = 1

 cam_size = double(cam_size(cd))
 nx = cam_size[0]/sample & ny = double(cam_size[1])/sample
 
 if(NOT keyword_set(corners)) then $
   corners = tr([tr([0d,0]), tr([nx-1,0]), tr([nx-1,ny-1]), tr([0,ny-1])]) + 0.5

 corners = double(corners) + (center - cam_oaxis(cd))#make_array(4, val=1d)

 xmin = min(corners[0,*]) + crop
 ymin = min(corners[1,*]) + crop
 xmax = max(corners[0,*]) - crop
 ymax = max(corners[1,*]) - crop

 dx = (xmax - xmin)/nx
 dy = (ymax - ymin)/ny

 xx = dindgen(nx)*dx + xmin
 yy = dindgen(ny)*dy + ymin
 np = 2*(nx+ny)

 border_pts_im = dblarr(2, np) 
 border_pts_im[0,*] = [xx, make_array(ny, val=xmax), rotate(xx,2), make_array(ny, val=xmin)]
 border_pts_im[1,*] = [make_array(nx, val=ymin), yy, make_array(nx, val=ymax), rotate(yy,2)]

 return, border_pts_im
end
;===========================================================================
