;=============================================================================
;+
; NAME:
;	bod_query
;
;
; PURPOSE:
;	Returns the fields associated with a BODY object.  This is a 
;	convenient way of getting multiple fields in one call, and only a 
;	single event is generated.
;
;
; CATEGORY:
;	NV/OBJ/BOD
;
;
; CALLING SEQUENCE:
;	bod_query, bd, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	bd:	BODY object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	BODY object fields to set.
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
pro bod_query, xd, noevent=noevent, $
@bod__keywords.include
end_keywords

 nv_notify, xd, type = 1, noevent=noevent
 _xd = cor_dereference(xd)
_xd=xd

@bod_query.include

end
;===========================================================================
