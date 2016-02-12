;=============================================================================
;+
; input:
;	ps_input
;
;
; PURPOSE:
;	Returns the input description associated with a points structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	input = ps_input(ps)
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
;	The input description associated with the points structure.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ps_set_input
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function ps_input, psp, noevent=noevent
 if(NOT keyword_set(noevent)) then nv_notify, psp, type = 1
 ps = nv_dereference(psp)
 return, ps.input
end
;===========================================================================



