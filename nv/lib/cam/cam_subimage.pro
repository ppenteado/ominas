;===========================================================================
;+
; NAME:
;	cam_subimage
;
;
; PURPOSE:
;       Produces a new camera descriptor corresponding to dividing the 
;	associated image as specified.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_subimage, cd, p0, nxy
;
;
; ARGUMENTS:
;  INPUT: 
;	cd:	Array (nt) of CAMERA descriptors to modify.
;
;	p0:	Starting corner of subimage.
;
;	size:	Array (2,1,nt) of image sizes.
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
; 	Written by:	Spitale, 4/2015
;	
;-
;===========================================================================
pro cam_subimage, cxp, p0, size, noevent=noevent
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 cd.size = size
 cd.oaxis = cd.oaxis - p0

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0, noevent=noevent
end
;===========================================================================

