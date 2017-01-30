;=============================================================================
;+
; NAME:
;	pnt_nv
;
;
; PURPOSE:
;	Returns the nv dimension of a POINT object.
;
;
; CATEGORY:
;	NV/OBJ/PNT
;
;
; CALLING SEQUENCE:
;	nv = pnt_nv(ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	ptd:	POINT object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	noevent:	If set, no event is generated.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	The nv dimensions of the POINT object.
;
;
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function pnt_nv, ptd, condition=condition, noevent=noevent, $
@pnt_condition_keywords.include
end_keywords

 condition = pnt_condition(condition=condition, $
@pnt_condition_keywords.include 
end_keywords)

 nv_notify, ptd, type = 1, noevent=noevent
 _ptd = cor_dereference(ptd)

 return, _pnt_nv(_ptd, condition=condition)
end
;===========================================================================



