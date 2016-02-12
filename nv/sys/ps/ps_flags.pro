;=============================================================================
;+
; flags:
;	ps_flags
;
;
; PURPOSE:
;	Returns the flags associated with a points structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	flags = ps_flags(ps)
;
;
; ARGUMENTS:
;  INPUT:
;	ps:	Points structure.  If multiple points structures are given, 
;		only pointers to the arrays are returned, and conditions are 
;		not applied.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	condition:	Structure specifing a mask and a condition with which to
;			match flag values.  The structure must contain the fields
;			MASK and STATE.  MASK is a bitmask to test against
;			the flags field of the points structure, and STATE
;			is either PS_TRUE and PS_FALSE.  Note that in this case, 
;			the values will be returned as a list, with no separation 
;			into nv and nt dimensions.
;
;	<condition>:	All of the predefined conditions (e.g. /visible) are 
;			accepted; see ps_condition_keywords.include.
;
;	noevent:	If set, no event is generated.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	The flags associated with the points structure.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ps_set_flags
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function ps_flags, psp, condition=condition, noevent=noevent, $
@ps_condition_keywords.include
end_keywords

 condition = ps_condition(condition=condition, $
@ps_condition_keywords.include 
end_keywords)

 if(NOT keyword_set(noevent)) then nv_notify, psp, type = 1
 ps = nv_dereference(psp)
 if(n_elements(ps) GT 1) then return, ps.flags_p
 if(NOT ptr_valid(ps.flags_p)) then return, 0

 if(NOT keyword_set(condition)) then return, *ps.flags_p
 if(NOT ptr_valid(ps.flags_p)) then return, 0

 ii = ps_apply_condition(ps, condition)
 if(ii[0] EQ -1) then return, 0
 flags = reform(*ps.flags_p, ps.nv*ps.nt)

 return, flags[ii]
end
;===========================================================================



