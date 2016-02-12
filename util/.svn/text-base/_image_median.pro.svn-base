;=============================================================================
;+
; NAME:
;	image_median
;
;
; PURPOSE:
;	Produces an image in which each pixel is the median of the corresponding
;	pixels in the input images.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = image_median(images)
;
;
; ARGUMENTS:
;  INPUT:
;	images:	Array (xsize, ysize, n) containing the n input images.
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
;	NONE
;
;
; RETURN:
;	Array (xsize, ysize) with the output image.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2002
;	
;-
;=============================================================================
function _image_median, images

 
 s = size(images, /dim)
 xsize = s[0]
 ysize = s[1]
 n = s[2]
 type = size(images, /type)
 result = make_array(xsize, ysize, type=type, /nozero)

 ;--------------------------------------------------
 ; first guess: average
 ;--------------------------------------------------
 result = total(images,3)/n
stop
 


 return, result
end
;=============================================================================
