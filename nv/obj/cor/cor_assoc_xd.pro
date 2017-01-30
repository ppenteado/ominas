;=============================================================================
;+
; NAME:
;	cor_assoc_xd
;
;
; PURPOSE:
;	Returns the associated descriptor for a CORE object.
;
;
; CATEGORY:
;	NV/SYS/COR
;
;
; CALLING SEQUENCE:
;	assoc_xd = cor_assoc_xd(crd)
;
;
; ARGUMENTS:
;  INPUT:
;	crd:	CORE object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	noevent:	If set, no event is generated.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	The associated descriptor for the POINT object.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	cor_set_assoc_xd
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function cor_assoc_xd, crd, noevent=noevent
 nv_notify, crd, type = 1, noevent=noevent
 _crd = cor_dereference(crd)
 return, _cor_assoc_xd(_crd)
end
;===========================================================================



