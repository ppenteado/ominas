;=============================================================================
;+
; NAME:
;	_cor_user
;
;
; PURPOSE:
;	Returns the username for each given core structure.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	user = _cor_user(_crx)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	_crx:	 Any subclass of CORE.
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
;	Username associated with each given core structure.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2017
;	
;-
;=============================================================================
function _cor_user, _crd
 return, _crd.user
end
;===========================================================================



