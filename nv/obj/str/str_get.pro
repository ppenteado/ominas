;=============================================================================
;+
; NAME:
;	str_get
;
;
; PURPOSE:
;	Returns the fields associated with a STAR object.  This is a 
;	convenient way of getting multiple fields in one call, and only a 
;	single event is generated.
;
;
; CATEGORY:
;	NV/OBJ/STR
;
;
; CALLING SEQUENCE:
;	str_get, sd, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	sd:	STAR object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	STAR object fields to set.
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
pro str_get, xd, noevent=noevent, $
@str__keywords.include
end_keywords

 nv_notify, xd, type = 1, noevent=noevent
 _xd = cor_dereference(xd)
_xd=xd

@str_get.include

end
;===========================================================================