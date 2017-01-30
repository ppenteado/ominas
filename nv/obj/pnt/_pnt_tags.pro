;=============================================================================
;+
; NAME:
;	_pnt_tags
;
;
; PURPOSE:
;	Returns the tags associated with a POINT structure.
;
;
; CATEGORY:
;	NV/OBJ/PNT
;
;
; CALLING SEQUENCE:
;	tags = _pnt_tags(_ptd)
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
;	The tags associated with the POINT structure.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pnt_set_tags
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2017
;	
;-
;=============================================================================
function _pnt_tags, _ptd
 if(NOT ptr_valid(_ptd.tags_p)) then return, 0
 return, *_ptd.tags_p
end
;===========================================================================



