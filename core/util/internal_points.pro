;=============================================================================
;+
; NAME:
;       internal_points
;
;
; PURPOSE:
;       Output subscripts of points inside the given bounds.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = internal_points(points, x0, x1, y0, y1)
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
;       Subscripts of points in array that fall inside the rectangle
;       whose corners are (x0,y0) and (x1,y1).
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
function internal_points, points, x0, x1, y0, y1

 xpoints = round(points[0,*])
 ypoints = round(points[1,*])

 sub = where(xpoints GE x0 AND xpoints LE x1 AND $
                                              ypoints GE y0 AND ypoints LE y1)

 return, sub
end
;===========================================================================
