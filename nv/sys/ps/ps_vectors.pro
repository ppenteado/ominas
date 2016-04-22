;=============================================================================
;+
; vectors:
;	ps_vectors
;
;
; PURPOSE:
;	Returns the vectors associated with a vectors structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	vectors = ps_vectors(ps)
;
;
; ARGUMENTS:
;  INPUT:
;	ps:	Points structure.  If multiple points structures are given, 
;		only pointers to the arrays are returned, and conditions are 
;		not applied.
;
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
;	The vectors associated with the vectors structure.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ps_set_vectors
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function ps_vectors, psp, condition=condition, noevent=noevent, $
@ps_condition_keywords.include
end_keywords

 condition = ps_condition(condition=condition, $
@ps_condition_keywords.include 
end_keywords)

 nv_notify, psp, type = 1, noevent=noevent
 ps = nv_dereference(psp)
 if(n_elements(ps) GT 1) then return, ps.vectors_p
 if(NOT ptr_valid(ps.vectors_p)) then return, 0

 if(NOT keyword_set(condition)) then return, *ps.vectors_p
 if(NOT ptr_valid(ps.flags_p)) then return, *ps.vectors_p

 ii = ps_apply_condition(ps, condition)
 if(ii[0] EQ -1) then return, 0
 vectors = reform(*ps.vectors_p, ps.nv*ps.nt,3)

 return, vectors[ii,*]
end
;===========================================================================



