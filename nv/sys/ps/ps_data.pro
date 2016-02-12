;=============================================================================
;+
; data:
;	ps_data
;
;
; PURPOSE:
;	Returns the point-by-point data associated with a points structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	data = ps_data(ps)
;
;
; ARGUMENTS:
;  INPUT:
;	ps:	Points structure.  If multiple points structures are given, 
;		only pointers to the arrays are returned, and conditions and
;		tags are not applied.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	tags:	If given, data arrays are returned only for these tags,
;		and are arranged in this order.
;
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
;	The point-by-point data associated with the points structure.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ps_set_data
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function ps_data, psp, tags=select_tags, condition=condition, noevent=noevent, $
@ps_condition_keywords.include
end_keywords

 condition = ps_condition(condition=condition, $
@ps_condition_keywords.include 
end_keywords)

 if(NOT keyword_set(noevent)) then nv_notify, psp, type = 1
 ps = nv_dereference(psp)
 if(n_elements(ps) GT 1) then return, ps.data_p
 if(NOT ptr_valid(ps.data_p)) then return, 0

 data = *ps.data_p

 if(keyword_set(select_tags)) then $
  begin 
   if(NOT ptr_valid(ps.tags_p)) then return, 0
   tags = *ps.tags_p
   ntags = n_elements(tags)
   w = nwhere(tags, select_tags)
   if(w[0] EQ -1) then return, 0
   data = data[w,*,*]
  end

 if(NOT keyword_set(condition)) then return, data
 if(NOT ptr_valid(ps.flags_p)) then return, data

 ntags = (size(data, /dim))[0]

 ii = ps_apply_condition(ps, condition)
 if(ii[0] EQ -1) then return, 0
 data = reform(data, ntags,ps.nv*ps.nt, /over)

 return, data[*,ii]
end
;===========================================================================



;=============================================================================
function _ps_data, psp, tags=select_tags, condition=condition, noevent=noevent, $
@ps_condition_keywords.include
end_keywords

 condition = ps_condition(condition=condition, $
@ps_condition_keywords.include 
end_keywords)

 if(NOT keyword_set(noevent)) then nv_notify, psp, type = 1
 ps = nv_dereference(psp)
 if(NOT ptr_valid(ps.data_p)) then return, 0

 if(NOT keyword_set(tags)) then return, *ps.data_p
 if(NOT ptr_valid(ps.tags_p)) then return, 0

 tags = *ps.tags_p
 ntags = n_elements(tags)
 w = nwhere(tags, select_tags)
 if(w[0] EQ -1) then return, 0

 data  = (*ps.data_p)[w,*,*]

 if(NOT keyword_set(condition)) then return, data
 if(NOT ptr_valid(ps.flags_p)) then return, data

 ii = ps_apply_condition(ps, select)
 if(ii[0] EQ -1) then return, 0
 data = reform(data, ntags,ps.nv*ps.nt, /over)

 return, data[*,ii]
end
;===========================================================================



