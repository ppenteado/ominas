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
function image_median, _images

 
 s = size(_images)
 xsize = s[1]
 ysize = s[2]
 n = s[3]
 type = s[s[0]+1]
 result = make_array(xsize, ysize, type=type, /nozero)


 ;------------------------------------------------------------------
 ; find medians by successively eliminating min and max values
 ;------------------------------------------------------------------
 images = transpose(_images)	; transpose makes nmin, nmax more efficient
 ss = (lindgen(n, ysize,xsize))[0,*,*]

 nn = 0
 for i=0, n/2 do $
  begin
   ;--------------------------------------
   ; replace all mins with maxs
   ;--------------------------------------
   for j=0, nn do $
    begin
     maxs = nmax(images, 0)
;     mins = nmin(images, 0, sub=sub)
     mins = nmin(images, 0, sub=sub, /pos)
     w = ss + sub
     images[w] = maxs
    end
   nn = nn + 1

   ;--------------------------------------
   ; replace all maxs with mins
   ;--------------------------------------
   for j=0, nn do $
    begin
;     mins = nmin(images, 0)
     mins = nmin(images, 0, /pos)
     maxs = nmax(images, 0, sub=sub)
     w = ss + sub
     images[w] = mins
    end
   nn = nn + 1
  end


 result = transpose(images[0,*,*])

 return, result
end
;=============================================================================
