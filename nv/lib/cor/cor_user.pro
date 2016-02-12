;=============================================================================
;+
; NAME:
;	cor_user
;
;
; PURPOSE:
;	Returns the username for each given core descriptor.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	user = cor_user(crx)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	crx:	 Any subclass of CORE.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Username associated with each given core descriptor.
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
;=============================================================================
function cor_user, crxp
@nv_lib.include
 crdp = class_extract(crxp, 'CORE')
 nv_notify, crdp, type = 1
 crd = nv_dereference(crdp)
 return, crd.user
end
;===========================================================================



