;=============================================================================
;+
; NAME:
;       external_points
;
;
; PURPOSE:
;       Output subscripts of points outside the given bounds.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = external_points(points, x0, x1, y0, y1)
;
;
; ARGUMENTS:
;  INPUT:
;       points:         An array of image point.
;
;           x0:         Lower x bound.
;
;           x1:         Upper x bound.
;
;           y0:         Lower y bound.
;
;           y1:         Upper y bound.
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Subscripts of points in array that fall outside the rectangle
;       whose corners are (x0,y0) and (x1,y1).
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
function external_points, points, x0, x1, y0, y1

 xpoints = round(points[0,*])
 ypoints = round(points[1,*])

 sub = where((xpoints GT x1) OR (xpoints LT x0) OR (ypoints GT y1) OR (ypoints LT y0))

 return, sub
end
;===========================================================================
