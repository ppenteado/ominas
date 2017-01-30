;=============================================================================
;+
; NAME:
;	_cor_name
;
;
; PURPOSE:
;	Returns the name for each given core structure.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	name = _cor_name(_crd)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	_crd:	 Any subclass of CORE.
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
;	Name associated with each given core structure.
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
function _cor_name, _crd
 return, _crd.name
end
;===========================================================================

