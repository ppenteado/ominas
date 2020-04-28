;=============================================================================
;+
; NAME:
;       xbound
;
;
; PURPOSE:
;       Return y values of points bounding with x values
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = xbound(x, y, xbounds, bx=bx)
;
;
; ARGUMENTS:
;  INPUT:
;             x:        Array of x positions
;
;             y:        Array of y positions
;
;       xbounds:        Array containing the lower and upper x bound
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	NONE
;
;  OUTPUT:
;            bx:        x value of array of points within x bound
;
; RETURN:
;       Y values of array of points within x bound
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
function xbound, x, y, xbounds, bx=bx

 w = where(x GE xbounds[0] AND x LE xbounds[1])
 if(w[0] EQ -1) then return, 0

 bx=x[w]
 return, y[w]
end
;=============================================================================
