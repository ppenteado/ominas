;=============================================================================
;+
; desc:
;	ps_set_desc
;
;
; PURPOSE:
;	Replaces the description field in a points struct.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	ps_set_desc, ps, desc
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points struct.
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
;	ps_desc
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
pro ps_set_desc, psp, desc, noevent=noevent
@nv.include
 ps = nv_dereference(psp)

 ps.desc = desc

 nv_rereference, psp, ps
 if(NOT keyword_set(noevent)) then $
  begin
   nv_notify, psp, type = 0
   nv_notify, /flush
  end
end
;===========================================================================
