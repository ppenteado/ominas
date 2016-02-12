;=============================================================================
;+
; NAME:
;       image_gradient
;
;
; PURPOSE:
;       To calculate the image gradiant.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = image_gradient(im)
;
;
; ARGUMENTS:
;  INPUT:
;       im:     An image.
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       The image gradiant.
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
function image_gradient, im
 return, $
   (shift(im, 1, 0)-shift(im, -1, 0))^2 + (shift(im, 0, 1)-shift(im, 0, -1))^2
end
;===========================================================================
