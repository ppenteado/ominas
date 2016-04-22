;===========================================================================
;+
; NAME:
;	cam_fn_data_p
;
;
; PURPOSE:
;	For each given camera descriptor, returns the pointer to the
;       generic data intended to be used by the user-defined focal
;       <--> image transformation functions.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	data_p = cam_fn_data_p(cd)
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
;       Pointer to user defined data associated with each given camera
;       descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;===========================================================================
function cam_fn_data_p, cxp, noevent=noevent
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 nv_notify, cdp, type = 1, noevent=noevent
 cd = nv_dereference(cdp)
 return, cd.fn_data_p
end
;===========================================================================



