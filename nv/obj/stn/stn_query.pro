;=============================================================================
;+
; NAME:
;	stn_query
;
;
; PURPOSE:
;	Returns the fields associated with a STATION object.  This is a 
;	convenient way of getting multiple fields in one call, and only a 
;	single event is generated.
;
;
; CATEGORY:
;	NV/OBJ/CAM
;
;
; CALLING SEQUENCE:
;	stn_query, std, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	std:	STATION object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	STATION object fields to set.
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
pro stn_query, xd, noevent=noevent, $
@stn__keywords.include
end_keywords

 nv_notify, xd, type = 1, noevent=noevent
 _xd = cor_dereference(xd)
_xd=xd

@stn_query.include

end
;===========================================================================
