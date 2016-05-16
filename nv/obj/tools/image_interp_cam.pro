;=============================================================================
;+
; NAME:
;       image_interp_cam
;
;
; PURPOSE:
;       Extracts a region from an image using the desired interpolation,
;	accouting for the camera point-spread function is applicable.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = image_interp_cam(image, grid_x, grid_y, args)
;
;
; ARGUMENTS:
;  INPUT:
;	image:	An array of image point arrays.
;
;	grid_x:	The grid of x positions for interpolation
;
;	grid_y:	The grid of y positions for interpolation
;
;	args:	Arguments to pass to the interpolation function.
;
;  OUTPUT:  NONE
;
;
; KEYOWRDS:
;  INPUT: 
;	cd:	Camera descriptor.
;
;	interp:	Type of interpolation to use.  Options are:
;		'nearest', 'mean', 'bilinear', 'cubic', 'sinc'.
;
;	k:	"Half-width" of the convolution window.  The
;		window actually covers the central pixel, plus
;		k pixel in each direction.  Default is 3, which
;		gives a 7x7 window.
;
;	kmax:	Maximum value for k.
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Array of interpolated points at the (grid_x, grid_y) points.
;
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function image_interp_cam, cd=cd, image, grid_x, grid_y, args, valid=valid, $
                                     k=k, interp=interp, kmax=kmax, mask=mask, zmask=zmask

 if(NOT keyword_set(interp)) then interp = 'sinc'

 case interp of
  'nearest'  : nearest = 1
  'mean'     : mean = 1
  'bilinear' : bilinear = 1
  'cubic'    : cubic = 1
  'sinc'     : sinc = 1
  else 	     : nv_message, name='image_interp_cam', 'Invalid interpolation flag.'
 endcase


 if(NOT keyword_set(cd)) then force_bilinear = 1 $
 else if(NOT keyword_set(cam_psf(cd))) then force_bilinear = 1
 if(NOT keyword_set(sinc)) then force_bilinear = 0

 if(keyword_set(force_bilinear)) then $
  begin
   bilinear = 1
   nearest = 0
   sinc = 0
   cubic = 0
   mean = 0
  end

 dim = size(grid_x, /dim)
 nxy = n_elements(grid_x)
 result = make_array(dim=dim, val=0d)

 grid_xy = [reform(grid_x, 1, nxy), reform(grid_y, 1, nxy)]
 dim = size(image, /dim)
 w = in_image(0, xmin=0, ymin=0, xmax=dim[0]-1, ymax=dim[1]-1, grid_xy, slop=1)
 if(w[0] NE -1) then $
  begin
   _grid_x = grid_x[w]
   _grid_y = grid_y[w]
 
   _result = image_interp(sinc=sinc, cubic=cubic, nearest=nearest, mean=mean, $
                                       image, _grid_x, _grid_y, args, $
                                       k=k, psf_fn='cam_psf', psf_data=cd, $
                                       maxk=maxk, mask=mask, zmask=zmask, valid=valid)
   result[w] = _result
  end

 return, result
end
;==============================================================================
