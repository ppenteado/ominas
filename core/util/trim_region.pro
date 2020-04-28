;=============================================================================
;+
; NAME:
;       trim_region
;
;
; PURPOSE:
;       Trim points outside a defined region.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = trim_region(points, region, xsize, ysize)
;
;
; ARGUMENTS:
;  INPUT:
;       points:         An array of image points.
;
;       region:         Subscripts representing the region.
;
;        xsize:         Size of image in x
;
;        ysize:         Size of image in y
;
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Subscripts of points which are contained in the given region.
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
function trim_region, points, region, xsize, ysize

;xx= poly_interior(region, points)

 im = bytarr(xsize,ysize)
 p = round(points)
 sub = p[0,*] + xsize*p[1,*]
 im[sub] = 1
 im[region] = 0

 w = where(im[sub] EQ 0)

 return, w
end
;=============================================================================
