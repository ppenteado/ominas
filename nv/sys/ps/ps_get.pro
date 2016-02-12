;=============================================================================
;+
; points:
;	ps_get
;
;
; PURPOSE:
;	Returns the fields associated with a points structure.  This is a 
;	convenient way of getting multiple fields in one call, and only a 
;	single event is generated.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	ps_get, ps, <keywords>=<values>
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
;	<keywords>:	Points structure fields to set.
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
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 12/2015
;	
;-
;=============================================================================
pro ps_get, ps, condition=condition, nv=nv, nt=nt, $
              points=points, vectors=vectors, flags=flags, $
              name=name, desc=desc, input=input, data=data, tags=tags, $
              udata=udata, uname=uname, assoc_idp=assoc_idp, noevent=noevent, $
@ps_condition_keywords.include
end_keywords

 condition = ps_condition(condition=condition, $
@ps_condition_keywords.include 
end_keywords)

 if(NOT keyword_set(noevent)) then nv_notify, ps, type = 1

 if(arg_present(points)) then points = ps_points(ps, condition=condition, /noevent)
 if(arg_present(vectors)) then vectors = ps_vectors(ps, condition=condition, /noevent)
 if(arg_present(flags)) then flags = ps_flags(ps, /noevent, condition=condition)
 if(arg_present(name)) then name = ps_name(ps, /noevent)
 if(arg_present(desc)) then desc = ps_desc(ps, /noevent)
 if(arg_present(input)) then input = ps_input(ps, /noevent)
 if(arg_present(data)) then data = ps_data(ps, condition=condition, /noevent)
 if(arg_present(tags)) then tags = ps_tags(ps, /noevent)
 if(arg_present(assoc_idp)) then assoc_idp = ps_assoc_idp(ps, /noevent)
 if(arg_present(udata)) then udata = ps_udata(ps, uname, /noevent)
 if(arg_present(nv)) then nv = ps_nv(ps, /noevent, condition=condition)
 if(arg_present(nt)) then nt = ps_nt(ps, /noevent, condition=condition)

end
;===========================================================================



