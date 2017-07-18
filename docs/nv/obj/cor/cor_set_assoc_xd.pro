;=============================================================================
;+
; NAME:
;	cor_set_assoc_xd
;
;
; PURPOSE:
;	Replaces the assoc_xd field in a CORE object.
;
;
; CATEGORY:
;	NV/SYS/COR
;
;
; CALLING SEQUENCE:
;	cor_set_assoc_xd, crd, assoc_xd
;
;
; ARGUMENTS:
;  INPUT:
;	crd:		CORE object.
;
;	assoc_xd:	New assoc_xd.
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
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	cor_assoc_xd
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
pro cor_set_assoc_xd, crd, assoc_xd, noevent=noevent
@core.include
 _crd = cor_dereference(crd)

 _crd.__protect__assoc_xd = assoc_xd

 cor_rereference, crd, _crd
 nv_notify, crd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
