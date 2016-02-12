;=============================================================================
;+
; NAME:
;	ps_set_name
;
;
; PURPOSE:
;	Replaces the name field in a points struct.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	ps_set_name, ps, name
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points struct.
;
;	name:		New name.
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
;	ps_name
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
pro ps_set_name, psp, name, noevent=noevent
@nv.include
 ps = nv_dereference(psp)

 ps.name = name

 nv_rereference, psp, ps
 if(NOT keyword_set(noevent)) then $
  begin
   nv_notify, psp, type = 0
   nv_notify, /flush
  end
end
;===========================================================================
