;=============================================================================
;+
; NAME:
;	pnt_set
;
;
; PURPOSE:
;	Replaces fields in a POINT object.  This is a convenient way of
;	setting multiple fields in one call, and only a single event is 
;	generated.
;
;
; CATEGORY:
;	NV/OBJ/PNT
;
;
; CALLING SEQUENCE:
;	pnt_set, ptd, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	ptd:		POINT object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	POINT fields to set.
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
;	pnt_set_*
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		12/2015
;	
;-
;=============================================================================
pro pnt_set, xd, noevent=noevent, $
@pnt__keywords.include
end_keywords

 _xd = cor_dereference(xd)
@pnt_set.include
 cor_rereference, xd, _xd

 nv_notify, xd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
