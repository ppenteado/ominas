;=============================================================================
;+
; NAME:
;	_pnt_input
;
;
; PURPOSE:
;	Returns the input description associated with a POINT structure.
;
;
; CATEGORY:
;	NV/OBJ/PNT
;
;
; CALLING SEQUENCE:
;	input = _pnt_input(_ptd)
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
;	The input description associated with the POINT structure.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pnt_set_input
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2017
;	
;-
;=============================================================================
function _pnt_input, _ptd
 return, _ptd.input
end
;===========================================================================



