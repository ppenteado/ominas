;=============================================================================
;+
; NAME:
;	str_set
;
;
; PURPOSE:
;	Replaces fields in a STAR object.  This is a convenient way of
;	setting multiple fields in one call, and only a single event is 
;	generated.
;
;
; CATEGORY:
;	NV/OBJ/STR
;
;
; CALLING SEQUENCE:
;	str_set, sd, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	sd:		STAR object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	STAR fields to set.
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
;	str_set_*
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		2/2017
;	
;-
;=============================================================================
pro str_set, xd, noevent=noevent, $
@str__keywords.include
end_keywords

 _xd = cor_dereference(xd)
@str_set.include
 cor_rereference, xd, _xd

 nv_notify, xd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
