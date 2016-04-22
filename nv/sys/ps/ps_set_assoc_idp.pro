;=============================================================================
;+
; assoc_idp:
;	ps_set_assoc_idp
;
;
; PURPOSE:
;	Replaces the assoc_idp field in a points struct.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	ps_set_assoc_idp, ps, assoc_idp
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points struct.
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
;	ps_assoc_idp
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
pro ps_set_assoc_idp, psp, assoc_idp, noevent=noevent
@nv.include
 ps = nv_dereference(psp)

 ps.assoc_idp = assoc_idp

 nv_rereference, psp, ps
 nv_notify, psp, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
