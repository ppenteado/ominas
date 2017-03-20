;=============================================================================
;+
; NAME:
;	plt_query
;
;
; PURPOSE:
;	Returns the fields associated with a PLANET object.  This is a 
;	convenient way of getting multiple fields in one call, and only a 
;	single event is generated.
;
;
; CATEGORY:
;	NV/OBJ/PLT
;
;
; CALLING SEQUENCE:
;	plt_query, pd, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	pd:	PLANET object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	PLANET object fields to set.
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
pro plt_query, xd, noevent=noevent, $
@plt__keywords.include
end_keywords

 nv_notify, xd, type = 1, noevent=noevent
 _xd = cor_dereference(xd)
_xd=xd

@plt_query.include

end
;===========================================================================
