;===========================================================================
;+
; NAME:
;	cam_oaxis
;
;
; PURPOSE:
;       Returns the 2-element array giving the image coordinates (in
;       pixels) corresponding to the camera optic axis for each given
;       camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	oaxis = cam_oaxis(cd)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	 Array (nt) of CAMERA descriptors.
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
; RETURN:
;	Oaxis array associated with each given camera descriptor.
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
function cam_oaxis, cxp
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 nv_notify, cdp, type = 1
 cd = nv_dereference(cdp)
 return, cd.oaxis
end
;===========================================================================



