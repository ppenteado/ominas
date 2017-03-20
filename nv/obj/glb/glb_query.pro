;=============================================================================
;+
; NAME:
;	glb_query
;
;
; PURPOSE:
;	Returns the fields associated with a GLOBE object.  This is a 
;	convenient way of getting multiple fields in one call, and only a 
;	single event is generated.
;
;
; CATEGORY:
;	NV/OBJ/GLB
;
;
; CALLING SEQUENCE:
;	glb_query, gbd, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	gbd:	GLOBE object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	GLOBE object fields to set.
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
pro glb_query, xd, noevent=noevent, $
@glb__keywords.include
end_keywords

 nv_notify, xd, type = 1, noevent=noevent
 _xd = cor_dereference(xd)
_xd=xd

@glb_query.include

end
;===========================================================================
