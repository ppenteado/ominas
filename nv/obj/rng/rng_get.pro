;=============================================================================
;+
; NAME:
;	rng_get
;
;
; PURPOSE:
;	Returns the fields associated with a RING object.  This is a 
;	convenient way of getting multiple fields in one call, and only a 
;	single event is generated.
;
;
; CATEGORY:
;	NV/OBJ/RNG
;
;
; CALLING SEQUENCE:
;	rng_get, rd, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	rd:	RING object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	RING object fields to set.
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
pro rng_get, xd, noevent=noevent, $
@rng__keywords.include
end_keywords

 nv_notify, xd, type = 1, noevent=noevent
 _xd = cor_dereference(xd)
_xd=xd

@dsk_get.include

end
;===========================================================================
