;=============================================================================
;+
; desc:
;	pnt_set_desc
;
;
; PURPOSE:
;	Replaces the description field in a POINT object.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	pnt_set_desc, ptd, desc
;
;
; ARGUMENTS:
;  INPUT:
;	ptd:		POINT object.
;
;	desc:		New description.
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
;	pnt_desc
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
pro pnt_set_desc, ptd, desc, noevent=noevent
@core.include
 _ptd = cor_dereference(ptd)

 _ptd.desc = desc

 cor_rereference, ptd, _ptd
 nv_notify, ptd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
