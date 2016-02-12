;===========================================================================
;+
; NAME:
;	cam_set_body
;
;
; PURPOSE:
;	Replaces the body descriptor in each given camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_set_body, cd, bd
;
;
; ARGUMENTS:
;  INPUT: 
;	cd:	 Array (nt) of CAMERA descriptors.
;
;	bd:	 Array (nt) of BODY descriptors.
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
; 	Written by:	Spitale, 1/1998
;	
;-
;===========================================================================
pro cam_set_body, cxp, bdp
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 cd.bd=bdp

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0
end
;===========================================================================



