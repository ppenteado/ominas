;=============================================================================
;+
; NAME:
;       in_image
;
;
; PURPOSE:
;	Determines which input points lie within an image described by the
;	given camera descriptor.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       sub = in_image(cd, p)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Camera descriptor.
;
;	p:	Array (2,nv) of image points.
;
;  OUTPUT:  NONE
;
;
; KEYOWRDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Subscripts of points that lie in the image.  -1 if there are none.
;
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function in_image, cd, _image_pts, $
           xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, slop=slop, corners=corners

 if(NOT keyword_set(_image_pts)) then return, [-1]
 image_pts = round(_image_pts)

 if(keyword_set(corners)) then $
  begin
   xmin = min(corners[0,*])
   xmax = max(corners[0,*])
   ymin = min(corners[1,*])
   ymax = max(corners[1,*])
  end

 if(NOT defined(slop)) then slop = 100

 if(NOT defined(xmin)) then xmin = -slop 
 if(NOT defined(xmax)) then xmax = (image_size(cd))[0] + slop
 if(NOT defined(ymin)) then ymin = -slop 
 if(NOT defined(ymax)) then ymax = (image_size(cd))[1] + slop

 w = where( (image_pts[0,*] GE xmin) AND (image_pts[0,*] LE xmax) AND $
             (image_pts[1,*] GE ymin) AND (image_pts[1,*] LE ymax) )

 return, w
end
;===========================================================================



