;=============================================================================
;+
; NAME:
;	arr_get
;
;
; PURPOSE:
;	Returns the fields associated with a ARRAY object.  This is a 
;	convenient way of getting multiple fields in one call, and only a 
;	single event is generated.
;
;
; CATEGORY:
;	NV/OBJ/ARR
;
;
; CALLING SEQUENCE:
;	arr_get, ard, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	ard:	ARRAY object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	ARRAY object fields to set.
;
;	noevent:	If set, no event is generated.
;
;  OUTPUT: NONE
;
;
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2017
;	
;-
;=============================================================================
pro arr_get, xd, noevent=noevent, $
@arr__keywords.include
end_keywords

 nv_notify, xd, type = 1, noevent=noevent
 _xd = cor_dereference(xd)
_xd=xd

@cor_get.include

end
;===========================================================================
