;=============================================================================
;+
; NAME:
;	map_query
;
;
; PURPOSE:
;	Returns the fields associated with a MAP object.  This is a 
;	convenient way of getting multiple fields in one call, and only a 
;	single event is generated.
;
;
; CATEGORY:
;	NV/OBJ/MAP
;
;
; CALLING SEQUENCE:
;	map_query, md, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	md:	MAP object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	MAP object fields to set.
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
pro map_query, xd, noevent=noevent, $
@map__keywords.include
end_keywords

 nv_notify, xd, type = 1, noevent=noevent
 _xd = cor_dereference(xd)
_xd=xd

@cor_get.include

end
;===========================================================================
