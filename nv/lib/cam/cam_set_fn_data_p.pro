;===========================================================================
;+
; NAME:
;	cam_set_fn_data_p
;
;
; PURPOSE:
;       For each given camera descriptor, sets the pointer to the
;       generic data intended to be used by the user-defined focal
;       <--> image transformation functions.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_set_fn_data_p, cd, data_p
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Array (nt) of CAMERA descriptors.
;
;	data_p:	Array (nt) of pointers to user-defined data.
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
; 	Written by:	Spitale
;	
;-
;===========================================================================
pro cam_set_fn_data_p, cxp, fn_data_p, noevent=noevent
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 cd.fn_data_p=fn_data_p

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0, noevent=noevent
end
;===========================================================================



