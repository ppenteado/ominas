;===========================================================================
;+
; NAME:
;	cam_rebin
;
;
; PURPOSE:
;       Modifies the camera parameters to reflect a re-binning of the pixels.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_rebin, cd, bin
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	    Array (nt) of CAMERA descriptors.
;
;       bin:        Binning factor, can be non-integer.
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
; 	Written by:	Spitale, 1/2015
;	
;-
;===========================================================================
pro cam_rebin, cxp, bin
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 cd.size = cd.size/bin
 cd.oaxis = cd.oaxis/bin
 cd.scale = cd.scale*bin

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0
end
;===========================================================================



