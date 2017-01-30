;=============================================================================
;+
; NAME:
;	pnt_nt
;
;
; PURPOSE:
;	Returns the nt dimension of a POINT object.
;
;
; CATEGORY:
;	nt/SYS/PS
;
;
; CALLING SEQUENCE:
;	nt = pnt_nt(ptd)
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
;	The nt dimensions of the POINT object.
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
function pnt_nt, ptd, condition=condition, noevent=noevent, $
@pnt_condition_keywords.include
end_keywords

 condition = pnt_condition(condition=condition, $
@pnt_condition_keywords.include 
end_keywords)

 nv_notify, ptd, type = 1, noevent=noevent
 _ptd = cor_dereference(ptd)

 return, _pnt_nt(_ptd, condition=condition)
end
;===========================================================================



