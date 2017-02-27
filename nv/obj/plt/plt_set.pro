;=============================================================================
;+
; NAME:
;	plt_set
;
;
; PURPOSE:
;	Replaces fields in a PLANET object.  This is a convenient way of
;	setting multiple fields in one call, and only a single event is 
;	generated.
;
;
; CATEGORY:
;	NV/OBJ/PLT
;
;
; CALLING SEQUENCE:
;	plt_set, pd, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	pd:		PLANET object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	PLANET fields to set.
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
;	plt_set_*
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		2/2017
;	
;-
;=============================================================================
pro plt_set, xd, noevent=noevent, $
@plt__keywords.include
end_keywords

 _xd = cor_dereference(xd)
@PLT_set.include
 cor_rereference, xd, _xd

 nv_notify, xd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
