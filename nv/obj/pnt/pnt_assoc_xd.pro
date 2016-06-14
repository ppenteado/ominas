;=============================================================================
;+
; assoc_xd:
;	pnt_assoc_xd
;
;
; PURPOSE:
;	Returns the associated descriptor for a POINT object.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	assoc_xd = pnt_assoc_xd(ptd)
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
;	The associated descriptor for the POINT object.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pnt_set_assoc_xd
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function pnt_assoc_xd, ptd, noevent=noevent
 nv_notify, ptd, type = 1, noevent=noevent
 _ptd = cor_dereference(ptd)
 return, _ptd.assoc_xd
end
;===========================================================================



