;===========================================================================
;+
; NAME:
;	cam_set_size
;
;
; PURPOSE:
;       Replaces the size array for each given camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_set_size, cd, size
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	     Array (nt) of CAMERA descriptors.
;
;       size:        Array (2,nt) of new size values.
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
pro cam_set_size, cxp, size, noevent=noevent
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cd = nv_dereference(cdp)

 cd.size=size

 nv_rereference, cdp, cd
 nv_notify, cdp, type = 0, noevent=noevent
end
;===========================================================================



