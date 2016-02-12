;=============================================================================
;+
; assoc_idp:
;	ps_assoc_idp
;
;
; PURPOSE:
;	Returns the associated IDP for a points structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	assoc_idp = ps_assoc_idp(ps)
;
;
; ARGUMENTS:
;  INPUT:
;	ps:	Points structure.
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
;	The associated IDP for the points structure.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ps_set_assoc_idp
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function ps_assoc_idp, psp, noevent=noevent
 if(NOT keyword_set(noevent)) then nv_notify, psp, type = 1
 ps = nv_dereference(psp)
 return, ps.assoc_idp
end
;===========================================================================



