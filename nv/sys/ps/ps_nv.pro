;=============================================================================
;+
; ps_nv:
;	ps_nv
;
;
; PURPOSE:
;	Returns the nv dimension of a points structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	nv = ps_nv(ps)
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
;	The nv dimensions of the points structure.
;
;
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function ps_nv, psp, condition=condition, noevent=noevent, $
@ps_condition_keywords.include
end_keywords

 condition = ps_condition(condition=condition, $
@ps_condition_keywords.include 
end_keywords)

 nv_notify, psp, type = 1, noevent=noevent
 ps = nv_dereference(psp)

 if(NOT keyword_set(condition)) then return, ps.nv
 if(NOT ptr_valid(ps.flags_p)) then return, ps.nv

 nps = n_elements(ps)
 nv = lonarr(nps)

 for i=0, nps-1 do $
  begin
   ii = ps_apply_condition(ps[i], condition)
   if(ii[0] NE -1) then nv[i] = (size(ii, /dim))[0]
  end

 if(nps EQ 1) then nv = nv[0]
 return, nv
end
;===========================================================================



