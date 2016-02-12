;===========================================================================
;+
; NAME:
;	cam_rescale
;
;
; PURPOSE:
;       Produces a new camera descriptor describing an image of the same 
;	angluar dimensions, but with a new scale, specified by camera scale.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_rescale, cd, scale
;
;
; ARGUMENTS:
;  INPUT: 
;	cd:	Array (nt) of CAMERA descriptors to modify.
;
;	scale:	Array (2,1,nt) of new camera scales.
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
pro cam_rescale, cxp, scale
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 ratio = cd.scale/scale

 cd.size = cd.size*ratio
 cd.oaxis = cd.oaxis*ratio
 cd.scale = scale

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0
end
;===========================================================================

