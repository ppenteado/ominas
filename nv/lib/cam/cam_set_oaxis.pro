;===========================================================================
;+
; NAME:
;	cam_set_oaxis
;
;
; PURPOSE:
;       Replaces the oaxis array for each given camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_set_oaxis, cd, oaxis
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Array (nt) of CAMERA descriptors.
;
;       oaxis:	Array (2,nt) of new oaxis values.
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
pro cam_set_oaxis, cxp, oaxis
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 cd.oaxis=oaxis

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0
end
;===========================================================================



