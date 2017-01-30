;=============================================================================
;+
; NAME:
;	_pnt_desc
;
;
; PURPOSE:
;	Returns the description associated with a POINT structure.
;
;
; CATEGORY:
;	NV/OBJ/PNT
;
;
; CALLING SEQUENCE:
;	desc = _pnt_desc(_ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	_ptd:	POINT structure.
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
;	The description associated with the POINT structure.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	_pnt_set_desc
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2017
;	
;-
;=============================================================================
function _pnt_desc, _ptd
 return, _ptd.desc
end
;===========================================================================



