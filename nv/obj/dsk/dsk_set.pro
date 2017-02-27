;=============================================================================
;+
; NAME:
;	dsk_set
;
;
; PURPOSE:
;	Replaces fields in a DISK object.  This is a convenient way of
;	setting multiple fields in one call, and only a single event is 
;	generated.
;
;
; CATEGORY:
;	NV/OBJ/DSK
;
;
; CALLING SEQUENCE:
;	dsk_set, dkd, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:		DISK object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	DISK fields to set.
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
;	dsk_set_*
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		2/2017
;	
;-
;=============================================================================
pro dsk_set, xd, noevent=noevent, $
@dsk__keywords.include
end_keywords

 _xd = cor_dereference(xd)
@sld_set.include
 cor_rereference, xd, _xd

 nv_notify, xd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
