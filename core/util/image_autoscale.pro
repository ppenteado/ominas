;===========================================================================
; image_autoscale
;
;===========================================================================
function image_autoscale, image, histmin=histmin, min=min, max=max

 if(NOT defined(max)) then max = 1.0
 if(NOT defined(min)) then min = 0.0
 if(NOT keyword__set(histmin)) then histmin = 10


 h = histogram(image)
 h[0] = (h[255] = 0)

 w = max(where(h GT histmin))

 im = bytscl(image, min=0, max=w*max)

 return, im
end
;===========================================================================
