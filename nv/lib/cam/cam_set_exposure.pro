;===========================================================================
;+
; NAME:
;	cam_set_exposure
;
;
; PURPOSE:
;       Replaces the exposure duration for each given camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_set_exposure,cd,exposure
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	     Array (nt) of CAMERA descriptors.
;
;       exposure:    Array (nt) of new exposure values.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
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
pro cam_set_exposure, cxp, exposure
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 cd.exposure=exposure

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0
end
;===========================================================================



