;=============================================================================
;+
; NAME:
;       activity
;
;
; PURPOSE:
;       Computes the activity in an image.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = activity(image)
;
;
; ARGUMENTS:
;  INPUT:
;       image:  Input image.
;
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;  INPUT: 
;	NONE
;
;
;  OUTPUT:
;       NONE
;
;
; RETURN:
;       The image activity at each pixel, computed as
;
;		activity = |dn_00 - dn_22| + |dn_20 - dn_02|,
;
;	where the pixel coordinates (i,j) are defined by
;
;			(0,0) (1,0) (2,0)
;			(0,1) (1,1) (2,1)
;			(0,2) (1,2) (2,2)
;
;	in a 3x3 box centered at a given image location.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale;  4/2002
;
;-
;=============================================================================
function activity, image

 k = dblarr(3,3)
 k[0] = 1d
 k[8] = -1d

 kk = dblarr(3,3)
 kk[2] = 1d
 kk[6] = -1d

 activity = abs(convol(image,k)) + abs(convol(image,kk)) + $
                     abs(convol(image,-k)) + abs(convol(image,-kk))

 k = dblarr(3,3)
 k[1] = 1d
 k[7] = -1d

 kk = dblarr(3,3)
 kk[3] = 1d
 kk[5] = -1d

 activity = activity + abs(convol(image,k)) + abs(convol(image,kk)) + $
                          abs(convol(image,-k)) + abs(convol(image,-kk))

 return, activity
end
;===========================================================================
