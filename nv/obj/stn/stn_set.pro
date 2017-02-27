;=============================================================================
;+
; NAME:
;	stn_set
;
;
; PURPOSE:
;	Replaces fields in a STATION object.  This is a convenient way of
;	setting multiple fields in one call, and only a single event is 
;	generated.
;
;
; CATEGORY:
;	NV/OBJ/CAM
;
;
; CALLING SEQUENCE:
;	stn_set, std, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	std:		STATION object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	STATION fields to set.
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
;	stn_set_*
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		2/2017
;	
;-
;=============================================================================
pro stn_set, xd, noevent=noevent, $
@stn__keywords.include
end_keywords

 _xd = cor_dereference(xd)
@bod_set.include
 cor_rereference, xd, _xd

 nv_notify, xd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
