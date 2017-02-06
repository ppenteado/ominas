;=============================================================================
;+
; NAME:
;	arr_set
;
;
; PURPOSE:
;	Replaces fields in a ARRAY object.  This is a convenient way of
;	setting multiple fields in one call, and only a single event is 
;	generated.
;
;
; CATEGORY:
;	NV/OBJ/ARR
;
;
; CALLING SEQUENCE:
;	arr_set, ard, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	ard:		ARRAY object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	ARRAY fields to set.
;
;	noevent:	If set, no event is generated.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	arr_set_*
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		2/2017
;	
;-
;=============================================================================
pro arr_set, xd, noevent=noevent, $
@arr__keywords.include
end_keywords

 _xd = cor_dereference(xd)
@cor_set.include
 cor_rereference, xd, _xd

 nv_notify, xd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
