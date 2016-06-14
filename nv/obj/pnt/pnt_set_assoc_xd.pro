;=============================================================================
;+
; assoc_xd:
;	pnt_set_assoc_xd
;
;
; PURPOSE:
;	Replaces the assoc_xd field in a POINT object.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	pnt_set_assoc_xd, ps, assoc_xd
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		POINT object.
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
;	pnt_assoc_xd
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
pro pnt_set_assoc_xd, ps, assoc_xd, noevent=noevent
@core.include
 _ps = cor_dereference(ps)

 _ps.assoc_xd = assoc_xd

 cor_rereference, ps, _ps
 nv_notify, ps, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
