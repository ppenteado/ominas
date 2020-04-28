;=============================================================================
;+
; NAME:
;       image_interp_mean
;
;
; PURPOSE:
;       Extracts a region from an image using averaging interpolation.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = image_interp(image, grid_x, grid_y)
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
;  OUTPUT:
;       NONE
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
function image_interp_mean, image, grid_x, grid_y, k, width, mask=mask, zmask=zmask, valid=valid

 if(NOT keyword_set(width)) then width = 1.
 if(NOT keyword_set(k)) then k = 1.
 w = width/float(k)

 s = size(image)
 n = n_elements(grid_x)
 k2 = k*k

 ;----------------------------- 
 ; interpolation subscripts
 ;----------------------------- 
 subs = lonarr(n,k,k)

 k0 = -k/2

 interp = 0

 for i=0, k-1 do $
  for j=0, k-1 do $
   begin
    dx = float(k0 + i) * w
    dy = float(k0 + j) * w
    grid0_x = (grid_x + dx) < s[1]-1 > 0
    grid0_y = (grid_y + dy) < s[2]-1 > 0

    subs[*,i,j] = long(grid0_x) + s[1]*long(grid0_y)
   end

 ;----------------
 ; interpolation
 ;---------------- 
 subs = reform(subs, n, k2,/over)

 interp = (total(image[subs],2))/double(k2)

 return, interp
stop

 grid_x0 = long(grid_x)
 grid_x1 = grid_x0 + 1
 grid_y0 = long(grid_y)
 grid_y1 = grid_y0 + 1

 ;----------------------------- 
 ; interpolation subscripts
 ;----------------------------- 
 sub_x0y0 = grid_x0 + s[1]*grid_y0
 sub_x0y1 = grid_x0 + s[1]*grid_y1
 sub_x1y0 = grid_x1 + s[1]*grid_y0
 sub_x1y1 = grid_x1 + s[1]*grid_y1

 ;----------------
 ; interpolation
 ;---------------- 
 x_x0  = grid_x-grid_x0
 x_x1  = grid_x-grid_x1
 x0_x1 = grid_x0-grid_x1
 y_y0  = grid_y-grid_y0
 y_y1  = grid_y-grid_y1
 y0_y1 = grid_y0-grid_y1

 interp = ( x_x1*(y_y1*image[sub_x0y0]-y_y0*image[sub_x0y1]) + $
            x_x0*(y_y0*image[sub_x1y1]-y_y1*image[sub_x1y0]) ) / (x0_x1*y0_y1)

 return, interp
end
;===========================================================================
