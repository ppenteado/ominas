;=============================================================================
;+
; assoc_idp:
;	pnt_set_assoc_idp
;
;
; PURPOSE:
;	Replaces the assoc_idp field in a POINT object.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	pnt_set_assoc_idp, ps, assoc_idp
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		POINT object.
;
;	assoc_idp:	New assoc_idp.
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
;	pnt_assoc_idp
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
pro pnt_set_assoc_idp, ps, assoc_idp, noevent=noevent
@core.include
 _ps = cor_dereference(ps)

 _ps.assoc_idp = assoc_idp

 cor_rereference, ps, _ps
 nv_notify, ps, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
