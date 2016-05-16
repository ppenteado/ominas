;=============================================================================
;+
; assoc_idp:
;	pnt_assoc_idp
;
;
; PURPOSE:
;	Returns the associated IDP for a POINT object.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	assoc_idp = pnt_assoc_idp(ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	ptd:	Points object.
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
;	The associated IDP for the POINT object.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pnt_set_assoc_idp
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function pnt_assoc_idp, ptd, noevent=noevent
 nv_notify, ptd, type = 1, noevent=noevent
 _ptd = cor_dereference(ptd)
 return, _ptd.assoc_idp
end
;===========================================================================



