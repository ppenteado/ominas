;=============================================================================
;	NOTE:	remove the second '+' on the next line for this header
;		to be recognized by extract_doc.
;++
; NAME:
;	xx
;
;
; PURPOSE:
;	xx
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = xx(xx, xx)
;	xx, xx, xx
;
;
; ARGUMENTS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; KEYWORDS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; ENVIRONMENT VARIABLES:
;	xx:	xx
;
;	xx:	xx
;
;
; RETURN:
;	xx
;
;
; COMMON BLOCKS:
;	xx:	xx
;
;	xx:	xx
;
;
; SIDE EFFECTS:
;	xx
;
;
; RESTRICTIONS:
;	xx
;
;
; PROCEDURE:
;	xx
;
;
; EXAMPLE:
;	xx
;
;
; STATUS:
;	xx
;
;
; SEE ALSO:
;	xx, xx, xx
;
;
; MODIFICATION HISTORY:
; 	Written by:	xx, xx/xx/xxxx
;	
;-
;=============================================================================
function warp_cp, image, p0, p1, size=size

 if(NOT keyword__set(size)) then size = (size(image))[1:2]

 triangulate, p0[0,*], p0[1,*], tri
 ntri = n_elements(tri)/3

 new_image = dblarr(size[0], size[1])

 ;--------------------------------------------------------
 ; map triangles one-by-one
 ;--------------------------------------------------------
 for i=0, ntri-1 do $
  begin
   ;----------------------------------------------------
   ; get output image subscripts in triangle i
   ;----------------------------------------------------
   w = polyfillv(p0[0,tri[*,i]], p0[1,tri[*,i]], size[0], size[1])

   ;----------------------------------------------------
   ; map back to input image
   ;----------------------------------------------------
   if(w[0] NE -1) then $
    begin
     x1 = p0[0,tri[0,i]] & y1 = p0[1,tri[0,i]]
     x2 = p0[0,tri[1,i]] & y2 = p0[1,tri[1,i]]
     x3 = p0[0,tri[2,i]] & y3 = p0[1,tri[2,i]]
     x1p = p1[0,tri[0,i]] & y1p = p1[1,tri[0,i]]
     x2p = p1[0,tri[1,i]] & y2p = p1[1,tri[1,i]]
     x3p = p1[0,tri[2,i]] & y3p = p1[1,tri[2,i]]

     x12 = x1 - x2 
     x23 = x2 - x3 
     y12 = y1 - y2 
     y23 = y2 - y3 
     x12p = x1p - x2p 
     x23p = x2p - x3p 
     y12p = y1p - y2p 
     y23p = y2p - y3p 
     xy12 = x1*y2 - x2*y1
     xy23 = x2*y3 - x3*y2
     xy12p = x1p*y2 - x2p*y1
     xy23p = x2p*y3 - x3p*y2
     yy12p = y1p*y2 - y2p*y1
     yy23p = y2p*y3 - y3p*y2

     c1 = x12*y23 - x23*y12
     c3 = y23*xy12 - y12*xy23

     a = (y23*x12p - y12*x23p) / c1
     b = (x23p*x12 - x12p*x23) / c1
     d = (xy12p*xy23 - xy23p*xy12) / c3

     e = (y23*y12p - y12*y23p) / c1
     f = (y23p*x12 - y12p*x23) / c1
     h = (yy12p*xy23 - yy23p*xy12) / c3

     x0 = double(w mod size[0])
     y0 = double(fix(w / size[0]))

     x1 = a*x0 + b*y0 + d
     y1 = e*x0 + f*y0 + h


     new_image[w] = image_interp(image, x1, y1)
    end
  end


 return, new_image
end
;=============================================================================
