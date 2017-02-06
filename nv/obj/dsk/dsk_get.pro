;=============================================================================
;+
; NAME:
;	dsk_get
;
;
; PURPOSE:
;	Returns the fields associated with a DISK object.  This is a 
;	convenient way of getting multiple fields in one call, and only a 
;	single event is generated.
;
;
; CATEGORY:
;	NV/OBJ/DSK
;
;
; CALLING SEQUENCE:
;	dsk_get, dkd, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	DISK object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	DISK object fields to set.
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
pro dsk_get, xd, noevent=noevent, $
@dsk__keywords.include
end_keywords

 nv_notify, xd, type = 1, noevent=noevent
 _xd = cor_dereference(xd)
_xd=xd

@sld_get.include

end
;===========================================================================
