;=============================================================================
;+
; points:
;	pnt_get
;
;
; PURPOSE:
;	Returns the fields associated with a POINT object.  This is a 
;	convenient way of getting multiple fields in one call, and only a 
;	single event is generated.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	pnt_get, ptd, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	ptd:	POINT object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	POINT object fields to set.
;
;	condition:	Structure specifing a mask and a condition with which to
;			match flag values.  The structure must contain the fields
;			MASK and STATE.  MASK is a bitmask to test against
;			the flags field of the POINT object, and STATE
;			is either PS_TRUE and PS_FALSE.  Note that in this case, 
;			the values will be returned as a list, with no separation 
;			into nv and nt dimensions.
;
;	cat:		If set, arrays from mulitple input objets are 
;			concatenated.
;
;	<condition>:	All of the predefined conditions (e.g. /visible) are 
;			accepted; see pnt_condition_keywords.include.
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
pro pnt_get, ptd, cat=cat, condition=condition, nv=nv, nt=nt, $
              points=points, vectors=vectors, flags=flags, $
              name=name, desc=desc, input=input, data=data, tags=tags, $
              udata=udata, uname=uname, assoc_idp=assoc_idp, noevent=noevent, $
@pnt_condition_keywords.include
end_keywords

 condition = pnt_condition(condition=condition, $
@pnt_condition_keywords.include 
end_keywords)

 nv_notify, ptd, type = 1, noevent=noevent

 if(arg_present(points)) then points = pnt_points(ptd, cat=cat, condition=condition, /noevent)
 if(arg_present(vectors)) then vectors = pnt_vectors(ptd, cat=cat, condition=condition, /noevent)
 if(arg_present(flags)) then flags = pnt_flags(ptd, /noevent, cat=cat, condition=condition)
 if(arg_present(name)) then name = cor_name(ptd, /noevent)
 if(arg_present(desc)) then desc = pnt_desc(ptd, /noevent)
 if(arg_present(input)) then input = pnt_input(ptd, /noevent)
 if(arg_present(data)) then data = pnt_data(ptd, cat=cat, condition=condition, /noevent)
 if(arg_present(tags)) then tags = pnt_tags(ptd, /noevent)
 if(arg_present(assoc_idp)) then assoc_idp = pnt_assoc_idp(ptd, /noevent)
 if(arg_present(udata)) then udata = cor_udata(ptd, uname, /noevent)
 if(arg_present(nv)) then nv = pnt_nv(ptd, /noevent, condition=condition)
 if(arg_present(nt)) then nt = pnt_nt(ptd, /noevent, condition=condition)

end
;===========================================================================



