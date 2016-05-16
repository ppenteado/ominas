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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro cam_set_fn_data_p, cd, fn_data_p, noevent=noevent
@core.include

 _cd = cor_dereference(cd)

 _cd.fn_data_p=fn_data_p

 cor_rereference, cd, _cd
 nv_notify, cd, type = 0, noevent=noevent
end
;===========================================================================



