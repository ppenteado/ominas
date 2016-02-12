;=============================================================================
;+
; input:
;	ps_set_input
;
;
; PURPOSE:
;	Replaces the input description field in a points struct.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	ps_set_input, ps, input
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points struct.
;
;	input:		New input description.
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
;	ps_input
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
pro ps_set_input, psp, input, noevent=noevent
@nv.include
 ps = nv_dereference(psp)

 ps.input = input

 nv_rereference, psp, ps
 if(NOT keyword_set(noevent)) then $
  begin
   nv_notify, psp, type = 0
   nv_notify, /flush
  end
end
;===========================================================================
