;=============================================================================
;+
; ps_nt:
;	ps_nt
;
;
; PURPOSE:
;	Returns the nt dimension of a points structure.
;
;
; CATEGORY:
;	nt/SYS/PS
;
;
; CALLING SEQUENCE:
;	nt = ps_nt(ps)
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
;	The nt dimensions of the points structure.
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
function ps_nt, psp, condition=condition, noevent=noevent, $
@ps_condition_keywords.include
end_keywords

 condition = ps_condition(condition=condition, $
@ps_condition_keywords.include 
end_keywords)

 nv_notify, psp, type = 1, noevent=noevent
 ps = nv_dereference(psp)

 if(NOT keyword_set(condition)) then return, ps.nt
 if(NOT ptr_valid(ps.flags_p)) then return, ps.nt

 nps = n_elements(ps)
 nt = lonarr(nps)

 for i=0, nps-1 do $
  begin
   ii = ps_apply_condition(ps[i], condition)
   if(ii[0] NE -1) then nt[i] = (size(ii, /dim))[0]
  end

 if(nps EQ 1) then nt = nt[0]
 return, nt
end
;===========================================================================



