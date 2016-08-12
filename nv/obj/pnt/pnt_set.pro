;=============================================================================
;+
; points:
;	pnt_set
;
;
; PURPOSE:
;	Replaces fields in a POINT object.  This is a convenient way of
;	setting multiple fields in one call, and only a single event is 
;	generated.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	pnt_set, ptd, <keywords>=<values>
;
;
; ARGUMENTS:
;  INPUT:
;	ptd:		POINT object.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<keywords>:	POINT fields to set.
;
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
;	pnt_set_*
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		12/2015
;	
;-
;=============================================================================
pro pnt_set, ptd, points=points, vectors=vectors, flags=flags, $
                 name=name, desc=desc, input=input, data=data, tags=tags, $
                 udata=udata, uname=uname, assoc_xd=assoc_xd, noevent=noevent

 if(defined(points)) then pnt_set_points, ptd, points, /noevent
 if(defined(vectors)) then pnt_set_vectors, ptd, vectors, /noevent
 if(defined(flags)) then pnt_set_flags, ptd, flags, /noevent
 if(defined(name)) then cor_set_name, ptd, name, /noevent
 if(defined(desc)) then pnt_set_desc, ptd, desc, /noevent
 if(defined(input)) then pnt_set_input, ptd, input, /noevent
 if(defined(data)) then pnt_set_data, ptd, data, /noevent
 if(defined(tags)) then pnt_set_tags, ptd, tags, /noevent
 if(defined(assoc_xd)) then cor_set_assoc_xd, ptd, assoc_xd, /noevent
 if(defined(udata)) then cor_set_udata, ptd, udata, uname, /noevent

 nv_notify, ptd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
