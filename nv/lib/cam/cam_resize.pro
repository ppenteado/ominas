;===========================================================================
;+
; NAME:
;	cam_resize
;
;
; PURPOSE:
;       Produces a new camera descriptor describing an image of the same 
;	angluar dimensions, but with a new scale, specified by image size.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_resize, cd, size
;
;
; ARGUMENTS:
;  INPUT: 
;	cd:	Array (nt) of CAMERA descriptors to modify.
;
;	size:	Array (2,1,nt) of new image sizes.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;===========================================================================
pro cam_resize, cxp, size, noevent=noevent
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 ratio = cd.size/size

 cd.size = size
 cd.oaxis = cd.oaxis/ratio
 cd.scale = cd.scale*ratio

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0, noevent=noevent
end
;===========================================================================
nx1*scale1 = nx*scale

nx1 = nx*scale/scale1
scale1 = scale*nx/nx1
