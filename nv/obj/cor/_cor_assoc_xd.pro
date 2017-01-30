;=============================================================================
;+
; NAME:
;	_cor_assoc_xd
;
;
; PURPOSE:
;	Returns the associated descriptor for a CORE structure.
;
;
; CATEGORY:
;	NV/SYS/COR
;
;
; CALLING SEQUENCE:
;	assoc_xd = _cor_assoc_xd(_crd)
;
;
; ARGUMENTS:
;  INPUT:
;	_crd:	CORE structure.
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
;	The associated descriptor for the CORE object.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	_cor_set_assoc_xd
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2017
;	
;-
;=============================================================================
function _cor_assoc_xd, _crd
 return, _crd.__protect__assoc_xd
end
;===========================================================================



