;=============================================================================
;+
; desc:
;	ps_desc
;
;
; PURPOSE:
;	Returns the description associated with a points structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	desc = ps_desc(ps)
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
;	The description associated with the points structure.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ps_set_desc
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function ps_desc, psp, noevent=noevent
 if(NOT keyword_set(noevent)) then nv_notify, psp, type = 1
 ps = nv_dereference(psp)
 return, ps.desc
end
;===========================================================================



