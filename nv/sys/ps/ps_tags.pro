;=============================================================================
;+
; tags:
;	ps_tags
;
;
; PURPOSE:
;	Returns the tags associated with a points structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	tags = ps_tags(ps)
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
;	The tags associated with the points structure.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ps_set_tags
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function ps_tags, psp, noevent=noevent
 nv_notify, psp, type = 1, noevent=noevent
 ps = nv_dereference(psp)
 if(NOT ptr_valid(ps.tags_p)) then return, 0
 return, *ps.tags_p
end
;===========================================================================



