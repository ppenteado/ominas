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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function cor_user, crd, noevent=noevent
@core.include
 nv_notify, crd, type = 1, noevent=noevent
 _crd = cor_dereference(crd)
; return, _crd.user
 return, _cor_user(_crd)
end
;===========================================================================



