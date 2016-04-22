;=============================================================================
;+
; NAME:
;	ps_name
;
;
; PURPOSE:
;	Returns the name associated with a points structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	name = ps_name(ps)
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
;	The name associated with the points structure.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ps_set_name
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function ps_name, psp, noevent=noevent
 return, cor_name(psp, noevent=noevent)
end
;===========================================================================


;=============================================================================
function ___ps_name, psp, noevent=noevent
 nv_notify, psp, type = 1, noevent=noevent
 ps = nv_dereference(psp)
 return, ps.name
end
;===========================================================================



