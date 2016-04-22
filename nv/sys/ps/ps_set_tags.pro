;=============================================================================
;+
; points:
;	ps_set_tags
;
;
; PURPOSE:
;	Replaces the tags in a points struct.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	ps_set_tags, ps, tags
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points struct.
;
;	tags:		New tags array.
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
;	ps_tags
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
pro ps_set_tags, psp, tags, noevent=noevent
@nv.include
 ps = nv_dereference(psp)

 if(NOT keyword_set(ps.tags_p)) then ps.tags_p = nv_ptr_new(tags) $
 else *ps.tags_p = tags

 nv_rereference, psp, ps
 nv_notify, psp, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
