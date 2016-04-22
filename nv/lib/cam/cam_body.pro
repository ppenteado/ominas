;===========================================================================
;+
; NAME:
;	cam_body
;
;
; PURPOSE:
;	Returns the body descriptor for each given camera descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bd = cam_body(cd)
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
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Body descriptor associated with each given camera descriptor.
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
function cam_body, cxp, noevent=noevent
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 nv_notify, cdp, type = 1, noevent=noevent
 cd = nv_dereference(cdp)
 return, cd.bd
end
;===========================================================================



