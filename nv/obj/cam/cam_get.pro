;=============================================================================
;+
; NAME:
;	cam_get
;
;
; PURPOSE:
;	Returns the fields associated with a CAMERA object.  This is a 
;	convenient way of getting multiple fields in one call, and only a 
;	single event is generated.
;
;
; CATEGORY:
;	NV/OBJ/CAM
;
;
; CALLING SEQUENCE:
;	cam_get, cd, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	CAMERA object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	CAMERA object fields to set.
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
pro cam_get, xd, noevent=noevent, $
@cam__keywords.include
end_keywords

 nv_notify, xd, type = 1, noevent=noevent
 _xd = cor_dereference(xd)
_xd=xd

@bod_get.include

end
;===========================================================================
